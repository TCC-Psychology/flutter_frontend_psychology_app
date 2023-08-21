import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;

import '../../models/academic_formation_model.dart';

class AcademicFormationsService {
  Future<List<AcademicFormation>> fetchAcademicFormationsList() async {
    List<AcademicFormation> academicFormations = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/academic-formation'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> body = jsonDecode(res.body);

      academicFormations =
          body.map((dynamic item) => AcademicFormation.fromJson(item)).toList();

      print(res);
      print(academicFormations);
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
      AcademicFormation academicFormation) async {
    try {
      await http.post(
        Uri.parse('$uri/academic-formation'),
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
}
