import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_filter_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<List<Notification>> fetchNotificationList(
    NotificationFilter notificationFilter,
  ) async {
    List<Notification> notificationList = [];

    try {
      final res = await http.post(
        Uri.parse('$uri/notifications'),
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
        body: json.encode(notificationFilter.toJson()),
      );
      List<dynamic> body = jsonDecode(res.body);

      notificationList =
          body.map((dynamic item) => Notification.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }

    return notificationList;
  }

  Future<Notification> editNotification(Notification notification) async {
    try {
      final Uri endpoint = Uri.parse('$uri/notifications/${notification.id}');
      final http.Response res = await http.patch(
        endpoint,
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
        body: jsonEncode(notification.toJson()),
      );

      if (res.statusCode != 200) {
        throw Exception(
          'Failed to edit notification with status: ${res.statusCode}',
        );
      }

      return Notification.fromJson(jsonDecode(res.body));
    } catch (error) {
      print(error);
      throw Exception(
        'Failed to edit notification',
      );
    }
  }

  Future<void> createNotificacaoForClient(
      Notification notification, String clientId) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/notifications/createForClient/$clientId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(notification.toJson()),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> createNotificacaoForPsychologist(
      Notification notification, String psychologistId) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/notifications/createForPsychologist/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(notification.toJson()),
      );
    } catch (e) {
      print(e);
    }
  }
}
