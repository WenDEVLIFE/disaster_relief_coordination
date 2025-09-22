import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_relief_coordination/src/widgets/AlertCard.dart';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';

void main() {
  group('AlertCard', () {
    testWidgets('displays alert information correctly', (
      WidgetTester tester,
    ) async {
      final alert = AlertModel(
        id: 'test1',
        alertname: 'Test Alert',
        description: 'This is a test description',
        status: 'Active',
        address: 'Test Location',
        timestamp: '2023-01-01T00:00:00Z',
        disasterType: 'Flood',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AlertCard(alert: alert)),
        ),
      );

      // Verify that the alert information is displayed
      expect(find.text('Test Alert'), findsOneWidget);
      expect(find.text('2023-01-01T00:00:00Z'), findsOneWidget);
      expect(find.text('This is a test description'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('handles long text properly', (WidgetTester tester) async {
      final longDescription =
          'This is a very long description that should wrap properly within the card layout to ensure that the text is displayed correctly even when it is very long and spans multiple lines.';

      final alert = AlertModel(
        id: 'test2',
        alertname: 'Long Text Alert',
        description: longDescription,
        status: 'Active',
        address: 'A Very Long Location Name That Should Be Truncated',
        timestamp: '2023-01-01T00:00:00Z',
        disasterType: 'Typhoon',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AlertCard(alert: alert)),
        ),
      );

      // Verify that the alert information is displayed
      expect(find.text('Long Text Alert'), findsOneWidget);
      expect(find.text('2023-01-01T00:00:00Z'), findsOneWidget);
      expect(find.text(longDescription), findsOneWidget);
    });
  });
}
