import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/client_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';

class UserService {
  Future<User?> fetchUserForUserId(String userId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return User.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<User?> fetchUserForClientId(String clientId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/getUserByClientId/$clientId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return User.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<int> createUserAndClient(User user, Client client) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/createUserAndClient'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user': user.toJson(),
          'client': client.toJson(),
        }),
      );

      if (res.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }
}