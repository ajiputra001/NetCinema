import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';

// Provider for Repository instance
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

// FutureProvider for Home Movies
final homeMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final repository = ref.watch(movieRepositoryProvider);
  return repository.fetchHomeMovies();
});

// Derived Provider: Hero Banner Featured Movie
final heroMovieProvider = Provider<Movie?>((ref) {
  final moviesAsync = ref.watch(homeMoviesProvider);
  return moviesAsync.maybeWhen(
    data: (movies) => movies.isNotEmpty ? movies.first : null,
    orElse: () => null,
  );
});

// Derived Provider: Categorized Movies Map
final moviesByCategoryProvider = Provider<Map<String, List<Movie>>>((ref) {
  final moviesAsync = ref.watch(homeMoviesProvider);
  return moviesAsync.maybeWhen(
    data: (movies) {
      final Map<String, List<Movie>> map = {
        'Trending Now': [],
        'Top Rated': [],
        'Action Movies': [],
        'Popular Sci-Fi': [],
      };

      for (var movie in movies) {
        if (map.containsKey(movie.category)) {
          map[movie.category]!.add(movie);
        } else {
          // Default bucket distribution for display
          if (movie.rating >= 8.8) {
            map['Top Rated']!.add(movie);
          } else if (movie.genres.contains('Action')) {
            map['Action Movies']!.add(movie);
          } else {
            map['Trending Now']!.add(movie);
          }
        }
      }

      // Ensure no category is empty by putting copies if needed
      if (map['Trending Now']!.isEmpty) map['Trending Now'] = movies;
      if (map['Top Rated']!.isEmpty) map['Top Rated'] = movies.reversed.toList();
      if (map['Action Movies']!.isEmpty) map['Action Movies'] = movies;

      return map;
    },
    orElse: () => {},
  );
});

// Search Query State
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search Results Provider
final searchResultsProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final repository = ref.watch(movieRepositoryProvider);
  if (query.isEmpty) return [];
  return repository.searchMovies(query);
});
