import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_provider/models/movie_cast.dart';
import 'package:movie_provider/models/movie_detail.dart';
import 'package:movie_provider/models/now_showing.dart';
import 'package:movie_provider/providers/repo_provider.dart';
import 'package:movie_provider/styles/constants.dart';
import 'package:movie_provider/utils/badges.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviesDetailScreen extends StatefulWidget {
  const MoviesDetailScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final NowShowingModel movie;

  @override
  State<MoviesDetailScreen> createState() => _MoviesDetailScreenState();
}

class _MoviesDetailScreenState extends State<MoviesDetailScreen> {
  @override
  void initState() {
    Provider.of<MovieDetailProvider>(context, listen: false)
        .fetchMovieDetail(widget.movie.id!.toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: ChangeNotifierProvider(
        create: (context) => MovieProvider(),
        child: Builder(builder: (context) {
          final model2 = Provider.of<MovieDetailProvider>(context);
          if (model2.movieState2 == MovieState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (model2.movieState2 == MovieState.error) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                    child: Text(
                  'No Movies Information',
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
          final movieDetail =
              Provider.of<MovieDetailProvider>(context).movieDetail;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                title: Column(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      margin: const EdgeInsets.only(top: 40),
                      child: IconButton(
                          onPressed: () async {
                            final youtubeUrl =
                                'https://www.youtube.com/watch?v=${movieDetail?.trailerId}';
                            if (await canLaunchUrl(Uri.parse(youtubeUrl))) {
                              await launchUrl(
                                Uri.parse(youtubeUrl),
                                mode: LaunchMode.externalApplication,
                                webOnlyWindowName: '_blank',
                              );
                            }
                          },
                          icon: Image.asset(
                            'assets/icons/play.png',
                            height: 70,
                            width: 70,
                          )),
                    ),
                    const Text(
                      'Play Trailer',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: 0.32),
                    )
                  ],
                ),
                toolbarHeight: 150,
                leading: Container(
                  margin: const EdgeInsets.only(top: 20, left: 10),
                  child: Stack(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            'assets/icons/back.png',
                            height: 24,
                            width: 24,
                          )),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    child: Stack(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset(
                              'assets/icons/menu.png',
                              height: 24,
                              width: 24,
                            )),
                      ],
                    ),
                  ),
                ],
                pinned: false,
                floating: false,
                snap: false,
                stretch: false,
                shadowColor: Colors.transparent,
                backgroundColor: ColorStyle.customBlue,
                expandedHeight: 240,
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500/${movieDetail?.backdropPath}'),
                              fit: BoxFit.cover)),
                    )),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 0,
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(''),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 250,
                          child: AutoSizeText(
                            '${movieDetail?.title}',
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.32),
                          ),
                        ),
                        IconButton(
                            padding: const EdgeInsets.only(left: 20),
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/icons/fi_bookmark.png',
                              height: 24,
                              width: 24,
                              color: Colors.black.withOpacity(0.7),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/fi_star.png'),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${movieDetail?.voteAverage ?? "No Rating"} IMDb',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              letterSpacing: 0.32),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieDetail?.genres?.length,
                        itemBuilder: (context, index) {
                          Genre? genre = movieDetail?.genres?[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CustomBadges(
                              badgeColor: ColorStyle.customTosca,
                              textColor: ColorStyle.customPurple,
                              title: '${genre?.name}',
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Length',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  letterSpacing: 0.32),
                            ),
                            Text(
                              '${movieDetail?.runtime} min',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 0.32),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Language',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  letterSpacing: 0.32),
                            ),
                            Text(
                              '${movieDetail?.originalLanguage!.toUpperCase()}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 0.32),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  letterSpacing: 0.32),
                            ),
                            Text(
                              '${movieDetail?.status}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: 0.32),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: ColorStyle.customBlue,
                          letterSpacing: 0.32),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      '${movieDetail?.overview}',
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          fontSize: 12,
                          height: 1.8,
                          letterSpacing: 0.32),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cast',
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
                              onPressed: () {},
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
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieDetail?.castList?.length,
                        itemBuilder: (context, index) {
                          Cast? cast = movieDetail?.castList?[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                width: 72,
                                height: 76,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: cast?.profilePath == null
                                          ? const NetworkImage(
                                              'https://www.londondentalsmiles.co.uk/wp-content/uploads/2017/06/person-dummy.jpg')
                                          : NetworkImage(
                                              'https://image.tmdb.org/t/p/w200/${cast?.profilePath}'),
                                      fit: BoxFit.cover),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset:
                                          const Offset(2, 6), // Shadow position
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: 90,
                                child: AutoSizeText(
                                  '${cast?.name}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      letterSpacing: 0.32,
                                      color: ColorStyle.customBlue),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ))
            ],
          );
        }),
      ),
    ));
  }
}
