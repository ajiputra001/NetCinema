import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;
  final String? initialVideoUrl;

  const VideoPlayerScreen({
    super.key,
    required this.movie,
    this.initialVideoUrl,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  bool _isInitialized = false;
  bool _hasError = false;
  String _statusMessage = 'Menghubungkan ke server stream...';

  static const Map<String, String> _headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  };

  @override
  void initState() {
    super.initState();
    // Enable landscape fullscreen mode for cinema viewing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _initPlayer();
  }

  Future<void> _initPlayer() async {
    String? streamUrl = widget.initialVideoUrl;

    if (streamUrl == null || streamUrl.isEmpty) {
      final repository = MovieRepository();
      streamUrl = await repository.fetchVideoStreamUrl(widget.movie.id, widget.movie.title);
    }

    if (streamUrl == null || streamUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _statusMessage = 'Video stream tidak dapat dimuat.';
        });
      }
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(streamUrl),
        httpHeaders: _headers,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.play();
      }

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _statusMessage = 'Format video tidak didukung oleh perangkat.';
        });
      }
    }
  }

  @override
  void dispose() {
    // Restore normal orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Native Video Player Surface
            if (_isInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else if (_hasError)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertCircle, color: AppColors.primary, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isInitialized = false;
                        });
                        _initPlayer();
                      },
                      child: const Text('Coba Pemutaran Ulang', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),

            // Controls Overlay Screen
            if (_showControls)
              Container(
                color: Colors.black.withOpacity(0.55),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Header Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 24),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.movie.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'HD 1080P',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center Playback Controls (10s Backward, Play/Pause, 10s Forward)
                      if (_isInitialized && _controller != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 36,
                              icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
                              onPressed: () {
                                final current = _controller!.value.position;
                                _controller!.seekTo(current - const Duration(seconds: 10));
                              },
                            ),
                            const SizedBox(width: 32),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 44,
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller!.value.isPlaying
                                        ? _controller!.pause()
                                        : _controller!.play();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 32),
                            IconButton(
                              iconSize: 36,
                              icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
                              onPressed: () {
                                final current = _controller!.value.position;
                                _controller!.seekTo(current + const Duration(seconds: 10));
                              },
                            ),
                          ],
                        ),

                      // Bottom Progress Slider & Time Labels
                      if (_isInitialized && _controller != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_controller!.value.position),
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    _formatDuration(_controller!.value.duration),
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                              VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.primary,
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.white10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
