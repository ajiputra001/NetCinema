# NetCinema 🎬🍿

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-red.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen.svg)]()

**NetCinema** adalah aplikasi streaming film mobile native (Android & iOS) berkinerja tinggi yang dibangun menggunakan **Flutter** dan **Riverpod**. Mengusung UI/UX Dark Theme ala Netflix yang sangat halus, instan, dan dilengkapi animasi native fluid.

---

## 🌟 Fitur Utama

- 🎬 **Hero Banner Premium**: Poster utama dengan gradien hitam memudar, penanda Top 10, serta tombol aksi *Play* dan *My List*.
- ⚡ **Loading Instan & Caching**: Menggunakan `cached_network_image` untuk penyimpanan poster film lokal di memory & disk.
- ✨ **Skeleton Shimmer Loading**: Efek loading skeleton ala Netflix saat data film diproses dari API.
- 📱 **Native Video Player**: Pemutar video bawaan dengan kontrol lengkap (Play/Pause, Slider, Lompat 10s, lanskap otomatis).
- 🏷️ **Filter Genre & Kategori**: Pil genre horizontal (*Action, Sci-Fi, Horror, Drama, Animation, Crime, Adventure*) pada halaman utama.
- 📺 **Pemilih Episode Serial TV**: Selector Season & Episode lengkap dengan thumbnail, durasi, dan ringkasan episode.
- 🔖 **Fitur Daftar Saya (My List)**: Pengelolaan bookmark film interaktif tersinkronisasi secara real-time.
- 📥 **Manajer Unduhan Offline**: Simulasi unduhan film dengan indikator progress dan tombol tonton offline.
- 🎨 **Netflix Dark Theme**: Antarmuka gelap modern dengan navigasi bawah yang mulus.

---

## 📂 Struktur Proyek (Clean Architecture)

```
lib/
├── main.dart                       # Entry point aplikasi & ProviderScope
├── core/
│   ├── constants/app_colors.dart   # Palette warna Netflix & gradien
│   └── theme/app_theme.dart        # Tema Gelap dengan Google Fonts Inter
├── data/
│   ├── models/movie_model.dart     # Data Model Film + Mock Dataset Fallback
│   └── repositories/movie_repository.dart # API Service Fetcher
└── presentation/
    ├── providers/                  # State Management Riverpod
    ├── widgets/                    # HeroBanner, MovieCard, Shimmer, GenreFilterBar, dll
    └── screens/                    # HomeScreen, MovieDetailScreen, VideoPlayerScreen, dll
```

---

## 🚀 Cara Menjalankan Aplikasi

### Requirements:
- **Flutter SDK**: >= 3.24.0
- **Dart SDK**: >= 3.5.0

### Langkah Instalasi:

1. Clone repositori ini:
   ```bash
   git clone https://github.com/ajiputra001/NetCinema.git
   cd NetCinema
   ```

2. Unduh dependencies:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi pada Emulator / Smartphone:
   ```bash
   flutter run
   ```

---

## 📦 Download APK Release (Android)

Unduh berkas APK siap pakai di tab **[Releases](https://github.com/ajiputra001/NetCinema/releases)** repositori ini untuk menginstall NetCinema langsung di perangkat Android Anda.

---

## 📜 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).
