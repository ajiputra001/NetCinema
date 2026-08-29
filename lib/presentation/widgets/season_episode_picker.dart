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

  final List<Episode> _episodes = const [
    Episode(
      episodeNumber: 1,
      title: 'Episode 1: Permulaan',
      duration: '48m',
      overview: 'Episode pertama yang membuka awal kisah petualangan, konflik awal, dan perkenalan karakter utama.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?q=80&w=600&auto=format&fit=crop',
    ),
    Episode(
      episodeNumber: 2,
      title: 'Episode 2: Rahasia Terkuak',
      duration: '52m',
      overview: 'Konflik semakin memanas ketika rahasia penting terungkap dan tantangan baru harus dihadapi.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=600&auto=format&fit=crop',
    ),
    Episode(
      episodeNumber: 3,
      title: 'Episode 3: Keputusan Berat',
      duration: '50m',
      overview: 'Para karakter diuji oleh pilihan sulit yang mempertaruhkan persahabatan dan tujuan mereka.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=600&auto=format&fit=crop',
    ),
    Episode(
      episodeNumber: 4,
      title: 'Episode 4: Titik Balik',
      duration: '55m',
      overview: 'Aksi puncaknya dimulai dengan strategi baru dan pertempuran yang tak dapat dihindari.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=600&auto=format&fit=crop',
    ),
  ];

  void _playEpisode(Episode ep) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          movie: widget.movie,
          season: _selectedSeason,
          episode: ep.episodeNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Season Dropdown Selector Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: DropdownButton<int>(
                  value: _selectedSeason,
                  dropdownColor: AppColors.surface,
                  icon: const Icon(LucideIcons.chevronDown, color: Colors.white, size: 18),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  items: [1, 2, 3].map((season) {
                    return DropdownMenuItem<int>(
                      value: season,
                      child: Text('Season $season'),
                    );
                  }).toList(),
                  onChanged: (newSeason) {
                    if (newSeason != null) {
                      setState(() {
                        _selectedSeason = newSeason;
                      });
                    }
                  },
                ),
              ),
            ),
            Text(
              '${_episodes.length} Episode',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Episode List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _episodes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final ep = _episodes[index];

            return InkWell(
              onTap: () => _playEpisode(ep),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Episode Thumbnail with Play Overlay
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: widget.movie.posterUrl,
                                width: 100,
                                height: 60,
                                fit: BoxFit.cover,
                                memCacheWidth: 200,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.65),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // Episode Title & Duration
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
                        const Icon(LucideIcons.play, color: AppColors.primary, size: 20),
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
              ),
            );
          },
        ),
      ],
    );
  }
}
