import 'dart:convert';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:io' show Platform;

class GdacsService {
  static const String _baseUrl = 'https://www.gdacs.org';

  // GDACS RSS feed for all events in the last 24 hours
  static const String _rssFeedUrl = '$_baseUrl/xml/rss.xml';

  // GDACS API for specific event types
  static const String _apiBaseUrl = '$_baseUrl/gdacsapi/api';

  /// Fetch flood alerts from GDACS RSS feed
  Future<List<AlertModel>> getFloodAlerts() async {
    try {
      final response = await http.get(Uri.parse(_rssFeedUrl));

      if (response.statusCode == 200) {
        // Parse RSS XML to extract flood alerts
        return _parseRssFeed(response.body, 'Flood');
      } else {
        print('Failed to load GDACS flood alerts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching GDACS flood alerts: $e');
      return [];
    }
  }

  /// Fetch typhoon/cyclone alerts from GDACS RSS feed
  Future<List<AlertModel>> getTyphoonAlerts() async {
    try {
      final response = await http.get(Uri.parse(_rssFeedUrl));

      if (response.statusCode == 200) {
        // Parse RSS XML to extract typhoon alerts
        return _parseRssFeed(response.body, 'Tropical Cyclone');
      } else {
        print('Failed to load GDACS typhoon alerts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching GDACS typhoon alerts: $e');
      return [];
    }
  }

  /// Fetch all GDACS alerts (floods and typhoons)
  Future<List<AlertModel>> getAllGdacsAlerts() async {
    try {
      final results = await Future.wait([getFloodAlerts(), getTyphoonAlerts()]);

      final allAlerts = <AlertModel>[];
      for (final alerts in results) {
        allAlerts.addAll(alerts);
      }

      // Sort by timestamp (most recent first)
      allAlerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return allAlerts;
    } catch (e) {
      print('Error fetching all GDACS alerts: $e');
      return [];
    }
  }

  /// Parse RSS feed and extract alerts of specific type
  List<AlertModel> _parseRssFeed(String xmlData, String alertType) {
    final alerts = <AlertModel>[];

    try {
      final document = XmlDocument.parse(xmlData);
      final items = document.findAllElements('item');

      for (final item in items) {
        final title = item.findElements('title').firstOrNull?.text ?? '';
        final description =
            item.findElements('description').firstOrNull?.text ?? '';
        final pubDate = item.findElements('pubDate').firstOrNull?.text ?? '';
        final guid = item.findElements('guid').firstOrNull?.text ?? '';

        // Check if this item matches our alert type
        if (_matchesAlertType(title, alertType)) {
          final alert = AlertModel(
            id: guid.isNotEmpty
                ? guid
                : DateTime.now().millisecondsSinceEpoch.toString(),
            alertname: title,
            description: description,
            status: 'Active',
            address: 'Global', // GDACS doesn't provide specific location in RSS
            timestamp: pubDate,
            disasterType: alertType,
          );

          alerts.add(alert);
        }
      }

      return alerts;
    } catch (e) {
      print('Error parsing RSS feed for $alertType: $e');
      // Return mock data if parsing fails
      return _getMockAlerts(alertType);
    }
  }

  /// Check if the title matches the alert type
  bool _matchesAlertType(String title, String alertType) {
    final lowerTitle = title.toLowerCase();
    final lowerAlertType = alertType.toLowerCase();

    if (lowerAlertType == 'flood') {
      return lowerTitle.contains('flood') ||
          lowerTitle.contains('flash flood') ||
          lowerTitle.contains('river flood');
    } else if (lowerAlertType == 'tropical cyclone') {
      return lowerTitle.contains('cyclone') ||
          lowerTitle.contains('typhoon') ||
          lowerTitle.contains('hurricane') ||
          lowerTitle.contains('tropical storm');
    }

    return lowerTitle.contains(lowerAlertType);
  }

  /// Get mock alerts for testing
  List<AlertModel> _getMockAlerts(String alertType) {
    final mockAlerts = [
      {
        'id': 'gdacs_${alertType.toLowerCase()}_001',
        'name': '$alertType Alert',
        'description': 'GDACS $alertType alert for demonstration purposes',
        'status': 'Active',
        'location': 'Global',
        'timestamp': DateTime.now().toIso8601String(),
        'type': alertType,
      },
    ];

    return mockAlerts
        .map(
          (alert) => AlertModel(
            id: alert['id'] as String,
            alertname: alert['name'] as String,
            description: alert['description'] as String,
            status: alert['status'] as String,
            address: alert['location'] as String,
            timestamp: alert['timestamp'] as String,
            disasterType: alert['type'] as String,
          ),
        )
        .toList();
  }

  /// Fetch detailed event information from GDACS API
  Future<Map<String, dynamic>?> getEventDetails(
    String eventType,
    String eventId,
  ) async {
    try {
      final url = '$_apiBaseUrl/events/$eventType/$eventId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load GDACS event details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching GDACS event details: $e');
      return null;
    }
  }
}
