import 'dart:convert';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';
import 'package:http/http.dart' as http;

class PhilippineDisasterService {
  static const String _pagasaBaseUrl = 'https://api.pagasa.dost.gov.ph';
  static const String _phivolcsBaseUrl = 'https://api.phivolcs.dost.gov.ph';
  static const String _ndrrmcBaseUrl = 'https://api.ndrrmc.gov.ph';
  static const String _openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
  final String _openWeatherApiKey;

  PhilippineDisasterService({required String openWeatherApiKey})
    : _openWeatherApiKey = openWeatherApiKey;

  // Fetch typhoon warnings from PAGASA
  Future<List<AlertModel>> getTyphoonWarnings() async {
    try {
      // Using mock data since PAGASA doesn't have a public API
      // In a real implementation, you would use: https://api.pagasa.dost.gov.ph/weather/tropical-cyclone
      final mockTyphoons = [
        {
          'id': 'typhoon_001',
          'name': 'Typhoon Signal #3',
          'description':
              'Typhoon with international name "Goring" is currently affecting Northern Luzon. Signal #3 raised in Cagayan, Isabela, and Aurora provinces. Expect heavy rainfall and strong winds.',
          'status': 'Active',
          'location': 'Northern Luzon, Philippines',
          'timestamp': DateTime.now().toIso8601String(),
          'type': 'Typhoon',
        },
        {
          'id': 'typhoon_002',
          'name': 'Tropical Storm Warning',
          'description':
              'Tropical Storm developing in the Philippine Sea. Monitor updates from PAGASA.',
          'status': 'Watch',
          'location': 'Philippine Sea',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'type': 'Tropical Storm',
        },
      ];

      return mockTyphoons
          .map(
            (typhoon) => AlertModel(
              id: typhoon['id'] as String,
              alertname: typhoon['name'] as String,
              description: typhoon['description'] as String,
              status: typhoon['status'] as String,
              address: typhoon['location'] as String,
              timestamp: typhoon['timestamp'] as String,
              disasterType: typhoon['type'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching typhoon warnings: $e');
      return [];
    }
  }

  // Fetch flood warnings from PAGASA
  Future<List<AlertModel>> getFloodWarnings() async {
    try {
      // Mock data for flood warnings
      final mockFloods = [
        {
          'id': 'flood_001',
          'name': 'Flash Flood Warning',
          'description':
              'Flash flood warning issued for Metro Manila and surrounding areas due to heavy monsoon rains. Avoid low-lying areas and waterways.',
          'status': 'Active',
          'location': 'Metro Manila, Philippines',
          'timestamp': DateTime.now()
              .subtract(const Duration(minutes: 30))
              .toIso8601String(),
          'type': 'Flood',
        },
        {
          'id': 'flood_002',
          'name': 'River Flood Watch',
          'description':
              'Rising water levels observed in Marikina River. Residents in flood-prone areas should prepare for possible evacuation.',
          'status': 'Watch',
          'location': 'Marikina City, Philippines',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
          'type': 'Flood',
        },
      ];

      return mockFloods
          .map(
            (flood) => AlertModel(
              id: flood['id'] as String,
              alertname: flood['name'] as String,
              description: flood['description'] as String,
              status: flood['status'] as String,
              address: flood['location'] as String,
              timestamp: flood['timestamp'] as String,
              disasterType: flood['type'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching flood warnings: $e');
      return [];
    }
  }

  // Fetch earthquake information from PHIVOLCS
  Future<List<AlertModel>> getEarthquakeAlerts() async {
    try {
      // Mock data for earthquake alerts
      final mockEarthquakes = [
        {
          'id': 'earthquake_001',
          'name': 'Earthquake Information',
          'description':
              'Magnitude 4.2 earthquake recorded in Zambales. No tsunami threat. Aftershocks possible.',
          'status': 'Resolved',
          'location': 'Zambales Province, Philippines',
          'timestamp': DateTime.now()
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
          'type': 'Earthquake',
        },
      ];

      return mockEarthquakes
          .map(
            (earthquake) => AlertModel(
              id: earthquake['id'] as String,
              alertname: earthquake['name'] as String,
              description: earthquake['description'] as String,
              status: earthquake['status'] as String,
              address: earthquake['location'] as String,
              timestamp: earthquake['timestamp'] as String,
              disasterType: earthquake['type'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching earthquake alerts: $e');
      return [];
    }
  }

  // Fetch volcanic activity from PHIVOLCS
  Future<List<AlertModel>> getVolcanoAlerts() async {
    try {
      // Mock data for volcano alerts
      final mockVolcanoes = [
        {
          'id': 'volcano_001',
          'name': 'Mayon Volcano Alert Level 2',
          'description':
              'Mayon Volcano remains at Alert Level 2. Increased seismic activity observed. Residents should stay alert.',
          'status': 'Active',
          'location': 'Albay Province, Philippines',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'type': 'Volcanic Activity',
        },
      ];

      return mockVolcanoes
          .map(
            (volcano) => AlertModel(
              id: volcano['id'] as String,
              alertname: volcano['name'] as String,
              description: volcano['description'] as String,
              status: volcano['status'] as String,
              address: volcano['location'] as String,
              timestamp: volcano['timestamp'] as String,
              disasterType: volcano['type'] as String,
            ),
          )
          .toList();
    } catch (e) {
      print('Error fetching volcano alerts: $e');
      return [];
    }
  }

  // Get all Philippine disaster alerts
  Future<List<AlertModel>> getAllDisasterAlerts() async {
    try {
      final results = await Future.wait([
        getTyphoonWarnings(),
        getFloodWarnings(),
        getEarthquakeAlerts(),
        getVolcanoAlerts(),
      ]);

      final allAlerts = <AlertModel>[];
      for (final alerts in results) {
        allAlerts.addAll(alerts);
      }

      // Sort by timestamp (most recent first)
      allAlerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return allAlerts;
    } catch (e) {
      print('Error fetching all disaster alerts: $e');
      return [];
    }
  }

  // Get active alerts only
  Future<List<AlertModel>> getActiveAlerts() async {
    final allAlerts = await getAllDisasterAlerts();
    return allAlerts.where((alert) => alert.status == 'Active').toList();
  }

  // Get alerts by type
  Future<List<AlertModel>> getAlertsByType(String disasterType) async {
    final allAlerts = await getAllDisasterAlerts();
    return allAlerts
        .where(
          (alert) =>
              alert.disasterType.toLowerCase() == disasterType.toLowerCase(),
        )
        .toList();
  }
}
