import 'package:flutter/material.dart';

import 'lastfmindexpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opdracht 20',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LastFmIndexPage(),
    );
  }
}


