import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import '../model/DirectionsModel.dart';
import '../services/DirectionsService.dart';

// Directions Events
abstract class DirectionsEvent extends Equatable {
  const DirectionsEvent();

  @override
  List<Object?> get props => [];
}

class GetDirectionsFromCurrentLocation extends DirectionsEvent {
  final latlong2.LatLng destination;
  final String destinationName;
  final String transportMode;

  const GetDirectionsFromCurrentLocation({
    required this.destination,
    required this.destinationName,
    this.transportMode = 'driving',
  });

  @override
  List<Object?> get props => [destination, destinationName, transportMode];
}

class GetDirectionsFromSpecificLocation extends DirectionsEvent {
  final latlong2.LatLng origin;
  final latlong2.LatLng destination;
  final String destinationName;
  final String transportMode;

  const GetDirectionsFromSpecificLocation({
    required this.origin,
    required this.destination,
    required this.destinationName,
    this.transportMode = 'driving',
  });

  @override
  List<Object?> get props => [
    origin,
    destination,
    destinationName,
    transportMode,
  ];
}

class ResetDirections extends DirectionsEvent {
  const ResetDirections();
}

// Directions State
abstract class DirectionsState extends Equatable {
  const DirectionsState();

  @override
  List<Object?> get props => [];
}

class DirectionsInitial extends DirectionsState {}

class DirectionsLoading extends DirectionsState {}

class DirectionsLoaded extends DirectionsState {
  final String origin;
  final String destination;
  final String distance;
  final String duration;
  final String instructions;
  final List<latlong2.LatLng> routePoints;

  const DirectionsLoaded({
    required this.origin,
    required this.destination,
    required this.distance,
    required this.duration,
    required this.instructions,
    required this.routePoints,
  });

  @override
  List<Object?> get props => [
    origin,
    destination,
    distance,
    duration,
    instructions,
    routePoints,
  ];
}

class DirectionsError extends DirectionsState {
  final String message;

  const DirectionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Directions Bloc
class DirectionsBloc extends Bloc<DirectionsEvent, DirectionsState> {
  final DirectionsService _directionsService = DirectionsService();

  DirectionsBloc() : super(DirectionsInitial()) {
    on<GetDirectionsFromCurrentLocation>((event, emit) async {
      emit(DirectionsLoading());

      try {
        final success = await _directionsService
            .getDirectionsFromCurrentLocation(
              destination: event.destination,
              destinationName: event.destinationName,
              transportMode: event.transportMode,
            );

        if (success) {
          emit(
            DirectionsLoaded(
              origin: 'Current Location',
              destination: event.destinationName,
              distance: 'Calculating...',
              duration: 'Calculating...',
              instructions: 'Directions opened in external map application',
              routePoints: [event.destination],
            ),
          );
        } else {
          emit(DirectionsError('Unable to open map application'));
        }
      } catch (e) {
        emit(DirectionsError('Error getting directions: ${e.toString()}'));
      }
    });

    on<GetDirectionsFromSpecificLocation>((event, emit) async {
      emit(DirectionsLoading());

      try {
        final success = await _directionsService.getDirections(
          origin: event.origin,
          destination: event.destination,
          destinationName: event.destinationName,
          transportMode: event.transportMode,
        );

        if (success) {
          emit(
            DirectionsLoaded(
              origin: '${event.origin.latitude}, ${event.origin.longitude}',
              destination: event.destinationName,
              distance: 'Calculating...',
              duration: 'Calculating...',
              instructions: 'Directions opened in external map application',
              routePoints: [event.destination],
            ),
          );
        } else {
          emit(DirectionsError('Unable to open map application'));
        }
      } catch (e) {
        emit(DirectionsError('Error getting directions: ${e.toString()}'));
      }
    });

    on<ResetDirections>((event, emit) {
      emit(DirectionsInitial());
    });
  }
}
