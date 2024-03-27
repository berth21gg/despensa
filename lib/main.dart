import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/screens/tabBarMovies.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/screens/despensa_screen.dart';
import 'package:pmsn2024/screens/detail_movie_screen.dart';
import 'package:pmsn2024/screens/products_firebase_screen.dart';
import 'package:pmsn2024/screens/splash_screen.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';
import 'package:pmsn2024/settings/theme.dart';

void main() async {
  //integración
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyDLKNtocYxdxcYs6aAX6kxc_I8oOLDVFaI", // paste your api key here
      appId:
          "1:205354455751:android:ff45d71c68f6450d4be4e2", //paste your app id here
      messagingSenderId: "205354455751", //paste your messagingSenderId here
      projectId: "pmsn2024-87bbf", //paste your project id here
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: value
                ? ThemeApp.darkTheme(context)
                : ThemeApp.lightTheme(context),
            home: SplashScreen(),
            routes: {
              "/dash": (BuildContext context) => DashboardScreen(),
              "/despensa": (BuildContext context) => DespensaScreen(),
              "/movies": (BuildContext context) => TabBarMovies(),
              "/detail": (BuildContext context) => DetailMovieScreen(
                    popularModel: ModalRoute.of(context)!.settings.arguments
                        as PopularModel,
                  ),
              "/products": (BuildContext context) => ProductsFirebaseScreen(),
              //Agregar ruta de register
            },
          );
        });
  }
}
