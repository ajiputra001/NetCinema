import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieRepository {
  static const String baseUrl = 'https://moviebox.ajiputra.my.id';

  // Custom User-Agent header to prevent 403 Forbidden Cloudflare/FastAPI blocks
  static const Map<String, String> _headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Accept': 'application/json',
  };

  Future<List<Movie>> fetchHomeMovies() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/home'), headers: _headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Movie> loadedMovies = [];

        if (data['sections'] != null && data['sections'] is List) {
          final List sections = data['sections'];
          for (var sec in sections) {
            final String rawSection = sec['section'] ?? 'Trending Now';
            final String sectionName = rawSection == 'Banner' ? 'Trending Now' : rawSection;

            if (sec['items'] != null && sec['items'] is List) {
              for (var item in sec['items']) {
                if (item is Map<String, dynamic>) {
                  final movie = Movie.fromJson({
                    ...item,
                    'category': sectionName,
                  });
                  if (movie.title.isNotEmpty && movie.posterUrl.isNotEmpty) {
                    loadedMovies.add(movie);
                  }
                }
              }
            }
          }
        }

        if (loadedMovies.isNotEmpty) {
          return loadedMovies;
        }
      }
    } catch (_) {
      // Seamless fallback if network or API unavailable
    }

    return Movie.mockMovies;
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query)}'), headers: _headers)
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final List list = data['data'];
          return list.map((item) => Movie.fromJson(item)).toList();
        }
      }
    } catch (_) {}

    return Movie.mockMovies
        .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
