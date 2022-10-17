import 'package:flutter/material.dart';
import 'package:movie_provider/models/movies_genre.dart';
import 'package:movie_provider/services/movie_api.dart';

enum GenreMovieState { initial, loading, loaded, error }

class GenreMovieProvider extends ChangeNotifier {
  GenreMovieState _genremovieState = GenreMovieState.initial;
  List<GenreList> moviesGenres = [];
  String messageGenre = '';

  GenreMovieProvider() {
    _fetchGenreMovie();
  }

  GenreMovieState get genremovieState => _genremovieState;

  // GET ALL GENRE LIST
  Future<void> _fetchGenreMovie() async {
    _genremovieState = GenreMovieState.loading;
    try {
      final apimovies = await MovieApi.instance!.getGenreList();
      moviesGenres = apimovies;
      _genremovieState = GenreMovieState.loaded;
      notifyListeners();
    } catch (e) {
      messageGenre = '$e';
      _genremovieState = GenreMovieState.error;
    }
    notifyListeners();
  }
}
