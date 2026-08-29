class Movie {
  final String id;
  final String slug;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final String releaseYear;
  final String duration;
  final List<String> genres;
  final String description;
  final String category;
  final int matchScore;
  final bool isTop10;

  const Movie({
    required this.id,
    required this.slug,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.releaseYear,
    required this.duration,
    required this.genres,
    required this.description,
    required this.category,
    this.matchScore = 95,
    this.isTop10 = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final rawPoster = json['poster_url'] ?? json['poster'] ?? json['cover'] ?? json['backdrop_url'] ?? '';
    final poster = (rawPoster != null && rawPoster.toString().isNotEmpty)
        ? rawPoster.toString()
        : 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=800&auto=format&fit=crop';

    double parsedRating = 8.5;
    if (json['rating'] != null) {
      parsedRating = double.tryParse(json['rating'].toString()) ?? 8.5;
    }

    return Movie(
      id: json['subject_id']?.toString() ?? json['id']?.toString() ?? 'movie-1',
      slug: json['slug']?.toString() ?? json['subject_id']?.toString() ?? '',
      title: json['name'] ?? json['title'] ?? 'Untitled Movie',
      posterUrl: poster,
      backdropUrl: (json['backdrop_url'] != null && json['backdrop_url'].toString().isNotEmpty)
          ? json['backdrop_url'].toString()
          : poster,
      rating: parsedRating,
      releaseYear: json['release_year']?.toString() ?? json['year']?.toString() ?? '2024',
      duration: json['duration'] ?? '2h 15m',
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : ['Action', 'Thriller'],
      description: json['description'] ?? json['overview'] ?? 'Saksikan serial dan film eksklusif pilihan hanya di NetCinema.',
      category: json['category'] ?? 'Trending Now',
      matchScore: json['match_score'] ?? 96,
      isTop10: json['is_top_10'] ?? (json['badge'] != null && json['badge'].toString().isNotEmpty),
    );
  }

  static const List<Movie> mockMovies = [
    Movie(
      id: '5904172458474619680',
      slug: 'beauty-in-black-E6NEe5Ha927',
      title: 'Beauty in Black S3',
      posterUrl: 'https://pbcdnw.aoneroom.com/image/2026/08/27/833adf4ea89155e719198f4665e5fc09.jpg',
      backdropUrl: 'https://pbcdnw.aoneroom.com/image/2026/08/27/833adf4ea89155e719198f4665e5fc09.jpg',
      rating: 9.2,
      releaseYear: '2024',
      duration: '1h 55m',
      genres: ['Drama', 'Thriller'],
      description: 'Sebuah drama menegangkan tentang intrik kekuasaan, rahasia keluarga, dan perjuangan bertahan hidup.',
      category: 'Popular Series',
      isTop10: true,
    ),
  ];
}
