import 'package:flutter/material.dart';
import 'package:movie_provider/models/movies_genre.dart';
import 'package:movie_provider/providers/movies/genres_movie.dart';
import 'package:movie_provider/providers/movies/movie_by_genre.dart';
import 'package:movie_provider/screens/movies/detail/movies_detail.dart';
import 'package:movie_provider/styles/constants.dart';
import 'package:movie_provider/utils/badges.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key, required this.selectedGenre}) : super(key: key);

  final int selectedGenre;
  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final ScrollController _childScrollController = ScrollController();
  final ScrollController _parentScrollController = ScrollController();
  int? selectedGenre;

  @override
  void initState() {
    selectedGenre = widget.selectedGenre;
    Provider.of<MovieByGenreProvider>(context, listen: false)
        .fetchMovieBasedOnGenre(selectedGenre!.toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: _parentScrollController,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movie Genres',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorStyle.customBlue,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ChangeNotifierProvider(
                      create: (context) => GenreMovieProvider(),
                      child: Builder(
                        builder: (context) {
                          final data = Provider.of<GenreMovieProvider>(context);
                          if (data.genremovieState == GenreMovieState.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (data.genremovieState == GenreMovieState.error) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Center(
                                    child: Text(
                                  'No Movies Genres Found',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorStyle.customBlue),
                                )),
                              ],
                            );
                          }
                          final genreList =
                              Provider.of<GenreMovieProvider>(context)
                                  .moviesGenres;
                          return Center(
                            child: Container(
                                padding: const EdgeInsets.only(left: 0),
                                height: 30,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const VerticalDivider(
                                    color: Colors.transparent,
                                    width: 10,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: genreList.length,
                                  itemBuilder: (context, index) {
                                    final genre = genreList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          GenreList genre = genreList[index];
                                          selectedGenre = genre.id;
                                          Provider.of<MovieByGenreProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchMovieBasedOnGenre(
                                                  selectedGenre!.toInt());
                                        });
                                      },
                                      child: CustomBadges(
                                          badgeColor: genre.id == selectedGenre
                                              ? ColorStyle.customPurple
                                              : ColorStyle.customTosca,
                                          textColor: genre.id == selectedGenre
                                              ? Colors.white
                                              : ColorStyle.customPurple,
                                          title: '${genre.name}',
                                          fontSize: 12),
                                    );
                                  },
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollUpdateNotification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                        _parentScrollController.animateTo(
                            _parentScrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      } else if (notification.metrics.pixels ==
                          notification.metrics.minScrollExtent) {
                        _parentScrollController.animateTo(
                            _parentScrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      }
                    }
                    return true;
                  },
                  child: ChangeNotifierProvider(
                    create: (context) => GenreMovieProvider(),
                    child: Builder(
                      builder: (context) {
                        final data = Provider.of<MovieByGenreProvider>(context);
                        if (data.genremovieByIdState ==
                            GenreMovieState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (data.genremovieByIdState == GenreMovieState.error) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(
                                  child: Text(
                                'No Movies Genres Found',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorStyle.customBlue),
                              )),
                            ],
                          );
                        }
                        final moviebyGenre =
                            Provider.of<MovieByGenreProvider>(context)
                                .moviesbyGenres;
                        return Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: GridView.builder(
                                  controller: _childScrollController,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height /
                                            1.3),
                                  ),
                                  itemCount: moviebyGenre.length,
                                  itemBuilder: (context, index) {
                                    final genreMovie = moviebyGenre[index];
                                    return Container(
                                      width: 2,
                                      height: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MoviesDetailScreen(
                                                          movie: genreMovie)));
                                        },
                                        child: GridTile(
                                          child: Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://image.tmdb.org/t/p/w300/${genreMovie.posterPath}'),
                                                    fit: BoxFit.cover),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(2,
                                                        6), // Shadow position
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
