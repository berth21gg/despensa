class Actor {
  final int id;
  final String name;
  final String profilePath;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
    );
  }
}
