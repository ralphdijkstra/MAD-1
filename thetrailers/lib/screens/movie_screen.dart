import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thetrailers/movie.dart';
import 'package:thetrailers/movie_details_screen.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = fetchMovies();
  }

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=333082962a4e7d4318301d52f2d24798&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=28'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['results'] as List<dynamic>;
      final movies = jsonData
          .where((json) => json['media_type'] != 'tv')
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies')),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CarouselSlider.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                final movie = snapshot.data![itemIndex];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(movie.getPosterUrl()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 600,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  // TODO: add onPageChanged implementation
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
