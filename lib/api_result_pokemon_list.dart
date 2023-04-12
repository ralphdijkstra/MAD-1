class ApiResultPokemonList {
  final int count;
  final String? next;     // moet nullable zijn, want url kan leeg zijn
  final String? previous;

  final List<ApiPokemon>? results;

  const ApiResultPokemonList({
    required this.count,
    required this.next,
    required this.previous,
    this.results,
  });

  factory ApiResultPokemonList.fromJson(Map<String, dynamic> json) {
    List<ApiPokemon> pokemonList = json['results']
        .map<ApiPokemon>(
            (json) => ApiPokemon.fromJson(json))
        .toList();

    return
      ApiResultPokemonList(
          count: json['count'],
          next: json['next'],
          previous: json['previous'],
          results: pokemonList
      );
  }
}

class ApiPokemon {
  final String name;
  final String url;

  const ApiPokemon({
    required this.name,
    required this.url,
  });

  factory ApiPokemon.fromJson(Map<String, dynamic> json) {
    return
      ApiPokemon(
        name: json['name'],
        url: json['url'],
      );
  }
}