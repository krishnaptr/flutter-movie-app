import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_provider/providers/movies/popupar_movie.dart';
import 'package:movie_provider/providers/repo_provider.dart';
import 'package:movie_provider/screens/movies/detail/movies_detail.dart';
import 'package:movie_provider/styles/constants.dart';
import 'package:provider/provider.dart';

class PopularMovie extends StatelessWidget {
  const PopularMovie({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/icons/back.png',
              color: ColorStyle.customBlue,
              height: 24,
              width: 24,
            )),
        title: const Text(
          'Browse Popular Movie',
          style: TextStyle(fontSize: 16, color: ColorStyle.customBlue),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ChangeNotifierProvider(
          create: (context) => PopularMovieProvider(),
          child: Builder(
            builder: (context) {
              final modelData = Provider.of<PopularMovieProvider>(context);

              if (modelData.popularmovieState == MovieState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (modelData.popularmovieState == MovieState.error) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Text(
                      'Movies Not Found',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorStyle.customBlue),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 25,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder()),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Back to Home Screen',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 10),
                          )),
                    )
                  ],
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 40, top: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 30,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.4),
                          ),
                          itemCount: modelData.moviesPopular.length,
                          itemBuilder: (context, index) {
                            final movieData = modelData.moviesPopular[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MoviesDetailScreen(
                                                movie: movieData)));
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GridTile(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://image.tmdb.org/t/p/w300/${movieData.posterPath}'),
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
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
