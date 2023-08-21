import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<User?> fetchUserByUserId(String userId) async {
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

  Future<String> updateUserById(String id, User update) async {
    try {
      final res = await http.patch(
        Uri.parse('$uri/users/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(update.toJson()),
      );

      return res.body;
    } catch (e) {
      return 'error';
    }
  }
}
