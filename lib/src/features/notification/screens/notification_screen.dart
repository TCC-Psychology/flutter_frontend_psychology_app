import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/main.dart';
import 'package:flutter_frontend_psychology_app/src/features/notification/services/notification_service.dart';
import 'package:flutter_frontend_psychology_app/src/models/client_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_filter_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_model.dart'
    as models;
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/client_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ClientService clientService = ClientService();
  final PsychologistService psychologistService = PsychologistService();
  final NotificationService notificationService = NotificationService();
  List<models.Notification> notifications = [];
  Client? client;
  Psychologist? psychologist;
  var userLoggedId = supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    loadPageUtilities();
  }

  loadPageUtilities() async {
    try {
      EasyLoading.show(status: 'Carregando...');

      client = await clientService.fetchClientByUserId(userLoggedId);
      if (client == null) {
        psychologist =
            await psychologistService.fetchPsychologistByUserId(userLoggedId);

        fetchNotificationList(null, psychologist!.id!);
      } else {
        fetchNotificationList(client!.id!, null);
      }
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              "Notificações",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: notifications.isEmpty
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
                              updateNotification(notification);
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  fetchNotificationList(int? clientId, int? psychologistId) async {
    EasyLoading.show(status: 'Carregando...');

    final NotificationFilter notificationFilter =
        NotificationFilter(clientId: clientId, psychologistId: psychologistId);

    notifications =
        await notificationService.fetchNotificationList(notificationFilter);

    setState(() {});

    EasyLoading.dismiss();
  }

  updateNotification(models.Notification notification) {
    if (!notification.viewed) {
      notification.viewed = true;
      notificationService.editNotification(notification);
    }
  }
}
