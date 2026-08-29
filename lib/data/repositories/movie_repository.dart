import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieRepository {
  static const String baseUrl = 'https://moviebox.ajiputra.my.id';

  Future<List<Movie>> fetchHomeMovies() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/home'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final List list = data['data'];
          if (list.isNotEmpty) {
            return list.map((item) => Movie.fromJson(item)).toList();
          }
        }
      }
    } catch (_) {
      // Fallback seamlessly to high quality local mock data if offline or slow server
    }
    
    // Simulate slight natural delay for shimmer demonstration if needed
    await Future.delayed(const Duration(milliseconds: 800));
    return Movie.mockMovies;
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(query)}'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final List list = data['data'];
          return list.map((item) => Movie.fromJson(item)).toList();
        }
      }
    } catch (_) {
      // Fallback search filter on local dataset
    }

    return Movie.mockMovies
        .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
