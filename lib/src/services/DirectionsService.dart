import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import '../model/DirectionsModel.dart';

class DirectionsService {
  static const String _googleMapsUrl = 'https://www.google.com/maps/dir/';
  static const String _googleMapsApiUrl = 'https://www.google.com/maps/dir/?api=1';
  static const String _googleNavigationUrl = 'google.navigation:q=';
  static const String _appleMapsUrl = 'https://maps.apple.com/?daddr=';

  /// Get directions using external map applications
  Future<bool> getDirections({
    required latlong2.LatLng origin,
    required latlong2.LatLng destination,
    required String destinationName,
    String transportMode = 'driving',
  }) async {
    try {
      // Convert Flutter transport mode to Google Maps travel mode
      String googleTravelMode = _convertToGoogleTravelMode(transportMode);
      
      // Try Google Navigation URL first (works best on Android)
      final googleNavigationUri = Uri.parse(
        '${_googleNavigationUrl}${destination.latitude},${destination.longitude}&mode=$googleTravelMode',
      );

      if (await canLaunchUrl(googleNavigationUri)) {
        await launchUrl(googleNavigationUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Fallback to Google Maps API URL
      final googleMapsApiUri = Uri.parse(
        '${_googleMapsApiUrl}&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=$googleTravelMode',
      );

      if (await canLaunchUrl(googleMapsApiUri)) {
        await launchUrl(googleMapsApiUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Fallback to basic Google Maps URL
      final googleMapsUri = Uri.parse(
        'https://www.google.com/maps/dir/${origin.latitude},${origin.longitude}/${destination.latitude},${destination.longitude}/',
      );

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Final fallback to Apple Maps (for iOS)
      final appleMapsUri = Uri.parse(
        '${_appleMapsUrl}${destination.latitude},${destination.longitude}&dirflg=${_convertToAppleMapsMode(transportMode)}',
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
      // Convert Flutter transport mode to Google Maps travel mode
      String googleTravelMode = _convertToGoogleTravelMode(transportMode);
      
      // Try Google Navigation URL first (works best on Android)
      final googleNavigationUri = Uri.parse(
        '${_googleNavigationUrl}${destination.latitude},${destination.longitude}&mode=$googleTravelMode',
      );

      if (await canLaunchUrl(googleNavigationUri)) {
        await launchUrl(googleNavigationUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Fallback to Google Maps API URL with current location
      final googleMapsApiUri = Uri.parse(
        '${_googleMapsApiUrl}&destination=${destination.latitude},${destination.longitude}&travelmode=$googleTravelMode',
      );

      if (await canLaunchUrl(googleMapsApiUri)) {
        await launchUrl(googleMapsApiUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Fallback to basic Google Maps URL
      final googleMapsUri = Uri.parse(
        'https://www.google.com/maps/dir/Current+Location/${destination.latitude},${destination.longitude}/',
      );

      if (await canLaunchUrl(googleMapsUri)) {
        await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
        return true;
      }

      // Final fallback to Apple Maps (for iOS)
      final appleMapsUri = Uri.parse(
        '${_appleMapsUrl}${destination.latitude},${destination.longitude}&dirflg=${_convertToAppleMapsMode(transportMode)}',
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

  /// Convert Flutter transport mode to Google Maps travel mode
  String _convertToGoogleTravelMode(String transportMode) {
    switch (transportMode.toLowerCase()) {
      case 'driving':
        return 'd';
      case 'walking':
        return 'w';
      case 'transit':
        return 'r';
      case 'bicycling':
        return 'b';
      default:
        return 'd'; // Default to driving
    }
  }

  /// Convert Flutter transport mode to Apple Maps mode
  String _convertToAppleMapsMode(String transportMode) {
    switch (transportMode.toLowerCase()) {
      case 'driving':
        return 'd';
      case 'walking':
        return 'w';
      case 'transit':
        return 'r';
      case 'bicycling':
        return 'b';
      default:
        return 'd'; // Default to driving
    }
  }
}
