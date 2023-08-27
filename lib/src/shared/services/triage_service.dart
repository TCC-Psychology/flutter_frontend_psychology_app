import 'package:flutter_frontend_psychology_app/src/models/triage_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';

class TriageService {
  Future<int> createTriage(Triage triage, String medicalAppointmentsId) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/triage/$medicalAppointmentsId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(triage.toJson()),
      );

      return 1;
    } catch (e) {
      print(e);
      return -1;
    }
  }
}
