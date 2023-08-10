import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/client_model.dart';
import 'package:http/http.dart' as http;

class ClientService {
  Future<Client?> fetchClientForUserId(String userId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/clients/getClientByUserId/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print (res.body);
      return Client.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }
}