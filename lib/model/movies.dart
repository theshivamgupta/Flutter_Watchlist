final String tableMovies = 'movies';

class MovieFields {
  static final List<String> values = [
    /// Add all fields
    id, name, directorName, poster
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String directorName = 'directorName';
  static final String poster = 'poster';
  static final String time = 'time';
}

class Movie {
  final int? id;
  final String name;
  final String directorName;
  final String poster;
  final DateTime createdTime;

  const Movie({
    this.id,
    required this.name,
    required this.directorName,
    required this.poster,
    required this.createdTime,
  });

  Movie copy({
    int? id,
    String? name,
    String? directorName,
    String? poster,
    DateTime? createdTime,
  }) =>
      Movie(
        id: id ?? this.id,
        name: name ?? this.name,
        directorName: directorName ?? this.directorName,
        poster: poster ?? this.poster,
        createdTime: createdTime ?? this.createdTime,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
        id: json[MovieFields.id] as int?,
        name: json[MovieFields.name] as String,
        directorName: json[MovieFields.directorName] as String,
        poster: json[MovieFields.poster] as String,
        createdTime: DateTime.parse(json[MovieFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.name: name,
        MovieFields.directorName: directorName,
        MovieFields.poster: poster,
        MovieFields.time: createdTime.toIso8601String(),
      };
}
