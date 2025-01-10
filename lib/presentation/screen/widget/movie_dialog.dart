import 'package:flutter/material.dart';

import '../../../common/color.dart';
import '../../../data/models/genre_model.dart';
import 'movie_circular_progress_bar.dart';
import 'movie_icon.dart';

class MovieDialog extends StatelessWidget {
  const MovieDialog({super.key, required this.img, required this.title, required this.overView, required this.date, required this.genreIds, required this.showGenreList, required this.vote});

  final String img;
  final String title;
  final String overView;
  final String date;

  final double vote;

  final List<int> genreIds;
  final List<GenreModel> showGenreList;

  @override
  Widget build(BuildContext context) {
    final genreText = genreIds.fold('', (previousValue, element) {
      final genre = showGenreList.firstWhere((element2) => element == element2.id,);
      return previousValue.isEmpty ? genre.name : "$previousValue & ${genre.name}";
    },);
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(10), bottom: Radius.circular(28))),
      backgroundColor: dialogColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    child: Image.network(
                        'https://image.tmdb.org/t/p/original/$img'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '(${date.substring(0, 4)})', style: TextStyle(fontSize: 30, color: Colors.grey),),
                  Text(genreText, style: TextStyle(color: Colors.white),),
                  MovieCircularProgressBar(value: vote),
                  MovieIcon(icon: Icon(Icons.list)),
                  Text(
                    overView,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text(
                  //   'release date : $date',
                  //   style: const TextStyle(color: Colors.white, fontSize: 12),
                  // ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
