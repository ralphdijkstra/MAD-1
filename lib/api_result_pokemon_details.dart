class ApiResultPokemonDetails {
  final String name;
  final String afbeelding;
  final List<String> stats;

  const ApiResultPokemonDetails({
    required this.name,
    required this.afbeelding,
    required this.stats,
  });

  factory ApiResultPokemonDetails.fromJson(Map<String, dynamic> json) {
    List<String> statsList = <String>[];
    for (Map<String, dynamic> stat in json['stats']) {
      statsList.add(stat['stat']['name']);
    }
    return ApiResultPokemonDetails(
      name: json['name'],
      afbeelding: json['sprites']['other']['official-artwork']['front_default'],
      stats: statsList,
    );
  }
}
