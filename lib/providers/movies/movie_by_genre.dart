import 'package:flutter/material.dart';
import 'package:movie_provider/models/now_showing.dart';
import 'package:movie_provider/services/movie_api.dart';

enum MovieByGenreState { initial, loading, loaded, error }

class MovieByGenreProvider extends ChangeNotifier {
  MovieByGenreState _genremovieByIdState = MovieByGenreState.initial;
  List<NowShowingModel> moviesbyGenres = [];
  String messageGenreById = '';

  MovieByGenreState get genremovieByIdState => _genremovieByIdState;

  Future<void> fetchMovieBasedOnGenre(int genreId) async {
    _genremovieByIdState = MovieByGenreState.loading;
    try {
      final apimovies = await MovieApi.instance!.getMovieByGenre(genreId);
      moviesbyGenres = apimovies;
      _genremovieByIdState = MovieByGenreState.loaded;
      notifyListeners();
    } catch (e) {
      messageGenreById = '$e';
      _genremovieByIdState = MovieByGenreState.error;
    }
    notifyListeners();
  }
}
