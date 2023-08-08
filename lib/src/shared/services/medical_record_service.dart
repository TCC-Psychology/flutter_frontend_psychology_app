import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/medical_record_model.dart';
import 'package:http/http.dart' as http;

class MedicalRecordService {
  Future<int> createMedicalRecord(MedicalRecord medicalRecord) async {
    try {
      int? clientId = medicalRecord.clientId; 
      int? psychologistId = medicalRecord.psychologistId; 

      final res = await http.post(
        Uri.parse('$uri/medical-record/$psychologistId/$clientId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(medicalRecord.toJson()),
      );

      return 1;
    } catch (e) {
      print(e);
      return -1;
    }
  }
}