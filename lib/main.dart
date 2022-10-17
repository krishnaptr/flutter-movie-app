import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_provider/providers/bottom_navigatior/bottom_navigation.dart';
import 'package:movie_provider/providers/movies/genres_movie.dart';
import 'package:movie_provider/providers/movies/movie_by_genre.dart';
import 'package:movie_provider/providers/movies/popupar_movie.dart';
import 'package:movie_provider/providers/repo_provider.dart';
import 'package:movie_provider/screens/home/home_screen.dart';
import 'package:movie_provider/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => BottomNavigation(),
    ),
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MovieDetailProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => PopularMovieProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => GenreMovieProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MovieByGenreProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen()
      },
    );
  }
}
