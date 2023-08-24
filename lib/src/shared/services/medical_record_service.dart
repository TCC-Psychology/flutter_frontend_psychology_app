import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/medical_record_model.dart';
import 'package:http/http.dart' as http;

class MedicalRecordService {
  Future<int> createMedicalRecord(MedicalRecord medicalRecord) async {
    try {
      int clientId = medicalRecord.clientId!;
      int psychologistId = medicalRecord.psychologistId!;

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

  Future<int> editMedicalRecord(MedicalRecord medicalRecord, int id) async {
    try {
      final res = await http.patch(
        Uri.parse('$uri/medical-record/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(medicalRecord.toJson()),
      );
      if (res.statusCode == 200) {
        return 1;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }

  Future<List<MedicalRecord>> fetchMedicalRecordtList(
      String psychologistId, String clientId) async {
    List<MedicalRecord> medicalRecord = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/medical-record/$clientId/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      List<dynamic> body = jsonDecode(res.body);
      medicalRecord =
          body.map((dynamic item) => MedicalRecord.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }
    return medicalRecord;
  }

  Future<int> deleteMedicalRecord(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$uri/medical-record/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return 1;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<MedicalRecord?> fetchMedicalRecordById(String id) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/medical-record/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return MedicalRecord.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return null;
  }
}
