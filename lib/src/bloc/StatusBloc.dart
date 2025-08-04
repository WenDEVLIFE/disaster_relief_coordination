import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class StatusLoadEvent extends StatusEvent {
  const StatusLoadEvent();

  @override
  List<Object> get props => [];
}

class StatusUpdateEvent extends StatusEvent {
  final String status;

  const StatusUpdateEvent(this.status);

  @override
  List<Object> get props => [status];
}

class StatusBloc extends Bloc<StatusEvent, String> {
  StatusBloc() : super('Safe') {
    on<StatusLoadEvent>((event, emit) {
      // Load the initial status, if needed
      emit('Safe');
    });

    on<StatusUpdateEvent>((event, emit) {
      // Update the status based on the event
      emit(event.status);
    });
  }
}