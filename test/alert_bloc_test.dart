import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_relief_coordination/src/bloc/AlertBloc.dart';
import 'package:disaster_relief_coordination/src/services/PhilippineDisasterService.dart';
import 'package:disaster_relief_coordination/src/services/GdacsService.dart';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';

// Mock services for testing
class MockPhilippineDisasterService extends PhilippineDisasterService {
  final List<AlertModel> mockAlerts;

  MockPhilippineDisasterService({required this.mockAlerts})
    : super(openWeatherApiKey: 'test-key');

  @override
  Future<List<AlertModel>> getAllDisasterAlerts({
    double lat = 14.5995,
    double lon = 120.9842,
  }) async {
    return mockAlerts;
  }
}

class MockGdacsService extends GdacsService {
  final List<AlertModel> mockAlerts;

  MockGdacsService({required this.mockAlerts});

  @override
  Future<List<AlertModel>> getAllGdacsAlerts() async {
    return mockAlerts;
  }
}

void main() {
  group('AlertBloc', () {
    late PhilippineDisasterService mockPhilippineService;
    late GdacsService mockGdacsService;
    late AlertBloc alertBloc;

    setUp(() {
      final philippineAlerts = [
        AlertModel(
          id: 'ph1',
          alertname: 'Philippine Alert',
          description: 'Test Philippine alert',
          status: 'Active',
          address: 'Manila',
          timestamp: DateTime.now().toIso8601String(),
          disasterType: 'Flood',
        ),
      ];

      final gdacsAlerts = [
        AlertModel(
          id: 'gdacs1',
          alertname: 'GDACS Alert',
          description: 'Test GDACS alert',
          status: 'Active',
          address: 'Global',
          timestamp: DateTime.now().toIso8601String(),
          disasterType: 'Typhoon',
        ),
      ];

      mockPhilippineService = MockPhilippineDisasterService(
        mockAlerts: philippineAlerts,
      );
      mockGdacsService = MockGdacsService(mockAlerts: gdacsAlerts);
      alertBloc = AlertBloc(
        disasterService: mockPhilippineService,
        gdacsService: mockGdacsService,
      );
    });

    tearDown(() {
      alertBloc.close();
    });

    test('initial state is correct', () {
      expect(alertBloc.state.alerts, isEmpty);
      expect(alertBloc.state.isLoading, false);
      expect(alertBloc.state.error, null);
    });

    group('LoadAlerts', () {
      test('emits loading state and then alerts when successful', () async {
        // Act & Assert
        expectLater(
          alertBloc.stream,
          emitsInOrder([
            predicate<AlertState>((state) => state.isLoading == true),
            predicate<AlertState>(
              (state) =>
                  state.isLoading == false &&
                  state.alerts.length == 2 &&
                  state.alerts.any((alert) => alert.id == 'ph1') &&
                  state.alerts.any((alert) => alert.id == 'gdacs1'),
            ),
          ]),
        );

        alertBloc.add(const LoadAlerts());
        await Future.delayed(const Duration(milliseconds: 100));
      });
    });
  });
}
