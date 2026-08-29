import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviebox_app/main.dart';
import 'package:moviebox_app/data/models/movie_model.dart';
import 'package:moviebox_app/presentation/providers/movie_provider.dart';

void main() {
  testWidgets('NetCinemaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeMoviesProvider.overrideWith((ref) async => Movie.mockMovies),
        ],
        child: const MovieBoxApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(MovieBoxApp), findsOneWidget);
  });
}
