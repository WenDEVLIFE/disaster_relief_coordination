import 'package:latlong2/latlong.dart' as latlong2;

class DirectionsModel {
  final String origin;
  final String destination;
  final String distance;
  final String duration;
  final String instructions;
  final List<latlong2.LatLng> routePoints;

  DirectionsModel({
    required this.origin,
    required this.destination,
    required this.distance,
    required this.duration,
    required this.instructions,
    required this.routePoints,
  });

  // Copy with method for immutability
  DirectionsModel copyWith({
    String? origin,
    String? destination,
    String? distance,
    String? duration,
    String? instructions,
    List<latlong2.LatLng>? routePoints,
  }) {
    return DirectionsModel(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      routePoints: routePoints ?? this.routePoints,
    );
  }
}
