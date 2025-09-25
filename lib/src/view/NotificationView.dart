import 'package:disaster_relief_coordination/src/bloc/LanguageBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/NotificationBloc.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:disaster_relief_coordination/src/widgets/NotificationCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: CustomText(
          text: context.read<LanguageBloc>().translate('notifications'),
          fontFamily: 'GoogleSansCode',
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const _LoadingView();
            }

            if (state.error != null) {
              return _ErrorView(error: state.error!);
            }

            if (state.notifications.isEmpty) {
              return const _EmptyView();
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      context.read<NotificationBloc>().add(
                        MarkNotificationAsRead(notification.id),
                      );
                    }
                    _showNotificationDetails(context, notification);
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSampleNotification(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: CustomText(
                  text: context.read<LanguageBloc>().translate('clear_all'),
                  fontFamily: 'GoogleSansCode',
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.left,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _clearAllNotifications(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.mark_email_read),
                title: CustomText(
                  text: context.read<LanguageBloc>().translate('mark_all_read'),
                  fontFamily: 'GoogleSansCode',
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.left,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _markAllAsRead(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationDetails(BuildContext context, notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            text: notification.title,
            fontFamily: 'GoogleSansCode',
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: notification.message,
                fontFamily: 'GoogleSansCode',
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              CustomText(
                text: _formatFullTimestamp(notification.timestamp),
                fontFamily: 'GoogleSansCode',
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: CustomText(
                text: context.read<LanguageBloc>().translate('close'),
                fontFamily: 'GoogleSansCode',
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addSampleNotification(BuildContext context) {
    context.read<NotificationBloc>().add(const AddSampleNotification());
  }

  void _clearAllNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            text: context.read<LanguageBloc>().translate('confirm'),
            fontFamily: 'GoogleSansCode',
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
          content: CustomText(
            text: 'Are you sure you want to clear all notifications?',
            fontFamily: 'GoogleSansCode',
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
              child: CustomText(
                text: context.read<LanguageBloc>().translate('cancel'),
                fontFamily: 'GoogleSansCode',
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText(
                text: 'Clear All',
                fontFamily: 'GoogleSansCode',
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement clear all notifications
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications cleared'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _markAllAsRead(BuildContext context) {
    // TODO: Implement mark all as read functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatFullTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          CustomText(
            text: 'Loading notifications...',
            fontFamily: 'GoogleSansCode',
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          CustomText(
            text: 'Error loading notifications',
            fontFamily: 'GoogleSansCode',
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: error,
            fontFamily: 'GoogleSansCode',
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_none, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          CustomText(
            text: 'No notifications yet',
            fontFamily: 'GoogleSansCode',
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'Tap the + button to add a sample notification',
            fontFamily: 'GoogleSansCode',
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
