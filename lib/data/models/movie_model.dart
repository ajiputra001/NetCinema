class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final String releaseYear;
  final String duration;
  final List<String> genres;
  final String description;
  final String category;
  final int matchScore; // e.g. 98% Match
  final bool isTop10;

  const Movie({
    required this.id,
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
    return Movie(
      id: json['id']?.toString() ?? json['slug']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Untitled Movie',
      posterUrl: json['poster_url'] ?? json['poster'] ?? json['cover'] ?? '',
      backdropUrl: json['backdrop_url'] ?? json['banner'] ?? json['poster_url'] ?? '',
      rating: (json['rating'] ?? json['rate'] ?? 8.5).toDouble(),
      releaseYear: json['release_year']?.toString() ?? json['year']?.toString() ?? '2024',
      duration: json['duration'] ?? '2h 15m',
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : ['Action', 'Thriller'],
      description: json['description'] ?? json['overview'] ?? 'No description available.',
      category: json['category'] ?? 'Trending Now',
      matchScore: json['match_score'] ?? 96,
      isTop10: json['is_top_10'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_url': posterUrl,
      'backdrop_url': backdropUrl,
      'rating': rating,
      'release_year': releaseYear,
      'duration': duration,
      'genres': genres,
      'description': description,
      'category': category,
      'match_score': matchScore,
      'is_top_10': isTop10,
    };
  }

  // Realistic sample movies for initial demo & smooth offline fallback
  static List<Movie> get mockMovies => [
        const Movie(
          id: '1',
          title: 'Stranger Things 5',
          posterUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?q=80&w=1200&auto=format&fit=crop',
          rating: 9.2,
          releaseYear: '2024',
          duration: '1 Season',
          genres: ['Sci-Fi', 'Horror', 'Drama'],
          description: 'Ketika seorang anak laki-laki hilang, sebuah kota kecil mengungkap misteri yang melibatkan eksperimen rahasia, kekuatan supranatural yang menakutkan, dan seorang gadis kecil yang aneh.',
          category: 'Hero',
          matchScore: 98,
          isTop10: true,
        ),
        const Movie(
          id: '2',
          title: 'The Dark Knight',
          posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1200&auto=format&fit=crop',
          rating: 9.0,
          releaseYear: '2008',
          duration: '2h 32m',
          genres: ['Action', 'Crime', 'Drama'],
          description: 'Ketika ancaman yang dikenal sebagai Joker meluapkan malapetaka dan kekacauan di Gotham, Batman harus menerima salah satu ujian psikologis paling berat.',
          category: 'Trending Now',
          matchScore: 99,
          isTop10: true,
        ),
        const Movie(
          id: '3',
          title: 'Cyberpunk Edgerunners',
          posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=1200&auto=format&fit=crop',
          rating: 8.9,
          releaseYear: '2023',
          duration: '10 Episodes',
          genres: ['Animation', 'Action', 'Sci-Fi'],
          description: 'Seorang anak jalanan yang mencoba bertahan hidup di kota masa depan yang terobsesi dengan teknologi dan modifikasi tubuh.',
          category: 'Trending Now',
          matchScore: 94,
          isTop10: false,
        ),
        const Movie(
          id: '4',
          title: 'Interstellar',
          posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?q=80&w=1200&auto=format&fit=crop',
          rating: 8.7,
          releaseYear: '2014',
          duration: '2h 49m',
          genres: ['Sci-Fi', 'Adventure', 'Drama'],
          description: 'Sebuah tim penjelajah melakukan perjalanan melalui lubang cacing di luar angkasa dalam upaya memastikan kelangsungan hidup umat manusia.',
          category: 'Top Rated',
          matchScore: 97,
          isTop10: true,
        ),
        const Movie(
          id: '5',
          title: 'Inception',
          posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=1200&auto=format&fit=crop',
          rating: 8.8,
          releaseYear: '2010',
          duration: '2h 28m',
          genres: ['Action', 'Sci-Fi', 'Thriller'],
          description: 'Seorang pencuri yang mencuri rahasia korporat melalui penggunaan teknologi berbagi mimpi diberi tugas kebalikannya: menanamkan ide ke dalam pikiran seorang CEO.',
          category: 'Top Rated',
          matchScore: 96,
        ),
        const Movie(
          id: '6',
          title: 'Dune: Part Two',
          posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?q=80&w=1200&auto=format&fit=crop',
          rating: 8.9,
          releaseYear: '2024',
          duration: '2h 46m',
          genres: ['Action', 'Adventure', 'Sci-Fi'],
          description: 'Paul Atreides bersatu kembali dengan Chani dan Fremen sambil membalas dendam terhadap para konspirator yang menghancurkan keluarganya.',
          category: 'Action Movies',
          matchScore: 98,
        ),
        const Movie(
          id: '7',
          title: 'Avengers: Endgame',
          posterUrl: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?q=80&w=800&auto=format&fit=crop',
          backdropUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1200&auto=format&fit=crop',
          rating: 8.4,
          releaseYear: '2019',
          duration: '3h 01m',
          genres: ['Action', 'Sci-Fi', 'Adventure'],
          description: 'Setelah peristiwa kehancuran oleh Thanos, Avengers tersisa berkumpul kembali untuk membalikkan tindakan Thanos.',
          category: 'Action Movies',
          matchScore: 93,
        ),
      ];
}
