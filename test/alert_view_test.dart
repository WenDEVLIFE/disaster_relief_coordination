import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_relief_coordination/src/view/AlertView.dart';
import 'package:disaster_relief_coordination/src/bloc/AlertBloc.dart';
import 'package:disaster_relief_coordination/src/services/PhilippineDisasterService.dart';
import 'package:disaster_relief_coordination/src/services/GdacsService.dart';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  group('AlertView', () {
    testWidgets('can be instantiated', (WidgetTester tester) async {
      // Create simple mock services
      final philippineService = PhilippineDisasterService(
        openWeatherApiKey: 'test-key',
      );
      final gdacsService = GdacsService();

      final alertBloc = AlertBloc(
        disasterService: philippineService,
        gdacsService: gdacsService,
      );

      // Build the AlertView with our AlertBloc
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AlertBloc>.value(
            value: alertBloc,
            child: const AlertView(),
          ),
        ),
      );

      // Verify that the view builds without errors
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);

      alertBloc.close();
    });
  });
}
