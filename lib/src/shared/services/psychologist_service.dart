import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:http/http.dart' as http;

class PsychologistService {
  Future<List<Psychologist>> fetchPsychologistList() async {
    List<Psychologist> psychologistList = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/psychologist'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      List<dynamic> body = jsonDecode(res.body);

      psychologistList =
          body.map((dynamic item) => Psychologist.fromJson(item)).toList();

      print(res);
      print(psychologistList);
    } catch (e) {
      print(e);
    }

    return psychologistList;
  }

  Future<Psychologist> fetchPsychologistById(String id) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/psychologist/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
    return Psychologist.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
       Psychologist psychologist = Psychologist(
        id: 1,
        certificationNumber: '1', 
        userId: 1,
       );
      return psychologist;
    }
  }
}
