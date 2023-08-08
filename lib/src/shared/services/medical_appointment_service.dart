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
      print(res);
      print(body);
      medicalAppointmentList = body.map((dynamic item) => MedicalAppointment.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }

    return medicalAppointmentList;
  }

  Future<int> createMedicalAppointment(MedicalAppointment medicalAppointment) async {
    try {
      int? clientId = medicalAppointment.clientId; 
      int? psychologistId = medicalAppointment.psychologistId; 

      final res = await http.post(
        Uri.parse('$uri/medical-appointment/$clientId/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(medicalAppointment.toJson()),
      );

      return 1;
    } catch (e) {
      print(e);
      return -1;
    }
  }
}
