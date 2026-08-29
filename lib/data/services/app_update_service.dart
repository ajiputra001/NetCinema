import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;
  final bool hasUpdate;

  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.forceUpdate,
    required this.hasUpdate,
  });
}

class AppUpdateService {
  static const String _githubRepoApi = 'https://api.github.com/repos/ajiputra001/NetCinema/releases/latest';

  static Future<AppUpdateInfo?> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse(_githubRepoApi),
        headers: {'User-Agent': 'NetCinema-App'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String tagName = (data['tag_name'] ?? 'v1.0.0').toString().replaceAll('v', '');
        final String body = data['body'] ?? 'Pembaruan aplikasi NetCinema terbaru tersedia.';
        
        // Find APK asset URL
        String apkUrl = '';
        if (data['assets'] != null && data['assets'] is List) {
          for (var asset in data['assets']) {
            if (asset['name'].toString().endsWith('.apk')) {
              apkUrl = asset['browser_download_url'] ?? '';
              break;
            }
          }
        }

        if (apkUrl.isEmpty && data['html_url'] != null) {
          apkUrl = '${data['html_url']}/download/app-release.apk';
        }

        final bool hasUpdate = _isVersionGreater(tagName, currentVersion);

        return AppUpdateInfo(
          currentVersion: currentVersion,
          latestVersion: tagName,
          downloadUrl: apkUrl,
          releaseNotes: body,
          forceUpdate: true, // Force update requirement
          hasUpdate: hasUpdate,
        );
      }
    } catch (_) {
      // Ignore network errors during background version check
    }
    return null;
  }

  static bool _isVersionGreater(String newVersion, String currentVersion) {
    try {
      List<int> vNew = newVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      List<int> vCur = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < 3; i++) {
        int n = i < vNew.length ? vNew[i] : 0;
        int c = i < vCur.length ? vCur[i] : 0;
        if (n > c) return true;
        if (n < c) return false;
      }
    } catch (_) {}
    return false;
  }

  static Future<void> downloadAndInstallApk({
    required String downloadUrl,
    required Function(double progress) onProgress,
    required Function(String error) onError,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/netcinema_update.apk';
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
      }

      final request = http.Request('GET', Uri.parse(downloadUrl));
      request.headers['User-Agent'] = 'Mozilla/5.0';
      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        onError('Gagal mengunduh berkas APK (HTTP ${response.statusCode})');
        return;
      }

      final contentLength = response.contentLength ?? 0;
      int downloadedBytes = 0;

      final List<int> bytes = [];
      final sink = file.openWrite();

      await response.stream.forEach((chunk) {
        bytes.addAll(chunk);
        downloadedBytes += chunk.length;
        sink.add(chunk);

        if (contentLength > 0) {
          double progress = downloadedBytes / contentLength;
          onProgress(progress);
        }
      });

      await sink.flush();
      await sink.close();

      // Launch native Android Package Installer
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        onError('Gagal membuka paket installer: ${result.message}');
      }
    } catch (e) {
      onError('Terjadi kesalahan saat pembaruan: $e');
    }
  }
}
