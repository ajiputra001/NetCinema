import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/movie_model.dart';
import '../screens/video_player_screen.dart';

class Episode {
  final int episodeNumber;
  final String title;
  final String duration;
  final String overview;
  final String thumbnailUrl;

  const Episode({
    required this.episodeNumber,
    required this.title,
    required this.duration,
    required this.overview,
    required this.thumbnailUrl,
  });
}

class SeasonEpisodePicker extends StatefulWidget {
  final Movie movie;

  const SeasonEpisodePicker({super.key, required this.movie});

  @override
  State<SeasonEpisodePicker> createState() => _SeasonEpisodePickerState();
}

class _SeasonEpisodePickerState extends State<SeasonEpisodePicker> {
  int _selectedSeason = 1;

  final List<Episode> _sampleEpisodes = const [
    Episode(
      episodeNumber: 1,
      title: 'Chapter One: The Vanishing',
      duration: '48m',
      overview: 'Dalam perjalanan pulang dari rumah teman, Will melihat sesuatu yang menakutkan. Di dekat laboratorium rahasia, rahasia kelam tersembunyi.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?q=80&w=600&auto=format&fit=crop',
    ),
    Episode(
      episodeNumber: 2,
      title: 'Chapter Two: The Weirdo on Maple Street',
      duration: '55m',
      overview: 'Lucas, Dustin, dan Mike mencoba berbicara dengan gadis yang mereka temukan di hutan. Hopper menanyai pencari keselamatan.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=600&auto=format&fit=crop',
    ),
    Episode(
      episodeNumber: 3,
      title: 'Chapter Three: Holly, Jolly',
      duration: '51m',
      overview: 'Joyce yakin Will mencoba berkomunikasi dengannya melalui lampu natal. Nancy mencari temannya yang hilang.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=600&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Season Dropdown Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<int>(
              value: _selectedSeason,
              dropdownColor: AppColors.surface,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Season 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DropdownMenuItem(value: 2, child: Text('Season 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DropdownMenuItem(value: 3, child: Text('Season 3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedSeason = val);
              },
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Episodes List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sampleEpisodes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final ep = _sampleEpisodes[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(movie: widget.movie),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Thumbnail image with play overlay
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: ep.thumbnailUrl,
                              width: 120,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Episode details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ep.episodeNumber}. ${ep.title}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ep.duration,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.download, color: Colors.white, size: 20),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    ep.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
