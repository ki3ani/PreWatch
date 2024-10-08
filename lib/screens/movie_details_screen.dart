import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:auto_orientation/auto_orientation.dart';
import '../services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieService _movieService = MovieService();
  Map<String, dynamic>? _movieDetails;
  YoutubePlayerController? _controller;
  bool _isFullScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int movieId = ModalRoute.of(context)!.settings.arguments as int;
    _fetchMovieDetails(movieId);
  }

  void _fetchMovieDetails(int id) async {
    try {
      final details = await _movieService.getMovieDetails(id);
      setState(() {
        _movieDetails = details;
        _initializeYoutubePlayer();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _initializeYoutubePlayer() {
    final trailerUrl = _movieDetails?['trailer_url'];
    if (trailerUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(trailerUrl);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    AutoOrientation.portraitUpMode();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      AutoOrientation.landscapeAutoMode();
    } else {
      AutoOrientation.portraitUpMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_movieDetails == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Movie Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_isFullScreen) {
      return Scaffold(
        body: Center(
          child: YoutubePlayer(
            controller: _controller!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: [
              IconButton(
                icon: const Icon(Icons.fullscreen_exit),
                onPressed: _toggleFullScreen,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_movieDetails!['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_movieDetails!['poster_path'] != null)
              Image.network(_movieDetails!['poster_path']),
            const SizedBox(height: 16),
            Text(_movieDetails!['title'], style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 8),
            Text(_movieDetails!['overview']),
            const SizedBox(height: 16),
            if (_controller != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: _toggleFullScreen,
                  ),
                ],
              )
            else
              ElevatedButton(
                child: const Text('Watch Trailer'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Trailer URL: ${_movieDetails!['trailer_url'] ?? 'Not available'}')),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}