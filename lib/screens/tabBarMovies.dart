import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/favorite_movies_screen.dart';
import 'package:pmsn2024/screens/popular_movies_screen.dart';

class TabBarMovies extends StatefulWidget {
  const TabBarMovies({super.key});

  @override
  State<TabBarMovies> createState() => _TabBarMoviesState();
}

class _TabBarMoviesState extends State<TabBarMovies> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              new SliverAppBar(
                title: Text('TMDB'),
                pinned: true,
                floating: true,
                centerTitle: true,
                bottom: TabBar(
                  unselectedLabelColor: Colors.blueGrey[200],
                  labelColor: Colors.black,
                  indicatorColor: Color(0xFFF9AA33),
                  tabs: [
                    Tab(
                      text: 'Popular',
                    ),
                    Tab(
                      text: 'Favorites',
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              PopularMoviesScreen(),
              FavoriteMoviesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
