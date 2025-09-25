import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/RegisterRepository.dart';

/// Events for the Password Change BLoC
abstract class PasswordChangeEvent extends Equatable {
  const PasswordChangeEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordRequested extends PasswordChangeEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class PasswordChangeReset extends PasswordChangeEvent {
  const PasswordChangeReset();
}

/// States for the Password Change BLoC
abstract class PasswordChangeState extends Equatable {
  const PasswordChangeState();

  @override
  List<Object?> get props => [];
}

class PasswordChangeInitial extends PasswordChangeState {
  const PasswordChangeInitial();
}

class PasswordChangeLoading extends PasswordChangeState {
  const PasswordChangeLoading();
}

class PasswordChangeSuccess extends PasswordChangeState {
  const PasswordChangeSuccess();
}

class PasswordChangeFailure extends PasswordChangeState {
  final String error;

  const PasswordChangeFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// BLoC for handling password change operations
/// Manages the state of password change process including loading, success, and error states
class PasswordChangeBloc
    extends Bloc<PasswordChangeEvent, PasswordChangeState> {
  final RegisterRepository _registerRepository;

  PasswordChangeBloc({required RegisterRepository registerRepository})
    : _registerRepository = registerRepository,
      super(const PasswordChangeInitial()) {
    on<ChangePasswordRequested>(_onPasswordChangeRequested);
    on<PasswordChangeReset>(_onPasswordChangeReset);
  }

  Future<void> _onPasswordChangeRequested(
    ChangePasswordRequested event,
    Emitter<PasswordChangeState> emit,
  ) async {
    emit(const PasswordChangeLoading());

    try {
      await _registerRepository.changePassword(
        event.currentPassword,
        event.newPassword,
      );

      emit(const PasswordChangeSuccess());
    } catch (e) {
      emit(PasswordChangeFailure(e.toString()));
    }
  }

  void _onPasswordChangeReset(
    PasswordChangeReset event,
    Emitter<PasswordChangeState> emit,
  ) {
    emit(const PasswordChangeInitial());
  }
}
