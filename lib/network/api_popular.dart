import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsn2024/model/popular_model.dart';

class ApiPopular {
  Uri link = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=8833c0930ae5d4a9f1044f11abb248ca&language=es-MX&page=1');

  Future<List<PopularModel>?> getPopularMovie() async {
    var response = await http.get(link);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      return jsonResult
          .map((popular) => PopularModel.fromMap(popular))
          .toList();
    }

    return null;
  }
}
