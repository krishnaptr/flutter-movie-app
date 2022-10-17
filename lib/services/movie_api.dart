import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_provider/models/movie_cast.dart';
import 'package:movie_provider/models/movie_detail.dart';
import 'package:movie_provider/models/movies_genre.dart';
import 'package:movie_provider/models/now_showing.dart';
import 'package:movie_provider/services/environment.dart';

class MovieApi {
  static MovieApi? _instance;

  MovieApi._(); // define constructor as private

  static MovieApi? get instance {
    _instance ??= MovieApi._();
    return _instance;
  }

  Future<List<NowShowingModel>> getNowShowing() async {
    try {
      final url =
          '${ApiService().baseUrl}/movie/now_playing?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final movies = json.decode(response.body)["results"] as List;
      List<NowShowingModel> movieList =
          movies.map((e) => NowShowingModel.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return movieList;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }

    return getNowShowing();
  }

  Future<List<NowShowingModel>> getPopular() async {
    try {
      final url =
          '${ApiService().baseUrl}/movie/popular?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final movies = json.decode(response.body)["results"] as List;
      List<NowShowingModel> movieList =
          movies.map((e) => NowShowingModel.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return movieList;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }

    return getPopular();
  }

  Future<List<GenreList>> getGenreList() async {
    try {
      final url =
          '${ApiService().baseUrl}/genre/movie/list?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final allGenres = json.decode(response.body)["genres"] as List;
      List<GenreList> allGenreList = allGenres
          .map((e) => GenreList(id: e["id"], name: e["name"]))
          .toList();
      if (response.statusCode == 200) {
        return allGenreList;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
    return getGenreList();
  }

  Future<List<NowShowingModel>> getMovieByGenre(int genreId) async {
    try {
      final url =
          '${ApiService().baseUrl}/discover/movie?${ApiService().apiKey}&with_genres=$genreId';
      final response = await http.get(Uri.parse(url));
      final moviesGenres = json.decode(response.body)["results"] as List;
      List<NowShowingModel> movieGenreList =
          moviesGenres.map((e) => NowShowingModel.fromJson(e)).toList();
      if (response.statusCode == 200) {
        return movieGenreList;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }

    return getPopular();
  }

  Future<MovieDetailModel> getMovieDetail(int movieid) async {
    try {
      // await Future.delayed(const Duration(seconds: 1));
      final url =
          '${ApiService().baseUrl}/movie/$movieid?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final resDecode = json.decode(response.body);
      MovieDetailModel movieDetail = MovieDetailModel.fromJson(resDecode);

      movieDetail.genres = await getGenreByMovieId(movieid);
      movieDetail.castList = await getMovieCastById(movieid);
      movieDetail.trailerId = await getMovieYoutubeTrailer(movieid);
      return movieDetail;
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  Future<List<Genre>> getGenreByMovieId(int movieId) async {
    try {
      final url =
          '${ApiService().baseUrl}/movie/$movieId?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final genres = json.decode(response.body)["genres"] as List;
      List<Genre> genreList =
          genres.map((e) => Genre(id: e['id'], name: e['name'])).toList();
      if (response.statusCode == 200) {
        return genreList;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }

    return getGenreByMovieId(movieId);
  }

  Future<List<Cast>> getMovieCastById(int movieId) async {
    try {
      final url =
          '${ApiService().baseUrl}/movie/$movieId/credits?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final cast = json.decode(response.body)["cast"] as List;
      List<Cast> castList = cast
          .map((e) => Cast(
              id: e['id'],
              name: e['name'],
              profilePath: e['profile_path'],
              knownForDepartment: e['known_for_department']))
          .toList();
      if (response.statusCode == 200) {
        return castList;
      }
    } catch (e) {
      return throw Exception(e.toString());
    }

    return getMovieCastById(movieId);
  }

  Future<String> getMovieYoutubeTrailer(int movieid) async {
    try {
      final url =
          '${ApiService().baseUrl}/movie/$movieid/videos?${ApiService().apiKey}';
      final response = await http.get(Uri.parse(url));
      final youtubeId =
          json.decode(response.body)["results"][0]["key"] as String;
      return youtubeId;
    } catch (e) {
      return throw Exception(e.toString());
    }
  }
}
