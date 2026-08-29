import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieRepository {
  static const String baseUrl = 'https://moviebox.ajiputra.my.id';

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
    } catch (_) {}

    return Movie.mockMovies;
  }

  // Fetch real stream video URL from FastAPI backend
  Future<String?> fetchVideoStreamUrl(String subjectId, String slug) async {
    if (subjectId.isEmpty && slug.isEmpty) return null;
    try {
      final uri = Uri.parse('$baseUrl/api/stream/$subjectId?detail_path=${Uri.encodeComponent(slug)}&obfuscate=false');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['sources'] != null && data['sources'] is List) {
          final List sources = data['sources'];

          // First preference: MP4 direct stream URL (H264)
          for (var src in sources) {
            if (src is Map<String, dynamic>) {
              final String format = (src['format'] ?? '').toString().toUpperCase();
              final String url = (src['url'] ?? src['url_raw'] ?? '').toString();
              if (format == 'MP4' && url.startsWith('http')) {
                return url;
              }
            }
          }

          // Second preference: Any valid direct video URL
          for (var src in sources) {
            if (src is Map<String, dynamic>) {
              final String url = (src['url'] ?? src['url_raw'] ?? '').toString();
              if (url.startsWith('http') && !url.contains('.mpd')) {
                return url;
              }
            }
          }
        }
      }
    } catch (_) {}

    // Fallback sample MP4 video for smooth demonstration
    return 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4';
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
