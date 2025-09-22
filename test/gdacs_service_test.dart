import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_relief_coordination/src/services/GdacsService.dart';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';

void main() {
  group('GdacsService', () {
    late GdacsService gdacsService;

    setUp(() {
      gdacsService = GdacsService();
    });

    group('getFloodAlerts', () {
      test('returns a list of AlertModel objects', () async {
        // Since we're using mock data, this should return a list
        final alerts = await gdacsService.getFloodAlerts();
        expect(alerts, isA<List<AlertModel>>());
      });
    });

    group('getTyphoonAlerts', () {
      test('returns a list of AlertModel objects', () async {
        // Since we're using mock data, this should return a list
        final alerts = await gdacsService.getTyphoonAlerts();
        expect(alerts, isA<List<AlertModel>>());
      });
    });

    group('getAllGdacsAlerts', () {
      test('returns a list of AlertModel objects', () async {
        // Since we're using mock data, this should return a list
        final alerts = await gdacsService.getAllGdacsAlerts();
        expect(alerts, isA<List<AlertModel>>());
      });

      test('returns combined flood and typhoon alerts', () async {
        final floodAlerts = await gdacsService.getFloodAlerts();
        final typhoonAlerts = await gdacsService.getTyphoonAlerts();
        final allAlerts = await gdacsService.getAllGdacsAlerts();

        expect(allAlerts.length, floodAlerts.length + typhoonAlerts.length);
      });
    });
  });
}
