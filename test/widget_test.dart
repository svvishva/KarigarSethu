import 'package:flutter_test/flutter_test.dart';
import 'package:karigarsethu/main.dart';

void main() {
  testWidgets('KarigarSethu smoke test loads verification screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KarigarSethuApp());

    // Verify that the Dashboard screen appears.
    expect(find.text('My Business'), findsOneWidget);
    expect(find.text('Add New Product'), findsOneWidget);
  });
}
