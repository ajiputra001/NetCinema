import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../providers/my_list_provider.dart';
import '../widgets/movie_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myList = ref.watch(myListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Profil & Akun',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatars Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfileAvatar('Ajiputra', Colors.redAccent, isSelected: true),
                const SizedBox(width: 16),
                _buildProfileAvatar('Family', Colors.blueAccent),
                const SizedBox(width: 16),
                _buildProfileAvatar('Kids', Colors.orangeAccent),
                const SizedBox(width: 16),
                _buildAddProfileAvatar(),
              ],
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Kelola Profil',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
            const SizedBox(height: 28),

            // Saved Movies Section (My List)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Saya (My List)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${myList.length} Film',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (myList.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.bookmark, color: AppColors.textMuted),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Belum ada film di Daftar Saya. Tekan "+ My List" di halaman film.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: myList.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      movie: myList[index],
                      width: 110,
                      height: 170,
                    );
                  },
                ),
              ),

            const SizedBox(height: 28),

            // Settings List
            _buildSettingsTile(LucideIcons.bell, 'Notifikasi'),
            _buildSettingsTile(LucideIcons.settings, 'Pengaturan Aplikasi'),
            _buildSettingsTile(LucideIcons.helpCircle, 'Bantuan & FAQ'),
            const SizedBox(height: 16),
            _buildSettingsTile(LucideIcons.logOut, 'Keluar (Sign Out)', isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String name, Color color, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: Center(
            child: Text(
              name[0],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildAddProfileAvatar() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambah',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.primary : Colors.white,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppColors.primary : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        onTap: () {},
      ),
    );
  }
}
