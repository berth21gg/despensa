class MovieTrailer {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool isOfficial;

  MovieTrailer({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.isOfficial,
  });

  factory MovieTrailer.fromJson(Map<String, dynamic> json) {
    return MovieTrailer(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      site: json['site'],
      type: json['type'],
      isOfficial: json['official'] ?? false,
    );
  }
}
