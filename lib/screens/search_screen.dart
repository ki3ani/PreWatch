import 'package:flutter/material.dart';
import '../services/movie_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MovieService _movieService = MovieService();
  List<dynamic> _searchResults = [];

  void _performSearch() async {
    if (_searchController.text.isEmpty) return;
    try {
      final results = await _movieService.searchMovies(_searchController.text);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a movie',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  title: Text(movie['title']),
                  subtitle: Text(movie['overview'], maxLines: 2, overflow: TextOverflow.ellipsis),
                  leading: movie['poster_path'] != null
                      ? Image.network(movie['poster_path'], width: 50, height: 75, fit: BoxFit.cover)
                      : null,
                  onTap: () {
                    Navigator.pushNamed(context, '/movie_details', arguments: movie['id']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}