import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn2024/model/actor_model.dart';
import 'package:pmsn2024/model/funtion.dart';
import 'package:pmsn2024/model/genre_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/trailer_model.dart';
import 'package:pmsn2024/widgets/custom_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  final PopularModel popularModel;

  const DetailMovieScreen({super.key, required this.popularModel});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  final List<Actor> actors = [];
  late Future<List<MovieTrailer>> _fetchTrailers;
  bool isFavorite = false;
  late Future<List<MovieGenre>> _fetchGenres;

  @override
  void initState() {
    super.initState();
    fetchCredits(widget.popularModel.id!).then((data) {
      setState(() {
        actors.addAll(data);
      });
    });
    _fetchTrailers = fetchMovieTrailers(widget.popularModel.id!);
    _fetchGenres = getMovieGenres();
  }

  // Función para verificar si la película está en fav
  Future<void> checkIfFavorite() async {
    try {
      // Obtener la lista de películas favoritas
      final List<PopularModel> favoriteMovies = await getFavoriteMovies();
      // Verificar si la película esta en la lista
      if (favoriteMovies.any((movie) => movie.id == widget.popularModel.id)) {
        setState(() {
          isFavorite = true;
        });
      } else {
        setState(() {
          isFavorite = false;
        });
      }
    } catch (e) {
      _showErrorMessage('Error al verificar si la película está en favoritos');
    }
  }

  // Función para agregar o quitar de favoritos
  Future<void> toggleFavorite() async {
    if (isFavorite) {
      // Eliminar de favoritos
      try {
        await addToFavorites(widget.popularModel.id!, false);
        setState(() {
          isFavorite = false;
        });
      } catch (e) {
        _showErrorMessage('Error al quitar película de favoritos');
      }
    } else {
      // Agregar a favoritos
      try {
        await addToFavorites(widget.popularModel.id!, true);
        setState(() {
          isFavorite = true;
        });
      } catch (e) {
        _showErrorMessage('Error al agregar película a favoritos');
      }
    }
  }

  // Método para mostrar un mensaje de error
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si la película esta en favoritos
    checkIfFavorite();
    //final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final popularModel = widget.popularModel;

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo difuminada
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500/${popularModel.backdropPath}',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          // Contenedor al centro de la pantalla
          Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 175, 16, 32),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 150.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      popularModel.title!,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${popularModel.releaseDate}',
                                      style: TextStyle(
                                          color: Colors.blueGrey[400]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.star,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      '${NumberFormat("#0.0").format(popularModel.voteAverage)}/10',
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: toggleFavorite,
                                      icon: Icon(isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      color: isFavorite
                                          ? Colors.pink
                                          : Theme.of(context).iconTheme.color,
                                      iconSize: 30,
                                    ),
                                    Text('Favorite')
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _openTrailerPlayer();
                                      },
                                      icon: Icon(Icons.play_circle),
                                      color: Theme.of(context).iconTheme.color,
                                      iconSize: 30,
                                    ),
                                    Text('Trailer')
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 16.0, 4.0),
                            child: SizedBox(
                              height: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Overview',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    popularModel.overview!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // const Spacer(),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 8.0),
                                  //   child: Text(
                                  //     'Release date: ${popularModel.releaseDate}',
                                  //     style: const TextStyle(
                                  //         fontSize: 20,
                                  //         fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Genres',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: FutureBuilder<List<MovieGenre>>(
                                    future: _fetchGenres,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        final List<MovieGenre> movieGenres =
                                            snapshot.data!;
                                        final List<String> matchedGenres = [];

                                        for (final genreId
                                            in popularModel.genreIds!) {
                                          final matchedGenre =
                                              movieGenres.firstWhere(
                                            (genre) => genre.id == genreId,
                                            orElse: () =>
                                                MovieGenre(id: -1, name: ''),
                                          );
                                          if (matchedGenre.name.isNotEmpty) {
                                            matchedGenres
                                                .add(matchedGenre.name);
                                          }
                                        }

                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              popularModel.genreIds!.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Chip(
                                                label:
                                                    Text(matchedGenres[index]),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 4, 16.0, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cast',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: actors.length,
                                    itemBuilder: (context, index) {
                                      final actor = actors[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipOval(
                                                child: FadeInImage(
                                                  placeholder: const AssetImage(
                                                      'images/loading2.gif'), // Imagen de carga
                                                  image: NetworkImage(
                                                      'https://image.tmdb.org/t/p/w500/${actor.profilePath}'), // Imagen final
                                                  fit: BoxFit.cover,
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Image.asset(
                                                      'images/default_avatar.jpg',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              actor.name.length <= 9
                                                  ? actor.name
                                                  : actor.name.substring(0, 8) +
                                                      '...',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 40,
                  child: Hero(
                    tag: '${popularModel.title}',
                    child: Container(
                      width: 130,
                      height: 190,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}',
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Funcion para abrir el reproductor de trailer
  void _openTrailerPlayer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FutureBuilder(
          future: _fetchTrailers,
          builder: (context, AsyncSnapshot<List<MovieTrailer>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data!.isNotEmpty) {
              return Scaffold(
                // appBar: AppBar(
                //   title: Text(
                //     'Reproductor de Trailer',
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   backgroundColor: const Color(0xFF232F34),
                // ),
                backgroundColor: const Color(0xFF344955),
                body: Stack(
                  children: [
                    Positioned(
                      top: kToolbarHeight,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomButton(
                            onTap: () => Navigator.pop(context),
                            color: const Color(0xFFF9AA33),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: snapshot.data![0].key,
                          flags: YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Color(0xFFF9AA33),
                        progressColors: ProgressBarColors(
                          playedColor: Colors.yellow,
                          handleColor: Color(0xFFF9AA33),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                (snapshot.hasError || snapshot.data!.isEmpty)) {
              return Center(
                child: Text('No se encontró un trailer para esta pelicula.'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
