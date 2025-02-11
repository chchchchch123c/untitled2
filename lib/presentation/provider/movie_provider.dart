import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:untitled2/data/models/movie_info_model.dart';

import '../../common/string.dart';
import '../../data/models/genre_model.dart';
import '../../data/models/movie_model.dart';

final movieProvider = MovieProvider();

class MovieProvider extends ChangeNotifier {
  List<MovieModel> movieList = [];
  List<GenreModel> genreList = [];

  int currentPage = 1;
  int totalPages = 1;

  MovieInfoModel? movieInfoModel;

  Future<void> getGenreList() async {
    try {
      genreList.clear();

      final response = await Client().get(
          Uri.parse('$base_url/genre/movie/list?language=en-US&region=en-US'),
          headers: {'Authorization': 'Bearer $api_key'});

      final json = jsonDecode(response.body);
      final genres = json['genres'] as List<dynamic>;

      for (var genre in genres) {
        genreList.add(GenreModel.fromJson(json: genre));
      }
      notifyListeners();
    } catch (e, t) {
      log('getGenreList', error: e, stackTrace: t);
    }
  }

  Future<void> getMovieList({int page = 1}) async {
    try {
      movieList.clear();
      final response = await Client().get(
          Uri.parse('$base_url/movie/now_playing?page=$page'),
          headers: {'Authorization': 'Bearer $api_key'});

      final json = jsonDecode(response.body);
      final movies = json['results'] as List<dynamic>;

      currentPage = json['page']; // 추가
      totalPages = json['total_pages']; // 추가

      for (var movie in movies) {
        movieList.add(MovieModel.fromJson(json: movie));
      }
      notifyListeners();
    } catch (e, t) {
      log('getMovieList', error: e, stackTrace: t);
    }
  }

  Future<void> getMovieInfoList(int id) async {
    try {
      final response = await Client().get(Uri.parse('$base_url/movie/$id'),
          headers: {'Authorization': 'Bearer $api_key'});
      final json = jsonDecode(response.body);

      movieInfoModel = MovieInfoModel.fromJson(json);
      notifyListeners();
    } catch (e, t) {
      log('getMovieInfoList', error: e, stackTrace: t);
    }
  }

  void changePage(int newPage) async {
    if (newPage == currentPage) return;
    await getMovieList(page: newPage);
    currentPage = newPage;
    notifyListeners();
  }

  List<int> getDisplayedPages() {
    const maxPagesToShow = 5;

    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);

    if (totalPages <= maxPagesToShow) {
      startPage = 1;
      endPage = totalPages;
    } else if (endPage - startPage + 1 < maxPagesToShow) {
      if (startPage == 1) {
        endPage = startPage + maxPagesToShow - 1;
      } else if (endPage == totalPages) {
        startPage = endPage - maxPagesToShow + 1;
      }
    }
    return List.generate(
      endPage - startPage + 1,
      (index) => startPage + index,
    );
  }
}
