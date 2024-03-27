import 'dart:convert';

import 'package:pmsn2024/model/actor_model.dart';
import 'package:http/http.dart' as http;
import 'package:pmsn2024/model/genre_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/trailer_model.dart';
import 'package:pmsn2024/network/endpoints.dart';

Future<List<Actor>> fetchCredits(int movieId) async {
  final response =
      await http.get(Uri.parse(Endpoints.getCreditsEndpoint(movieId)));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> cast = data['cast'];
    return cast.map((json) => Actor.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load actors');
  }
}

Future<List<MovieTrailer>> fetchMovieTrailers(int movieId) async {
  final response =
      await http.get(Uri.parse(Endpoints.getMovieTrailerEndpoint(movieId)));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> results = data['results'];

    // Filtrar solo los trailers oficiales (si hay)
    final officialTrailers =
        results.where((trailer) => trailer['official'] == true);
    // De lo contrario, utilizamos todos los trailers disponibles
    final trailersToUse =
        officialTrailers.isNotEmpty ? officialTrailers : results;

    return trailersToUse
        .map((trailerJson) => MovieTrailer.fromJson(trailerJson))
        .toList();
  } else {
    throw Exception('Failed to load trailers');
  }
}

Future<void> addToFavorites(int movieId, bool isFavorite) async {
  final Map<String, dynamic> body = {
    "media_type": "movie",
    "media_id": movieId,
    "favorite": isFavorite
  };

  final response = await http.post(
      Uri.parse(Endpoints.addToFavoritesEndpoint()),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body));

  if (response.statusCode == 201) {
    print('Movie added to favorites successfully');
  } else if (response.statusCode == 200) {
    print('Movie removed from favorites successfully');
  } else {
    throw Exception(
        'Failed to ${response.statusCode == 201 ? "add" : "remove"} movie from favorites');
  }
}

Future<List<PopularModel>> getFavoriteMovies() async {
  final response =
      await http.get(Uri.parse(Endpoints.getFavoriteMoviesEndpoint()));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['results'];
    return data.map((json) => PopularModel.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load favorite movies');
  }
}

Future<List<MovieGenre>> getMovieGenres() async {
  final response =
      await http.get(Uri.parse(Endpoints.getMovieGenresEndpoint()));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> genres = data['genres'];

    return genres.map((json) => MovieGenre.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load genres');
  }
}
