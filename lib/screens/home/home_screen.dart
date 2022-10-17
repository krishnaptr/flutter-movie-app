import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_provider/models/now_showing.dart';
import 'package:movie_provider/providers/movies/popupar_movie.dart';
import 'package:movie_provider/providers/repo_provider.dart';
import 'package:movie_provider/screens/movies/detail/movies_detail.dart';
import 'package:movie_provider/screens/movies/now_showing/now_showing_movie.dart';
import 'package:movie_provider/screens/movies/popular/popular_movie.dart';
import 'package:movie_provider/styles/constants.dart';
import 'package:movie_provider/utils/badges.dart';
import 'package:movie_provider/utils/scroll.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _childScrollController = ScrollController();
  final ScrollController _parentScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _parentScrollController,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Now Showing',
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorStyle.customBlue,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 25,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NowShowingMovie(),
                              ));
                        },
                        child: const Text(
                          'See more',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 320,
                child: ScrollConfiguration(
                  behavior: RemoveScrollStyle(),
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MovieProvider(),
                      ),
                      ChangeNotifierProvider(
                        create: (context) => PopularMovieProvider(),
                      ),
                    ],
                    child: Builder(
                      builder: (context) {
                        final model = Provider.of<MovieProvider>(context);

                        if (model.movieState == MovieState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (model.movieState == MovieState.error) {
                          return const Center(
                              child: Text('Error from the API Server'));
                        }
                        final movies = model.movies;
                        return ListView.builder(
                          reverse: false,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return Column(
                              children: [
                                Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MoviesDetailScreen(
                                                        movie: movie)));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: index == movies.length - 1
                                                ? 0
                                                : 15),
                                        width: 143,
                                        height: 212,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://image.tmdb.org/t/p/w300/${movie.posterPath}'),
                                              fit: BoxFit.cover),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 8,
                                              offset: const Offset(
                                                  2, 6), // Shadow position
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: AutoSizeText(
                                        movie.title.toString(),
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.32),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/fi_star.png'),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${movie.voteAverage} IMDb',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              letterSpacing: 0.32),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorStyle.customBlue,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 25,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PopularMovie(),
                              ));
                        },
                        child: const Text(
                          'See more',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: RemoveScrollStyle(),
                  child: Builder(builder: (context) {
                    final popular = Provider.of<PopularMovieProvider>(context);

                    if (popular.popularmovieState == MovieState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (popular.popularmovieState == MovieState.error) {
                      return const Center(
                          child: Text('Error from the API Server'));
                    }
                    final popularMovies = popular.moviesPopular;
                    return NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        if (notification is ScrollUpdateNotification) {
                          if (notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent) {
                            _parentScrollController.animateTo(
                                _parentScrollController
                                    .position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          } else if (notification.metrics.pixels ==
                              notification.metrics.minScrollExtent) {
                            _parentScrollController.animateTo(
                                _parentScrollController
                                    .position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        }
                        return true;
                      },
                      child: ListView.builder(
                        controller: _childScrollController,
                        // padding: EdgeInsets.only(
                        //     bottom: MediaQuery.of(context).size.height * 0.1),
                        reverse: false,
                        scrollDirection: Axis.vertical,
                        itemCount: popularMovies.length,
                        itemBuilder: (context, index) {
                          final popularMovie = popularMovies[index];
                          var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                          var inputDate =
                              inputFormat.parse('${popularMovie.releaseDate}');
                          var outputFormat = DateFormat('MMM d, yyyy');
                          var releaseDate = outputFormat.format(inputDate);
                          return Row(
                            children: [
                              Wrap(
                                direction: Axis.vertical,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MoviesDetailScreen(
                                                      movie: popularMovie)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 15, bottom: 15, top: 5),
                                      width: 85,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w200/${popularMovie.posterPath}'),
                                            fit: BoxFit.cover),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(
                                                2, 6), // Shadow position
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: AutoSizeText(
                                      '${popularMovie.title}',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.32),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/fi_star.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${popularMovie.voteAverage} IMDb',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            letterSpacing: 0.32),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      CustomBadges(
                                        badgeColor: ColorStyle.customTosca,
                                        textColor: ColorStyle.customPurple,
                                        title:
                                            'Language: ${popularMovie.originalLanguage}',
                                        fontSize: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset('assets/icons/fi_time.png'),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Release: $releaseDate',
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
