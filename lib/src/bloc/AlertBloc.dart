import 'package:disaster_relief_coordination/src/model/AlertModel.dart';
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

  const AlertState(this.alerts);

  @override
  List<Object> get props => [alerts];
}

class AlertBloc extends Bloc<AlertEvents, AlertState> {

  AlertBloc() : super(const AlertState([])) {
    on<AlertEvents>((event, emit) {
      // Replace with your actual data source
      emit(AlertState([
        AlertModel(
          id : '1',
          alertname: 'Flood Alert',
          description: 'Heavy rainfall expected in the area.',
          status: 'Active',
          address: '123 Main St, City',
          timestamp: '2023-10-01 12:00',
          disasterType: 'Flood',
        ),

        AlertModel(
          id : '2',
          alertname: 'Earthquake Alert',
          description: 'Seismic activity detected.',
          status: 'Active',
          address: '456 Elm St, City',
          timestamp: '2023-10-01 14:00',
          disasterType: 'Earthquake',
        ),

        AlertModel(
          id : '3',
          alertname: 'Wildfire Alert',
          description: 'Wildfire reported in the area.',
          status: 'Active',
          address: '789 Oak St, City',
          timestamp: '2023-10-01 16:00',
          disasterType: 'Wildfire',
        ),

        AlertModel(
          id : '4',
          alertname: 'Tornado Alert',
          description: 'Tornado warning issued for the area.',
          status: 'Active',
          address: '101 Pine St, City',
          timestamp: '2023-10-01 18:00',
          disasterType: 'Tornado',
        ),

        AlertModel(
          id : '5',
          alertname: 'Hurricane Alert',
          description: 'Hurricane approaching the coast.',
          status: 'Active',
          address: '202 Maple St, City',
          timestamp: '2023-10-01 20:00',
          disasterType: 'Hurricane',
        ),

      ]));
    });
  }

}