import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/movie_model.dart';
import 'movie_card.dart';

class MovieCategorySection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final double cardWidth;
  final double cardHeight;

  const MovieCategorySection({
    super.key,
    required this.title,
    required this.movies,
    this.cardWidth = 125,
    this.cardHeight = 185,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                width: cardWidth,
                height: cardHeight,
              );
            },
          ),
        ),
      ],
    );
  }
}
