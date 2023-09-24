import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:http/http.dart' as http;

class PsychologistService {
  Future<List<Psychologist>> fetchPsychologistList(
    List<int>? segmentOfActivityIds,
    List<int>? targetAudienceIds,
  ) async {
    List<Psychologist> psychologistList = [];

    final Map<String, dynamic> body = {
      'targetAudienceIds': targetAudienceIds,
      'segmentOfActivityIds': segmentOfActivityIds,
    };

    try {
      final res = await http.post(
        Uri.parse('$uri/psychologist/findAllPsychologists'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'targetAudienceIds': targetAudienceIds,
          'segmentOfActivityIds': segmentOfActivityIds,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> body = jsonDecode(res.body);
        psychologistList =
            body.map((dynamic item) => Psychologist.fromJson(item)).toList();
      } else {
        print(
            'Failed to load psychologists. HTTP status code: ${res.statusCode}');
      }
    } catch (e) {
      print(e);
    }

    return psychologistList;
  }

  Future<Psychologist?> fetchPsychologistById(String id) async {
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
      return null;
    }
  }

  Future<Psychologist?> fetchPsychologistByUserId(String userId) async {
    try {
      final res = await http.get(
        Uri.parse('$uri/psychologist/findOneByUserId/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return Psychologist.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> editPsychologist(Psychologist psychologist, int id) async {
    try {
      final res = await http.patch(
        Uri.parse('$uri/psychologist/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(psychologist.toJson()),
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
}
