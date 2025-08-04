import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

class FetchAlerts extends AlertEvent {
  const FetchAlerts();

  @override
  List<Object> get props => [];
}

class AddAlert extends AlertEvent {
  final String alert;

  const AddAlert(this.alert);

  @override
  List<Object> get props => [alert];
}

class RemoveAlert extends AlertEvent {
  final String alert;

  const RemoveAlert(this.alert);

  @override
  List<Object> get props => [alert];
}

class ClearAlerts extends AlertEvent {
  const ClearAlerts();

  @override
  List<Object> get props => [];
}


class UpdateAlert extends AlertEvent {
  final String oldAlert;
  final String newAlert;

  const UpdateAlert(this.oldAlert, this.newAlert);

  @override
  List<Object> get props => [oldAlert, newAlert];
}


class AlertBloc extends Bloc<AlertEvent, List<String>> {
  AlertBloc() : super([]);

  @override
  Stream<List<String>> mapEventToState(AlertEvent event) async* {

  }
}