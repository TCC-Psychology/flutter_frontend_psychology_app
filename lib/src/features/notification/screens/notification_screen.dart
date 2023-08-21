import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/notification/services/notification_service.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_filter_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_model.dart'
    as models;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService notificationService = NotificationService();
  List<models.Notification> notifications = [];

  // List<models.Notification> notifications = [
  //   models.Notification(description: 'Josh liked your photo'),
  //   models.Notification(description: 'Joe liked your photo'),
  //   models.Notification(description: 'Jane liked your photo'),
  // ];

  @override
  void initState() {
    super.initState();
    int clientId = 1;
    int psychologistId = 1;
    fetchPsychologistList(clientId, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'Nenhuma notificação encontrada',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return ListTile(
                  title: Text(
                    notification.description,
                    style: TextStyle(
                      fontWeight: notification.viewed
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  leading: notification.viewed
                      ? const Icon(Icons.notifications_outlined)
                      : const Icon(Icons.notifications),
                  onTap: () {
                    setState(() {
                      notification.viewed = true;
                    });
                  },
                );
              },
            ),
    );
  }

  fetchPsychologistList(int? clientId, int? psychologistId) async {
    EasyLoading.show(status: 'Loading...');

    final NotificationFilter notificationFilter =
        NotificationFilter(clientId: clientId, psychologistId: psychologistId);

    notifications =
        await notificationService.fetchNotificationList(notificationFilter);

    setState(() {});

    EasyLoading.dismiss();
  }
}
