import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../providers/movie_provider.dart';
import '../widgets/genre_filter_bar.dart';
import '../widgets/hero_banner.dart';
import '../widgets/movie_category_section.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final opacity = (_scrollController.offset / 180.0).clamp(0.0, 1.0);
      if (opacity != _appBarOpacity) {
        setState(() {
          _appBarOpacity = opacity;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeMoviesState = ref.watch(homeMoviesProvider);
    final heroMovie = ref.watch(heroMovieProvider);
    final moviesByCategory = ref.watch(moviesByCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(homeMoviesProvider);
        },
        child: Stack(
          children: [
            // Body Content (Loading vs Loaded State)
            homeMoviesState.when(
              loading: () => const HomeScreenSkeleton(),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertCircle, color: AppColors.primary, size: 48),
                    const SizedBox(height: 12),
                    const Text('Gagal Memuat Data Film', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: () => ref.invalidate(homeMoviesProvider),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              data: (_) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Top Featured Hero Banner
                      if (heroMovie != null) HeroBanner(movie: heroMovie),

                      const SizedBox(height: 12),

                      // Horizontal Genre Selector Pills
                      GenreFilterBar(
                        selectedGenre: _selectedGenre,
                        onGenreSelected: (genre) {
                          setState(() {
                            _selectedGenre = genre;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Category Horizontal List Views
                      ...moviesByCategory.entries.map((entry) {
                        final filteredList = _selectedGenre == 'All'
                            ? entry.value
                            : entry.value
                                .where((m) => m.genres.contains(_selectedGenre))
                                .toList();

                        if (filteredList.isEmpty && _selectedGenre != 'All') {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: MovieCategorySection(
                            title: entry.key,
                            movies: filteredList.isEmpty ? entry.value : filteredList,
                          ),
                        );
                      }),

                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),

            // Top Floating NetCinema Header App Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(_appBarOpacity * 0.9),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            // NetCinema Custom Brand Logo Image
                            Image.asset(
                              'assets/images/logo.png',
                              height: 32,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  LucideIcons.clapperboard,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'NETCINEMA',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                            const Spacer(),
                            IconButton(icon: const Icon(LucideIcons.cast, color: Colors.white, size: 20), onPressed: () {}),
                            IconButton(icon: const Icon(LucideIcons.search, color: Colors.white, size: 20), onPressed: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
