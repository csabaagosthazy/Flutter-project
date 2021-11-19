import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project Group 2',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to our App'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}