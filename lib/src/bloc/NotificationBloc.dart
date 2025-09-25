import 'package:disaster_relief_coordination/src/model/NotificationModel.dart';
import 'package:disaster_relief_coordination/src/services/NotificationService.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

class AddNotification extends NotificationEvent {
  final NotificationModel notification;

  const AddNotification(this.notification);

  @override
  List<Object> get props => [notification];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class AddSampleNotification extends NotificationEvent {
  const AddSampleNotification();
}

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [notifications, isLoading, error];
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc({required NotificationService notificationService})
    : _notificationService = notificationService,
      super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<AddNotification>(_onAddNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<AddSampleNotification>(_onAddSampleNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final notifications = await _notificationService.getAllNotifications();

      emit(state.copyWith(notifications: notifications, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load notifications: $e',
        ),
      );
    }
  }

  Future<void> _onAddNotification(
    AddNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.addNotification(event.notification);

      final updatedNotifications = await _notificationService
          .getAllNotifications();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add notification: $e'));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.markAsRead(event.notificationId);

      final updatedNotifications = await _notificationService
          .getAllNotifications();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to mark notification as read: $e'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.deleteNotification(event.notificationId);

      final updatedNotifications = await _notificationService
          .getAllNotifications();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete notification: $e'));
    }
  }

  Future<void> _onAddSampleNotification(
    AddSampleNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.addSampleNotification();

      final updatedNotifications = await _notificationService
          .getAllNotifications();

      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add sample notification: $e'));
    }
  }
}
