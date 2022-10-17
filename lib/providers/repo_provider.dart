import 'package:flutter/material.dart';
import 'package:movie_provider/models/movie_detail.dart';
import 'package:movie_provider/models/now_showing.dart';
import 'package:movie_provider/services/movie_api.dart';

class DataProvider extends ChangeNotifier {}

enum MovieState { initial, loading, loaded, error }

class MovieProvider extends ChangeNotifier {
  MovieState _movieState = MovieState.initial;
  List<NowShowingModel> movies = [];
  String message = '';

  MovieProvider() {
    _fetchMovie();
  }

  MovieState get movieState => _movieState;

  Future<void> _fetchMovie() async {
    _movieState = MovieState.loading;
    try {
      final apimovies = await MovieApi.instance!.getNowShowing();
      movies = apimovies;
      _movieState = MovieState.loaded;
      notifyListeners();
    } catch (e) {
      message = '$e';
      _movieState = MovieState.error;
    }
    notifyListeners();
  }
}

class MovieDetailProvider extends ChangeNotifier {
  MovieState _movieState = MovieState.initial;
  MovieDetailModel? movieDetail;
  String message2 = '';

  MovieState get movieState2 => _movieState;

  Future<void> fetchMovieDetail(int id) async {
    // print(id);
    _movieState = MovieState.loading;
    try {
      final apimovies = await MovieApi.instance?.getMovieDetail(id);
      // print(apimovies?.id);
      movieDetail = apimovies;
      _movieState = MovieState.loaded;
    } catch (e) {
      message2 = '$e';
      _movieState = MovieState.error;
    }
    notifyListeners();
  }
}
