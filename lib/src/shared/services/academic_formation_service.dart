import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../models/academic_formation_model.dart';

class AcademicFormationService {
  Future<List<AcademicFormation>> fetchAcademicFormationsList(
      String psychologistId) async {
    List<AcademicFormation> academicFormations = [];

    try {
      final res = await http.get(
        Uri.parse(
            '$uri/academic-formation/getAcademic-formation/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> body = jsonDecode(res.body);

      academicFormations =
          body.map((dynamic item) => AcademicFormation.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }
    return academicFormations;
  }

  Future<AcademicFormation?> fetchAcademicFormationById(String id) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/academic-formation/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return AcademicFormation.fromJson(jsonDecode(res.body));
    } catch (e) {
      return null;
    }
  }

  Future<int> createAcademicFormation(
    String psychologistId,
    AcademicFormation academicFormation,
  ) async {
    try {
      await http.post(
        Uri.parse('$uri/academic-formation/$psychologistId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(academicFormation.toJson()),
      );

      return 1;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<String> updateAcademicFormationById(
      String id, AcademicFormation update) async {
    try {
      final res = await http.patch(
        Uri.parse('$uri/academic-formation/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(update.toJson()),
      );
      return res.body;
    } catch (e) {
      return 'error';
    }
  }

  Future<int> deleteAcademicFormation(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$uri/academic-formation/$id'),
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
}
