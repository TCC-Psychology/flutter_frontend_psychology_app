import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../models/medical_appointment_model.dart';

class MedicalAppointmentService {
  Future<List<MedicalAppointment>> fetchMedicalAppointmentList(
      String? psychologistId, String? clienteId) async {
    List<MedicalAppointment> medicalAppointmentList = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/medical-appointment/$clienteId/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> body = jsonDecode(res.body);
      medicalAppointmentList = body
          .map((dynamic item) => MedicalAppointment.fromJson(item))
          .toList();
    } catch (e) {
      print(e);
    }

    return medicalAppointmentList;
  }

  Future<MedicalAppointment?> createMedicalAppointment(
      MedicalAppointment medicalAppointment) async {
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

      return MedicalAppointment.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> editMedicalAppointment(
      MedicalAppointment medicalAppointment, String id) async {
    try {
      final res = await http.patch(
        Uri.parse('$uri/medical-appointment/$id'),
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

  Future<List<MedicalAppointment>>
      fetchMedicalAppointmentByAppointmentsStateList(String? psychologistId,
          String? clienteId, AppointmentStatus status) async {
    List<MedicalAppointment> medicalAppointmentList = [];
    var statusName = status.name;
    try {
      final res = await http.get(
        Uri.parse(
            '$uri/medical-appointment/$clienteId/$psychologistId/$statusName'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> body = jsonDecode(res.body);
      medicalAppointmentList = body
          .map((dynamic item) => MedicalAppointment.fromJson(item))
          .toList();
    } catch (e) {
      print(e);
    }

    return medicalAppointmentList;
  }
}