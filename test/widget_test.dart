import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviebox_app/main.dart';

void main() {
  testWidgets('NetCinemaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MovieBoxApp(),
      ),
    );
    expect(find.byType(MovieBoxApp), findsOneWidget);
  });
}
