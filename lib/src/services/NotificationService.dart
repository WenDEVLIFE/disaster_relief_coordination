import 'dart:convert';
import 'package:disaster_relief_coordination/src/model/NotificationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _notificationsKey = 'notifications';
  static const String _notificationCounterKey = 'notification_counter';

  /// Get all notifications from shared preferences
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList(_notificationsKey) ?? [];

      return notificationsJson
          .map((json) => NotificationModel.fromJson(jsonDecode(json)))
          .toList()
        ..sort(
          (a, b) => b.timestamp.compareTo(a.timestamp),
        ); // Sort by newest first
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  /// Add a new notification
  Future<void> addNotification(NotificationModel notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getAllNotifications();

      // Check if notification with same ID already exists
      final existingIndex = notifications.indexWhere(
        (n) => n.id == notification.id,
      );

      if (existingIndex >= 0) {
        // Update existing notification
        notifications[existingIndex] = notification;
      } else {
        // Add new notification
        notifications.add(notification);
      }

      await _saveNotifications(notifications);
    } catch (e) {
      print('Error adding notification: $e');
      throw Exception('Failed to add notification');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final notifications = await getAllNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);

      if (index >= 0) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        await _saveNotifications(notifications);
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final notifications = await getAllNotifications();
      notifications.removeWhere((n) => n.id == notificationId);
      await _saveNotifications(notifications);
    } catch (e) {
      print('Error deleting notification: $e');
      throw Exception('Failed to delete notification');
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    try {
      final notifications = await getAllNotifications();
      return notifications.where((n) => !n.isRead).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationsKey);
    } catch (e) {
      print('Error clearing notifications: $e');
      throw Exception('Failed to clear notifications');
    }
  }

  /// Generate unique ID for notifications
  Future<String> _generateId() async {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt(_notificationCounterKey) ?? 0;
    final newCounter = counter + 1;

    await prefs.setInt(_notificationCounterKey, newCounter);
    return 'notification_$newCounter';
  }

  /// Save notifications to shared preferences
  Future<void> _saveNotifications(List<NotificationModel> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = notifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();

      await prefs.setStringList(_notificationsKey, notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
      throw Exception('Failed to save notifications');
    }
  }

  /// Create and add a sample notification for testing
  Future<void> addSampleNotification() async {
    final id = await _generateId();
    final now = DateTime.now().toIso8601String();

    final sampleNotification = NotificationModel(
      id: id,
      title: 'Welcome to Disaster Relief Coordination',
      message:
          'Thank you for using our app. Stay safe and informed about emergency situations in your area.',
      type: 'welcome',
      timestamp: now,
      priority: 'normal',
    );

    await addNotification(sampleNotification);
  }

  /// Create and add emergency notification
  Future<void> addEmergencyNotification({
    required String title,
    required String message,
    String priority = 'high',
  }) async {
    final id = await _generateId();
    final now = DateTime.now().toIso8601String();

    final emergencyNotification = NotificationModel(
      id: id,
      title: title,
      message: message,
      type: 'emergency',
      timestamp: now,
      priority: priority,
    );

    await addNotification(emergencyNotification);
  }

  /// Create and add system notification
  Future<void> addSystemNotification({
    required String title,
    required String message,
  }) async {
    final id = await _generateId();
    final now = DateTime.now().toIso8601String();

    final systemNotification = NotificationModel(
      id: id,
      title: title,
      message: message,
      type: 'system',
      timestamp: now,
      priority: 'normal',
    );

    await addNotification(systemNotification);
  }
}
