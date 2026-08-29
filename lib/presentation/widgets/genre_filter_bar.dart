import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GenreFilterBar extends StatelessWidget {
  final String selectedGenre;
  final ValueChanged<String> onGenreSelected;

  static const List<String> genres = [
    'All',
    'Action',
    'Sci-Fi',
    'Horror',
    'Drama',
    'Animation',
    'Crime',
    'Adventure',
  ];

  const GenreFilterBar({
    super.key,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = genre == selectedGenre;

          return GestureDetector(
            onTap: () => onGenreSelected(genre),
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
