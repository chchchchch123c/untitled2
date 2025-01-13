import 'package:flutter/material.dart';
import 'package:untitled2/common/color.dart';
import 'package:untitled2/presentation/screen/detail_screen.dart';
import 'package:untitled2/presentation/screen/widget/movie_page.dart';

import '../provider/movie_provider.dart';

class GridViewScreen extends StatefulWidget {
  const GridViewScreen({super.key});

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen>
    with AutomaticKeepAliveClientMixin {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      movieProvider.addListener(update);
      movieProvider.getMovieList();
      movieProvider.getGenreList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
        appBar: AppBar(
          backgroundColor: Color(0xFF292929),
          actions: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movieProvider.genreList.length,
                itemBuilder: (context, index) {
                  final currentItem = movieProvider.genreList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        currentItem.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movieProvider.movieList.length,
                itemBuilder: (context, index) {
                  final currentItem = movieProvider.movieList[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return DetailScreen(
                              img: currentItem.backdrop_path,
                              title: currentItem.title,
                              overView: currentItem.overview,
                              date: currentItem.release_date,
                              vote: currentItem.vote_average,
                              genreIds: movieProvider.movieList.first.genre_ids,
                              showGenreList: movieProvider.genreList,
                            );
                          }));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/original/${currentItem.poster_path}',
                            fit: BoxFit.cover,
                            height: 272,
                            width: 187,
                            loadingBuilder: (context, child, loadingProgress) {
                              // 로딩 빌더, 이미지 불러올 때 처리
                              if (loadingProgress == null) {
                                return child; // 로딩 다 되면 표시
                              }
                              return Container(
                                height: 272,
                                width: 187,
                                color: Color(0xFF414141),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 272,
                  mainAxisSpacing: 10,
                ),
              ),
              if (movieProvider.movieList.length >= 5) MoviePage(),
            ],
          ),
        ),
        bottomNavigationBar:
            movieProvider.movieList.length < 5 ? MoviePage() : null,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
