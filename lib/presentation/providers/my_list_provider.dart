import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/movie_model.dart';

class MyListNotifier extends StateNotifier<List<Movie>> {
  MyListNotifier() : super([Movie.mockMovies[0], Movie.mockMovies[3]]);

  bool isBookmarked(String movieId) {
    return state.any((movie) => movie.id == movieId);
  }

  void toggleBookmark(Movie movie) {
    if (isBookmarked(movie.id)) {
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      state = [...state, movie];
    }
  }
}

final myListProvider = StateNotifierProvider<MyListNotifier, List<Movie>>((ref) {
  return MyListNotifier();
});
