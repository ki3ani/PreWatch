import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/movie_details_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MovieTrailerApp(),
    ),
  );
}

class MovieTrailerApp extends StatelessWidget {
  const MovieTrailerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Movie Trailer App',
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/search': (context) => const SearchScreen(),
            '/movie_details': (context) => const MovieDetailsScreen(),
          },
        );
      },
    );
  }
}