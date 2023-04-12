import 'package:flutter/material.dart';

import 'pokemon_home.dart';
import 'pokemon_index.dart';

class PokemonApp extends StatelessWidget {
  const PokemonApp({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white24,
          appBar: AppBar(title: const Text('All your Pokemon'), backgroundColor: Colors.green),
          body: const TabBarView(
            children: [ PokemonHome(), PokemonIndex(),],
          ),
          bottomNavigationBar: const TabBar(
            labelColor: Colors.green,
            tabs: [
              Tab(text: 'Home', icon: Icon(Icons.home, color: Colors.lightGreenAccent,),),
              Tab(text: 'Index', icon: Icon(Icons.sports_baseball, color: Colors.lightGreenAccent,),),
            ],
          ),
        )
    );
  }
}