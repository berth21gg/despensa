import 'package:flutter/material.dart';
import 'package:pmsn2024/model/funtion.dart';
import 'package:pmsn2024/model/popular_model.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  State<FavoriteMoviesScreen> createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  late Future<List<PopularModel>> _getFavorites;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFavorites = getFavoriteMovies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getFavorites,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/detail",
                          arguments: snapshot.data![index])
                      .then((_) {
                    setState(() {
                      _getFavorites =
                          getFavoriteMovies(); // Actualizar el estado
                    });
                  }),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: '${snapshot.data![index].title}',
                      child: FadeInImage(
                        placeholder: AssetImage('images/loading.gif'),
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}',
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Ocurrio un error'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
