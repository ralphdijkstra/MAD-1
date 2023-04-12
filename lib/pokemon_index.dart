import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_result_pokemon_list.dart';
import 'pokemon_details.dart';

Future<ApiResultPokemonList> getAllPokemon(
    {String url = 'https://pokeapi.co/api/v2/pokemon'}) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    dynamic decode = json.decode(response.body);
    ApiResultPokemonList result = ApiResultPokemonList.fromJson(decode);

    return result;
  } else {
    return const ApiResultPokemonList(
        count: 0, next: '', previous: '', results: null);
  }
}

// A function that converts a response body into a List<Pokemon>.
class PokemonIndex extends StatefulWidget {
  const PokemonIndex({Key? key}) : super(key: key);

  @override
  State<PokemonIndex> createState() => _PokemonIndexState();
}

class _PokemonIndexState extends State<PokemonIndex> {
  late Future<ApiResultPokemonList> apiResult;

  @override
  void initState() {
    apiResult = getAllPokemon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiResultPokemonList>(
      future: apiResult,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return pokemonIndexContent(snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget pokemonIndexContent(ApiResultPokemonList result) {

    Row backAndForward = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (result.previous != null) {
                setState(() {
                  apiResult = getAllPokemon(url: result.previous.toString());
                });
              }
            },
            child: Container(
              color: result.previous == null ? Colors.grey : Colors.green,
              margin: const EdgeInsets.fromLTRB(0, 20, 5, 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (result.next != null) {
                setState(() {
                  apiResult = getAllPokemon(url: result.next.toString());
                });
              }
            },
            child: Container(
              color: result.next == null ? Colors.grey : Colors.green,
              margin: const EdgeInsets.fromLTRB(0, 20, 5, 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: result.results?.length ?? 0,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PokemonDetails(
                          url: result.results?[index].url as String
                        ),
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                  padding: const EdgeInsets.all(5),
                  color: const Color.fromRGBO(0, 0, 0, 1),
                  child: Text(
                    '${result.results?[index].name}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        backAndForward,
      ],
    );
  }
}
