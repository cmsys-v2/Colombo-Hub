import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colombo_hub/main.dart';

void main() {
  testWidgets('ColomboHub App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ColomboHubApp(),
      ),
    );

    // Verify header branding
    expect(find.text('ColomboHub Ecosystem'), findsOneWidget);
    expect(find.text('CH'), findsOneWidget);

    // Verify Tab labels
    expect(find.text('🏠 Stay & Rooms'), findsOneWidget);
    expect(find.text('🚌 Move & Highway Buses'), findsOneWidget);
  });
}
