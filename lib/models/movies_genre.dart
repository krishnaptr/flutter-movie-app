// To parse this JSON data, do
//
//     final movieGenreListModel = movieGenreListModelFromJson(jsonString);

import 'dart:convert';

MovieGenreListModel movieGenreListModelFromJson(String str) =>
    MovieGenreListModel.fromJson(json.decode(str));

String movieGenreListModelToJson(MovieGenreListModel data) =>
    json.encode(data.toJson());

class MovieGenreListModel {
  MovieGenreListModel({
    this.genres,
  });

  List<GenreList>? genres;

  factory MovieGenreListModel.fromJson(Map<String, dynamic> json) =>
      MovieGenreListModel(
        genres: List<GenreList>.from(
            json["genres"].map((x) => GenreList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres!.map((x) => x.toJson())),
      };
}

class GenreList {
  GenreList({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory GenreList.fromJson(Map<String, dynamic> json) => GenreList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
