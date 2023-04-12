import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_result_pokemon_details.dart';

Future<ApiResultPokemonDetails> getPokemonDetails(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    dynamic decode = json.decode(response.body);
    ApiResultPokemonDetails result = ApiResultPokemonDetails.fromJson(decode);

    return result;
  } else {
    return const ApiResultPokemonDetails(name: '', afbeelding: '', stats: <String>[]);
  }
}

class PokemonDetails extends StatefulWidget {
  const PokemonDetails({key, required this.url}) : super(key: key);
  final String url;

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  late Future<ApiResultPokemonDetails> pokemonDetails;

  @override
  void initState() {
    pokemonDetails = getPokemonDetails(widget.url);
    super.initState();
  }

  Widget showDetails(ApiResultPokemonDetails pokemonDetails) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: AppBar(title: Text(pokemonDetails.name)),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.network(
          pokemonDetails.afbeelding,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.scaleDown,
        ),
            const Text(
            'Stats: ',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 45,
                fontWeight: FontWeight.bold),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: pokemonDetails.stats.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  pokemonDetails.stats[index],
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResultPokemonDetails>(
        future: pokemonDetails,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return showDetails(snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
