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

  Future<User?> fetchUserByPsychologistId(String psychologistId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/getUserByPsychologistId/$psychologistId'),
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

  Future<User?> fetchUserByProperties(String cpf) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/getUserByProperties/$cpf'),
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

  Future<bool> canLogin(String phone, String password) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/login/$phone/$password'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print (res.body);
      final bool result = json.decode(res.body);
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User?> createUserAndClient(User user, Client client) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/users/createUserAndClient'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user': user.toJson(),
          'client': client.toJson(),
        }),
      );
      print(res.body);
      return User.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }
    return null;
  }
}