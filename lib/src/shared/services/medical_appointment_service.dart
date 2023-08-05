import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../models/medical_appointment_model.dart';

class MedicalAppointmentService {
  Future<List<MedicalAppointment>> fetchMedicalAppointmentList(String psychologistId, String clienteId) async {
    List<MedicalAppointment> medicalAppointmentList = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/medical-appointment/$clienteId/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> body = jsonDecode(res.body);

      medicalAppointmentList = body.map((dynamic item) => MedicalAppointment.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }

    return medicalAppointmentList;
  }
}
