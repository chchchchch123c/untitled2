import 'package:flutter/material.dart';
import 'package:untitled2/presentation/provider/movie_provider.dart';
import 'package:untitled2/presentation/screen/widget/movie_circular_progress_bar.dart';
import 'package:untitled2/presentation/screen/widget/movie_icon.dart';

import '../../data/models/genre_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key,
    required this.img,
    required this.title,
    required this.overView,
    required this.date,
    required this.vote,
    required this.genreIds,
    required this.showGenreList});

  final String img;
  final String title;
  final String overView;
  final String date;

  final double vote;

  final List<int> genreIds;
  final List<GenreModel> showGenreList;

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
              (element2) => element == element2.id,
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          color: Color(0xFF292929),
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
                              Colors.black.withOpacity(0),
                              const Color(0xFF111111),
                              const Color(0xFF111111),
                            ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 220,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' (${widget.date.substring(0, 4)})',
                                    style:
                                    TextStyle(color: Colors.grey, fontSize: 40),
                                  )
                                ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            genreText,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              MovieCircularProgressBar(value: widget.vote),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'user\nscore',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              Spacer(),
                              MovieIcon(icon: Icon(Icons.list)),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                                child: MovieIcon(icon: Icon(Icons.favorite)),
                              ),
                              MovieIcon(icon: Icon(Icons.bookmark)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TODO close 버튼 넣을 자리
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  widget.overView,
                  style: TextStyle(color: Colors.white),
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
