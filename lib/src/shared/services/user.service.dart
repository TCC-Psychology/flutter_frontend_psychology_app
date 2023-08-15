import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/client_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';

class UserProfileService {
  Future<UserProfile?> fetchUserByUserId(String userId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return UserProfile.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<UserProfile?> fetchUserByClientId(String clientId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/getUserByClientId/$clientId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return UserProfile.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<UserProfile?> fetchUserByPsychologistId(String psychologistId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/getUserByPsychologistId/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return UserProfile.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<UserProfile?> fetchUserByProperties(String cpf) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/users/getUserByProperties/$cpf'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return UserProfile.fromJson(jsonDecode(res.body));
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
      print(res.body);
      final bool result = json.decode(res.body);
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserProfile?> createUserAndClient(
      UserProfile user, Client client) async {
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
      return UserProfile.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<UserProfile?> createUserAndPsychologist(
    UserProfile user,
    Psychologist psychologist,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/users/createUserAndPsychologist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user': user.toJson(),
          'psychologist': psychologist.toJson(),
        }),
      );
      return UserProfile.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }
    return null;
  }
}
