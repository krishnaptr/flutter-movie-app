import 'package:flutter/material.dart';
import 'package:movie_provider/models/now_showing.dart';
import 'package:movie_provider/services/movie_api.dart';

enum PopularMovieState { initial, loading, loaded, error }

class PopularMovieProvider extends ChangeNotifier {
  PopularMovieState _popularmovieState = PopularMovieState.initial;
  List<NowShowingModel> moviesPopular = [];
  String messagePopular = '';

  PopularMovieProvider() {
    _fetchPopularMovie();
  }

  PopularMovieState get popularmovieState => _popularmovieState;

  Future<void> _fetchPopularMovie() async {
    _popularmovieState = PopularMovieState.loading;
    try {
      final apimovies = await MovieApi.instance!.getPopular();
      moviesPopular = apimovies;
      _popularmovieState = PopularMovieState.loaded;
      notifyListeners();
    } catch (e) {
      messagePopular = '$e';
      _popularmovieState = PopularMovieState.error;
    }
    notifyListeners();
  }
}
