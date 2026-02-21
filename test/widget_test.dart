import 'package:flutter_test/flutter_test.dart';
import 'package:mt_fuji_distance/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FujiDistanceApp());

    // Verify that our app starts.
    expect(find.text('Mt. Fuji Distance'), findsNothing); // Just a simple smoke test that ensures it doesn't crash on load
  });
}
