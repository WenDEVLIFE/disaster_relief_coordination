import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_relief_coordination/src/view/ReliefCenterScreen.dart';

void main() {
  group('ReliefCenterScreen', () {
    testWidgets('displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReliefCenterScreen()));

      // Verify that the screen title is displayed
      expect(find.text('Relief Centers'), findsOneWidget);

      // Verify that the search bar is displayed
      expect(find.byType(TextField), findsOneWidget);

      // Verify that the map container is displayed (we can't easily test FlutterMap directly)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('search functionality works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReliefCenterScreen()));

      // Find the search field
      final searchField = find.byType(TextField);

      // Enter search text
      await tester.enterText(searchField, 'Main');

      // Trigger frame update
      await tester.pump();

      // Verify that the search text is updated
      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, 'Main');
    });
  });
}
