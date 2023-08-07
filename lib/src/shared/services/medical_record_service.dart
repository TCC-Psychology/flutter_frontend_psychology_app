import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/medical_record_model.dart';
import 'package:http/http.dart' as http;

class MedicalRecordService {
  Future<int> createMedicalRecord(MedicalRecord medicalAppointment) async {
    try {
      int? clientId = medicalAppointment.client.id; 
      int psychologistId = medicalAppointment.psychologist.id; 

      final res = await http.post(
        Uri.parse('$uri/medical-record/$psychologistId/$clientId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(medicalAppointment.creatToJson()),
      );

      print(res);

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