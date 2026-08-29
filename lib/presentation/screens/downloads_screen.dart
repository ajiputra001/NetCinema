import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/movie_model.dart';
import 'video_player_screen.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final List<Map<String, dynamic>> _downloadedMovies = [
    {
      'movie': Movie.mockMovies[0],
      'size': '1.4 GB',
      'progress': 1.0,
      'isCompleted': true,
    },
    {
      'movie': Movie.mockMovies[1],
      'size': '2.1 GB',
      'progress': 0.65,
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Downloads',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2, color: Colors.white, size: 20),
            onPressed: () {
              setState(() {
                _downloadedMovies.clear();
              });
            },
          ),
        ],
      ),
      body: _downloadedMovies.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.download,
                        size: 64,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Belum Ada Unduhan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Film dan serial TV yang Anda unduh akan muncul di sini agar bisa ditonton tanpa koneksi internet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _downloadedMovies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _downloadedMovies[index];
                final Movie movie = item['movie'];
                final bool isCompleted = item['isCompleted'];
                final double progress = item['progress'];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterUrl,
                          width: 80,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${movie.releaseYear} • ${item['size']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (!isCompleted) ...[
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white10,
                                color: AppColors.primary,
                                minHeight: 4,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mengunduh... ${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ] else ...[
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(movie: movie),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                                label: const Text('Tonton Offline', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(120, 32),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(LucideIcons.x, color: AppColors.textMuted, size: 20),
                        onPressed: () {
                          setState(() {
                            _downloadedMovies.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
