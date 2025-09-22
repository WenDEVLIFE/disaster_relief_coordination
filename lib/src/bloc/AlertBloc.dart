import 'package:disaster_relief_coordination/src/model/AlertModel.dart';
import 'package:disaster_relief_coordination/src/services/PhilippineDisasterService.dart';
import 'package:disaster_relief_coordination/src/services/GdacsService.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AlertEvents extends Equatable {
  const AlertEvents();

  @override
  List<Object> get props => [];
}

class LoadAlerts extends AlertEvents {
  const LoadAlerts();
}

class AlertState extends AlertEvents {
  final List<AlertModel> alerts;
  final bool isLoading;
  final String? error;

  const AlertState(this.alerts, {this.isLoading = false, this.error});

  AlertState copyWith({
    List<AlertModel>? alerts,
    bool? isLoading,
    String? error,
  }) {
    return AlertState(
      alerts ?? this.alerts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [alerts, isLoading, error ?? ''];
}

class AlertBloc extends Bloc<AlertEvents, AlertState> {
  final PhilippineDisasterService _disasterService;
  final GdacsService _gdacsService;

  AlertBloc({
    required PhilippineDisasterService disasterService,
    required GdacsService gdacsService,
  }) : _disasterService = disasterService,
       _gdacsService = gdacsService,
       super(const AlertState([])) {
    on<LoadAlerts>(_onLoadAlerts);
  }

  Future<void> _onLoadAlerts(LoadAlerts event, Emitter<AlertState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Fetch real Philippine disaster alerts
      final philippineAlerts = await _disasterService.getAllDisasterAlerts();

      // Fetch GDACS alerts (floods and typhoons)
      final gdacsAlerts = await _gdacsService.getAllGdacsAlerts();

      // Combine all alerts
      final allAlerts = [...philippineAlerts, ...gdacsAlerts];

      emit(state.copyWith(alerts: allAlerts, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to load alerts: $e'),
      );
    }
  }
}
