import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/502356-the-super-mario-bros-movie?api_key=333082962a4e7d4318301d52f2d24798&language=en-US'));
    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('${_data['original_title']}'),
        ),
        body: Center(
          child: Image.network(
            'https://image.tmdb.org/t/p/original/${_data['poster_path']}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
