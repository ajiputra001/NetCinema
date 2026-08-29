import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/movie_model.dart';
import '../screens/movie_detail_screen.dart';

class HeroBanner extends StatelessWidget {
  final Movie movie;

  static const Map<String, String> _imageHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  };

  const HeroBanner({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Stack(
        children: [
          // Background Backdrop Poster Image
          Hero(
            tag: 'movie-banner-${movie.id}',
            child: SizedBox(
              height: screenHeight * 0.58,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: movie.backdropUrl.isNotEmpty ? movie.backdropUrl : movie.posterUrl,
                httpHeaders: _imageHeaders,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.surface),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(LucideIcons.film, color: AppColors.textMuted, size: 48),
                  ),
                ),
              ),
            ),
          ),

          // Black Gradient Overlay fading down into background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
            ),
          ),

          // Content Box at Bottom of Banner
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top 10 badge if applicable
                if (movie.isTop10)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '#1 IN MOVIES TODAY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Movie Title
                Text(
                  movie.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Genres List (e.g. Sci-Fi • Horror • Drama)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: movie.genres.take(3).map((genre) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Text(
                            genre,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (genre != movie.genres.take(3).last)
                            Container(
                              margin: const EdgeInsets.only(left: 8, right: 4),
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Action Buttons: 'Play' and 'My List'
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 'My List' translucent button
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${movie.title} to My List'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.surface,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.plus, color: Colors.white, size: 20),
                            SizedBox(width: 6),
                            Text(
                              'My List',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // 'Play' solid white button
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.black, size: 24),
                            SizedBox(width: 4),
                            Text(
                              'Play',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
