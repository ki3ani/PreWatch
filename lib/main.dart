import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/movie_details_screen.dart';

void main() {
  runApp(const MovieTrailerApp());
}

class MovieTrailerApp extends StatelessWidget {
  const MovieTrailerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Trailer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/movie_details': (context) => const MovieDetailsScreen(),
      },
    );
  }
}