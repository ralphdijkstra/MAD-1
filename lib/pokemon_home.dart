import 'dart:async';

import 'package:flutter/material.dart';

class PokemonHome extends StatefulWidget {
  const PokemonHome({Key? key}) : super(key: key);

  @override
  State<PokemonHome> createState() => _PokemonHomeState();
}

class _PokemonHomeState extends State<PokemonHome> {
  bool leftToRight = true;
  bool topToBottom = true;
  double breedte = 0;
  double hoogte = 0;
  final double _height = 100;
  final double _width = 100;
  double _left = 0;
  double _top = 0;
  double _horizontal = 10;
  double _vertical = 15;

  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 20), (Timer timer) {
      if (leftToRight) {
        double left = _left;
        double top = _top;

        left = _left + _horizontal;
        if (left < 0) {
          left = 0;
          _horizontal = -1 * _horizontal;
        }
        if (left + _width > breedte) {
          left = breedte - _width;
          _horizontal = -1 * _horizontal;
        }

        top = _top + _vertical;
        if (top < 0) {
          top = 0;
          _vertical = -1 * _vertical;
        }
        if (top + _width > hoogte) {
          top = hoogte - _width;
          _vertical = -1 * _vertical;
        }

        setState(() {
          _left = left;
          _top = top;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // Voorkom memory leaks
    _timer.cancel();
    super.dispose();
  }

  Widget achtergrond() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/home.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: Text(
          'Pokemon',
          style: TextStyle(
              color: Colors.purple, fontSize: 60, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (breedte == 0) {
      breedte = MediaQuery.of(context).size.width;
      hoogte = MediaQuery.of(context).size.height;
    }

    return Stack(
      children: [
        achtergrond(),
        Positioned(
          height: _height,
          width: _width,
          top: _top,
          left: _left,
          child: Image.asset('assets/images/pokeball.png'),
        )
      ],
    );
  }
}
