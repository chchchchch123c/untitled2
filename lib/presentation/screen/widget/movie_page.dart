import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/color.dart';
import '../../provider/movie_provider.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: movieProvider.currentPage > 1
                ? () => movieProvider.changePage(movieProvider.currentPage - 1)
                : () => movieProvider.changePage(movieProvider.totalPages),
          ),
          ...movieProvider.getDisplayedPages().map(
                (page) {
              return GestureDetector(
                onTap: () => movieProvider.changePage(page),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '$page',
                    style: TextStyle(
                      color: movieProvider.currentPage == page
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.forward,
              color: Colors.white,
            ),
            onPressed: movieProvider.currentPage < movieProvider.totalPages
                ? () => movieProvider.changePage(movieProvider.currentPage + 1)
                : () => movieProvider.changePage(1), // 마지막 페이지에서 첫 페이지로 이동
          ),
        ],
      ),
    );
  }
}
