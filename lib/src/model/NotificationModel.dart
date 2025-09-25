class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String timestamp;
  final bool isRead;
  final String priority;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.priority = 'normal',
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    String? timestamp,
    bool? isRead,
    String? priority,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'isRead': isRead,
      'priority': priority,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      timestamp: json['timestamp'] ?? '',
      isRead: json['isRead'] ?? false,
      priority: json['priority'] ?? 'normal',
    );
  }
}
