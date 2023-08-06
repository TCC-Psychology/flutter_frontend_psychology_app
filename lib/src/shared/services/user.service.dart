import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';

class UserService {
  Future<User?> fetchUser(String userId) async {
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
}