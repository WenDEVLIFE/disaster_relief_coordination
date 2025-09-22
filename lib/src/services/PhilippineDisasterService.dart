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
  Future<List<AlertModel>> getAllDisasterAlerts({
    double lat = 14.5995,
    double lon = 120.9842,
  }) async {
    try {
      final results = await Future.wait([
        getTyphoonWarnings(),
        getFloodWarnings(),
        getEarthquakeAlerts(),
        getVolcanoAlerts(),
        getWeatherAlerts(lat, lon), // Add weather alerts from OpenWeather
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

  // Fetch current weather from OpenWeather API
  Future<Map<String, dynamic>?> getCurrentWeather(
    double lat,
    double lon,
  ) async {
    try {
      final url =
          '$_openWeatherBaseUrl/weather?lat=$lat&lon=$lon&appid=$_openWeatherApiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load current weather: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching current weather: $e');
      return null;
    }
  }

  // Fetch weather alerts from OpenWeather API
  Future<Map<String, dynamic>?> getWeatherAlertsData(
    double lat,
    double lon,
  ) async {
    try {
      final url =
          '$_openWeatherBaseUrl/onecall?lat=$lat&lon=$lon&appid=$_openWeatherApiKey&exclude=current,minutely,hourly,daily';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load weather alerts: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather alerts: $e');
      return null;
    }
  }

  // Get weather alerts based on current conditions
  Future<List<AlertModel>> getWeatherAlerts(double lat, double lon) async {
    try {
      final weatherData = await getCurrentWeather(lat, lon);
      final alertsData = await getWeatherAlertsData(lat, lon);

      final alerts = <AlertModel>[];

      // Debug logging
      print('=== WEATHER API DEBUG ===');
      print('Weather Data received: ${weatherData != null ? 'YES' : 'NO'}');
      if (weatherData != null) {
        print('Weather main: ${weatherData['weather'][0]['main']}');
        print(
          'Weather description: ${weatherData['weather'][0]['description']}',
        );
        print('Temperature: ${weatherData['main']['temp']}°C');
        print('Wind speed: ${weatherData['wind']['speed']} m/s');
        print('Location: ${weatherData['name']}');
      } else {
        print('Weather API failed - no data received');
      }

      print(
        'Weather Alerts Data received: ${alertsData != null ? 'YES' : 'NO'}',
      );
      if (alertsData != null && alertsData['alerts'] != null) {
        print('Weather alerts from API: ${alertsData['alerts'].length}');
      }

      if (weatherData != null) {
        final weatherAlerts = _createWeatherAlertsFromData(
          weatherData,
          lat,
          lon,
        );
        alerts.addAll(weatherAlerts);
        print('Generated ${weatherAlerts.length} alerts from weather data');
      }

      if (alertsData != null && alertsData['alerts'] != null) {
        final apiAlerts = _createAlertsFromWeatherAPI(
          alertsData['alerts'],
          lat,
          lon,
        );
        alerts.addAll(apiAlerts);
        print('Generated ${apiAlerts.length} alerts from weather API');
      }

      // Add fallback weather alerts if no alerts were generated
      if (alerts.isEmpty) {
        print('No weather alerts generated from API, adding fallback alerts');
        alerts.addAll(_getFallbackWeatherAlerts(lat, lon));
      }

      print('Total weather alerts generated: ${alerts.length}');
      print('=== END WEATHER DEBUG ===');
      return alerts;
    } catch (e) {
      print('Error fetching weather alerts: $e');
      print('Stack trace: ${StackTrace.current}');
      // Return fallback alerts on error
      return _getFallbackWeatherAlerts(lat, lon);
    }
  }

  // Create weather alerts from current weather data
  List<AlertModel> _createWeatherAlertsFromData(
    Map<String, dynamic> weatherData,
    double lat,
    double lon,
  ) {
    final alerts = <AlertModel>[];
    final weather = weatherData['weather'][0];
    final main = weatherData['main'];
    final wind = weatherData['wind'];
    final location = weatherData['name'] ?? 'Current Location';

    final weatherMain = weather['main'].toString().toLowerCase();
    final description = weather['description'].toString();

    // Thunderstorm alert
    if (weatherMain.contains('thunderstorm')) {
      alerts.add(
        AlertModel(
          id: 'weather_thunderstorm_${DateTime.now().millisecondsSinceEpoch}',
          alertname: 'Thunderstorm Warning',
          description:
              'Thunderstorm conditions detected. Heavy rain and lightning expected. Stay indoors and avoid open areas.',
          status: 'Active',
          address: location,
          timestamp: DateTime.now().toIso8601String(),
          disasterType: 'Thunderstorm',
        ),
      );
    }

    // Heavy rain alert
    if (weatherMain.contains('rain') ||
        description.contains('heavy') ||
        description.contains('intense')) {
      alerts.add(
        AlertModel(
          id: 'weather_heavy_rain_${DateTime.now().millisecondsSinceEpoch}',
          alertname: 'Heavy Rain Warning',
          description:
              'Heavy rainfall detected. Possible flooding in low-lying areas. Avoid unnecessary travel.',
          status: 'Active',
          address: location,
          timestamp: DateTime.now().toIso8601String(),
          disasterType: 'Heavy Rain',
        ),
      );
    }

    // Extreme weather alert
    if (main['temp'] > 35 || main['temp'] < 5 || wind['speed'] > 20) {
      alerts.add(
        AlertModel(
          id: 'weather_extreme_${DateTime.now().millisecondsSinceEpoch}',
          alertname: 'Extreme Weather Alert',
          description:
              'Extreme weather conditions detected. Take necessary precautions and stay updated.',
          status: 'Active',
          address: location,
          timestamp: DateTime.now().toIso8601String(),
          disasterType: 'Extreme Weather',
        ),
      );
    }

    return alerts;
  }

  // Create alerts from OpenWeather API alerts
  List<AlertModel> _createAlertsFromWeatherAPI(
    List alertsData,
    double lat,
    double lon,
  ) {
    return alertsData.map<AlertModel>((alert) {
      return AlertModel(
        id: 'weather_api_${alert['event']}_${DateTime.now().millisecondsSinceEpoch}',
        alertname: alert['event'] ?? 'Weather Alert',
        description: alert['description'] ?? 'Weather alert for your area',
        status: 'Active',
        address: 'Current Location',
        timestamp: DateTime.now().toIso8601String(),
        disasterType: _mapWeatherEventToDisasterType(alert['event']),
      );
    }).toList();
  }

  // Map weather event to disaster type
  String _mapWeatherEventToDisasterType(String? event) {
    if (event == null) return 'Weather';

    final eventLower = event.toLowerCase();

    if (eventLower.contains('flood')) return 'Flood';
    if (eventLower.contains('storm') || eventLower.contains('thunder'))
      return 'Thunderstorm';
    if (eventLower.contains('rain')) return 'Heavy Rain';
    if (eventLower.contains('wind')) return 'Strong Wind';
    if (eventLower.contains('heat')) return 'Extreme Heat';
    if (eventLower.contains('cold')) return 'Extreme Cold';

    return 'Weather';
  }

  // Get fallback weather alerts for testing and when API fails
  List<AlertModel> _getFallbackWeatherAlerts(double lat, double lon) {
    final now = DateTime.now();
    final location = 'Manila, Philippines';

    return [
      AlertModel(
        id: 'fallback_thunderstorm_${now.millisecondsSinceEpoch}',
        alertname: 'Thunderstorm Warning',
        description:
            '⚡ Thunderstorm conditions possible. Heavy rain and lightning expected. Stay indoors and avoid open areas. Monitor weather updates.',
        status: 'Active',
        address: location,
        timestamp: now.toIso8601String(),
        disasterType: 'Thunderstorm',
      ),
      AlertModel(
        id: 'fallback_heavy_rain_${now.millisecondsSinceEpoch}',
        alertname: 'Heavy Rain Warning',
        description:
            '🌧️ Heavy rainfall expected. Possible flooding in low-lying areas. Avoid unnecessary travel and stay updated with PAGASA advisories.',
        status: 'Active',
        address: location,
        timestamp: now.subtract(const Duration(minutes: 15)).toIso8601String(),
        disasterType: 'Heavy Rain',
      ),
      AlertModel(
        id: 'fallback_flood_watch_${now.millisecondsSinceEpoch}',
        alertname: 'Flood Watch',
        description:
            '🏔️ Rising water levels possible due to continuous rains. Residents in flood-prone areas should prepare for possible evacuation.',
        status: 'Watch',
        address: location,
        timestamp: now.subtract(const Duration(hours: 1)).toIso8601String(),
        disasterType: 'Flood',
      ),
    ];
  }
}
