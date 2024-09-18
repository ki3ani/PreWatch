import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Trailer App'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Search Movies'),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
      ),
    );
  }
}