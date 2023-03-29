class Track {
  final String name;
  final String artist;
  final String urlTrack;
  final int numberOfListeners;

  const Track({
    required this.name,
    required this.artist,
    required this.urlTrack,
    required this.numberOfListeners,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    int? listeners = int.tryParse(json['listeners']);
    if (listeners == null) {
      listeners = 0;
    }
    return Track(
      name: json['name'],
      artist: json['artist'],
      urlTrack: json['url'],
      numberOfListeners: listeners,
    );
  }
}