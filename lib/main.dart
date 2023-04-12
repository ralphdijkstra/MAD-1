import 'package:flutter/material.dart';
import 'pokemon_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Opdracht 21',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PokemonApp(title: 'Pokémon Index'),
    );
  }
}


