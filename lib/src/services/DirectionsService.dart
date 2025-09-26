import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import '../model/DirectionsModel.dart';

class DirectionsService {
  static const String _googleMapsUrl = 'https://www.google.com/maps/dir/';
  static const String _appleMapsUrl = 'https://maps.apple.com/?daddr=';

  /// Get directions using external map applications
  Future<bool> getDirections({
    required latlong2.LatLng origin,
    required latlong2.LatLng destination,
    required String destinationName,
    String transportMode = 'driving',
  }) async {
    try {
      // Try to launch Google Maps first
      final googleMapsUri = Uri.parse(
        '${_googleMapsUrl}${origin.latitude},${origin.longitude}/${destination.latitude},${destination.longitude}/@${destination.latitude},${destination.longitude},15z?directionsmode=$transportMode',
      );

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Fallback to Apple Maps
      final appleMapsUri = Uri.parse(
        '${_appleMapsUrl}${destination.latitude},${destination.longitude}&dirflg=$transportMode',
      );

      if (await canLaunchUrl(appleMapsUri)) {
        await launchUrl(appleMapsUri, mode: LaunchMode.externalApplication);
        return true;
      }

      return false;
    } catch (e) {
      print('Error launching directions: $e');
      return false;
    }
  }

  /// Get directions with current location as origin
  Future<bool> getDirectionsFromCurrentLocation({
    required latlong2.LatLng destination,
    required String destinationName,
    String transportMode = 'driving',
  }) async {
    try {
      // Try to launch Google Maps with current location
      final googleMapsUri = Uri.parse(
        '${_googleMapsUrl}My+Location/${destination.latitude},${destination.longitude}/@${destination.latitude},${destination.longitude},15z?directionsmode=$transportMode',
      );

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Fallback to Apple Maps
      final appleMapsUri = Uri.parse(
        '${_appleMapsUrl}${destination.latitude},${destination.longitude}&dirflg=$transportMode',
      );

      if (await canLaunchUrl(appleMapsUri)) {
        await launchUrl(appleMapsUri, mode: LaunchMode.externalApplication);
        return true;
      }

      return false;
    } catch (e) {
      print('Error launching directions from current location: $e');
      return false;
    }
  }

  /// Get walking directions (for emergency situations)
  Future<bool> getWalkingDirections({
    required latlong2.LatLng origin,
    required latlong2.LatLng destination,
    required String destinationName,
  }) async {
    return getDirections(
      origin: origin,
      destination: destination,
      destinationName: destinationName,
      transportMode: 'walking',
    );
  }

  /// Get driving directions
  Future<bool> getDrivingDirections({
    required latlong2.LatLng origin,
    required latlong2.LatLng destination,
    required String destinationName,
  }) async {
    return getDirections(
      origin: origin,
      destination: destination,
      destinationName: destinationName,
      transportMode: 'driving',
    );
  }
}
