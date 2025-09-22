import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_relief_coordination/src/widgets/ReliefCenterWidget.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('ReliefCenterWidget', () {
    testWidgets('displays relief center information correctly', (
      WidgetTester tester,
    ) async {
      final center = ReliefCenter(
        id: 'test1',
        name: 'Test Relief Center',
        location: LatLng(14.5995, 120.9842),
        address: 'Test Location, Philippines',
        capacity: 100,
        currentOccupancy: 50,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ReliefCenterWidget(center: center)),
        ),
      );

      // Verify that the relief center information is displayed
      expect(find.text('Test Relief Center'), findsOneWidget);
      expect(find.text('Test Location, Philippines'), findsOneWidget);
      expect(find.text('Occupancy: 50/100 people (50.0%)'), findsOneWidget);
    });

    testWidgets('responds to tap events', (WidgetTester tester) async {
      bool tapped = false;

      final center = ReliefCenter(
        id: 'test1',
        name: 'Test Relief Center',
        location: LatLng(14.5995, 120.9842),
        address: 'Test Location, Philippines',
        capacity: 100,
        currentOccupancy: 50,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReliefCenterWidget(
              center: center,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Tap on the widget
      await tester.tap(find.byType(ReliefCenterWidget));
      await tester.pumpAndSettle();

      // Verify that the tap callback was called
      expect(tapped, true);
    });
  });
}
