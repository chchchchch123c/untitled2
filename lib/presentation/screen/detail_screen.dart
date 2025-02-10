
import 'package:flutter/material.dart';
import 'package:untitled2/presentation/provider/movie_provider.dart';
import 'package:untitled2/presentation/screen/widget/movie_circular_progress_bar.dart';
import 'package:untitled2/presentation/screen/widget/movie_home_page.dart';
import 'package:untitled2/presentation/screen/widget/movie_icon.dart';
import 'package:untitled2/presentation/screen/widget/movie_runtime.dart';

import '../../data/models/genre_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key,
    required this.img,
    required this.title,
    required this.overView,
    required this.date,
    required this.vote,
    required this.genreIds,
    required this.showGenreList,
    required this.id,
  });

  final String img;
  final String title;
  final String overView;
  final String date;

  final double vote;

  final List<int> genreIds;
  final List<GenreModel> showGenreList;

  final int id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with AutomaticKeepAliveClientMixin {

  void updateScreen() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      movieProvider.addListener(updateScreen);
      movieProvider.getMovieList();
      movieProvider.getMovieInfoList(widget.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    movieProvider.removeListener(updateScreen);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final genreText = widget.genreIds.fold(
      '',
          (previousValue, element) {
        final genre = widget.showGenreList.firstWhere(
              (element2) => element == element2.id
        );
        return previousValue.isEmpty
            ? genre.name
            : "$previousValue & ${genre.name}";
      },
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/original/${widget.img}',
                      fit: BoxFit.cover,
                      width: MediaQuery.sizeOf(context).width,
                      height: 220,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          color: const Color(0xFF292929),
                          width: MediaQuery.sizeOf(context).width,
                          height: 220,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .sizeOf(context)
                        .width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha(0),
                              const Color(0xFF111111),
                              const Color(0xFF111111),
                            ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 220,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' (${widget.date.substring(0, 4)})',
                                    style:
                                    const TextStyle(color: Colors.grey, fontSize: 40),
                                  )
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            genreText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              MovieCircularProgressBar(value: widget.vote),
                              const Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'user\nscore',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Colors.white, size: 16,),
                                        MovieRuntime(durationInMinutes: movieProvider.movieInfoModel?.runtime ?? 0.toInt(),),
                                      ],
                                    ),
                                  ),
                                  const Row(
                                    children: [
                                      MovieIcon(icon: Icon(Icons.list)),
                                      Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                        child: MovieIcon(icon: Icon(Icons.favorite)),
                                      ),
                                      MovieIcon(icon: Icon(Icons.bookmark)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TODO close 버튼 넣을 자리
                ],
              ),
              MovieHomePage(homepageUrl: movieProvider.movieInfoModel?.homepage),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Text(
                  widget.overView,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: const Text('Content distributor', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: movieProvider.movieInfoModel?.production_companies.length == 1 ? 60 : 120,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieProvider.movieInfoModel?.production_companies.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: movieProvider.movieInfoModel?.production_companies.length == 1 ? 1 : 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                      mainAxisExtent: 60,
                    ),
                    itemBuilder: (context, index) {
                      final company = movieProvider.movieInfoModel?.production_companies[index];
                      if (company?.logo_path == null) {
                        return const SizedBox.shrink();
                      }
                      return Stack(
                        children: [
                          Container(
                            width: 60,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(2))
                            ),
                          ),
                          Image.network('https://image.tmdb.org/t/p/original/${company?.logo_path}',
                            width: 60,
                            height: 50,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieProvider.movieList.length,
                    itemBuilder: (context, index) {
                      final currentItem = movieProvider.movieList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Image.network(
                            'https://image.tmdb.org/t/p/original/${currentItem
                                .poster_path}'),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
