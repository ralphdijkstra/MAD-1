import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'track.dart' show Track;

// getAllTracks zoekt leest alle tracks met de opgegeven titel en
// zet het resultaat in een Future<List<Track>>
final String _apiKeyVoorLastFM = '960317a546f9228a8e0d001de0308cfd';

// LastFmIndexPage is de main page voor het LastFm overzicht
// - bovenste deel, de lijst met titels (initieel leeg)
// - onderste deel, zoekveld + knop

class LastFmIndexPage extends StatefulWidget {
  const LastFmIndexPage({Key? key}) : super(key: key);

  @override
  State<LastFmIndexPage> createState() => _LastFmIndexPageState();
}

class _LastFmIndexPageState extends State<LastFmIndexPage> {
  final TextEditingController _searchFieldController =
      new TextEditingController();

  int _page = 1;
  int _lastPage = 0;

  // Maak een lege Future<List<Track>>
  Future<List<Track>> futureTracks = Future(() => <Track>[]);

  Future<List<Track>> getAllTracks(String searchTitle, int page) async {
    String api = 'http://ws.audioscrobbler.com/2.0/'
        '?method=track.search'
        '&track=${searchTitle}'
        '&page=$page'
        '&api_key=$_apiKeyVoorLastFM'
        '&format=json';
    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      dynamic decode = json.decode(response.body);
      List<Track> tracks = json
          .decode(response.body)['results']['trackmatches']['track']
          .map<Track>((track) => Track.fromJson(track))
          .toList();
      int? startPage = int.tryParse(decode['results']['opensearch:Query']['startPage']);
      int? totaal = int.tryParse(decode['results']['opensearch:totalResults']);
      int? perPage = int.tryParse(decode['results']['opensearch:itemsPerPage']);

      setState(() {
        if (startPage == null){
          _page = 1;
        } else {
        _page = startPage;
        }
        if (totaal == null || perPage == null) {
          _lastPage = 0;
        } else {
          _lastPage = totaal ~/ perPage;
        }
      });
      print(_page);
      print(_lastPage);
      return tracks;
    } else {
      return <Track>[];
    }
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  void zoek() {
    if (_searchFieldController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            content: Text('Type een titel in')));
    } else {
      setState(() {
        futureTracks = getAllTracks(_searchFieldController.text, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Last FM'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expand is nodig, omdat flutter de FutureBuilder anders uitbreidt
            // tot over de grenzen van de zichtbare plek
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // FutureBuilder verwerkt een future.
                  children: [
                    Expanded(
                      child: FutureBuilder<List<Track>>(
                        // future bevat een Future, hier een Future<List<Track>>
                        future: futureTracks,
                        // builder is een functie met een context en een snapshot
                        // De snapshot bevat de data van de future
                        builder: (context, snapshot) {
                          // Als de snapshot data heeft, zet de gegevens uit de List
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                        duration: Duration(seconds: 3),
                                        content:
                                            Text(snapshot.data![index].name))),
                                  child: Container(
                                    color: Colors.greenAccent,
                                    margin: EdgeInsets.fromLTRB(2, 4, 2, 3),
                                    child: Text(
                                      snapshot.data![index].artist,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          // Als de snapshot geen data heeft en er was een fout, toon de fout
                          else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: ElevatedButton(
                            onPressed: _page > 1
                                ? () {
                                    _page--;
                                    setState(() {
                                      futureTracks = getAllTracks(
                                          _searchFieldController.text, _page);
                                    });
                                  }
                                : null,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: ElevatedButton(
                            onPressed: _page < _lastPage
                                ? () {
                                    _page++;
                                    setState(() {
                                      futureTracks = getAllTracks(
                                          _searchFieldController.text, _page);
                                    });
                                  }
                                : null,
                            child: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchFieldController,
                    decoration: InputDecoration(
                        labelText: 'Type hier de titel die je wilt opzoeken'),
                  ),
                ),
                GestureDetector(
                  onTap: () => zoek(),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: const Text(
                        'Zoek',
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  void test() {
    Map<String, dynamic> xxx = jsonDecode("[response.body]");
  }

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Map<String, dynamic> Json = jsonDecode(response.body);
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
