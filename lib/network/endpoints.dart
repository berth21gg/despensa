import 'package:pmsn2024/constants/api_constants.dart';

class Endpoints {
  static String getCreditsEndpoint(int movieId) {
    return '$TMDB_API_BASE_URL/movie/$movieId/credits?api_key=$TMDB_API_KEY';
  }

  static String getMovieTrailerEndpoint(int movieId) {
    return '$TMDB_API_BASE_URL/movie/$movieId/videos?api_key=$TMDB_API_KEY';
  }

  static String addToFavoritesEndpoint() {
    return '$TMDB_API_BASE_URL/account/$TMDB_ACCOUNT_ID/favorite?api_key=$TMDB_API_KEY&session_id=$TMDB_SESSION_ID';
  }

  static String getFavoriteMoviesEndpoint() {
    return '$TMDB_API_BASE_URL/account/$TMDB_ACCOUNT_ID/favorite/movies?api_key=$TMDB_API_KEY&session_id=$TMDB_SESSION_ID';
  }

  static String getMovieGenresEndpoint() {
    return '$TMDB_API_BASE_URL/genre/movie/list?api_key=$TMDB_API_KEY';
  }
}
