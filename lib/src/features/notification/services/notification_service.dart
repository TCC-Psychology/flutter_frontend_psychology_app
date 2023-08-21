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
          'Content-Type': 'application/json; charset=UTF-8',
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
}
