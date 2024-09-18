import 'package:flutter/material.dart';
import '../services/movie_service.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieService _movieService = MovieService();
  Map<String, dynamic>? _movieDetails;

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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
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
            ElevatedButton(
              child: const Text('Watch Trailer'),
              onPressed: () {
                // TODO: Implement trailer playback
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