import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String baseUrl = 'http://192.168.100.3:8000';
  // final String baseUrl = 'http://localhost:8000'; // Use this for iOS simulator or web

  Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/movies/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}