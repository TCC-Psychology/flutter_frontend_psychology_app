import 'dart:convert';

import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/segment_of_activity_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/target_audience_model.dart';
import 'package:http/http.dart' as http;

enum EntityType {
  SegmentOfActivity,
  TargetAudience,
}

class TagService {
  Future<List<TargetAudience>> fetchTargetAudiences() async {
    List<TargetAudience> targetAudiencesList = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/target-audiences'),
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
      );

      List<dynamic> body = jsonDecode(res.body);

      targetAudiencesList =
          body.map((dynamic item) => TargetAudience.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }

    return targetAudiencesList;
  }

  Future<List<SegmentOfActivity>> fetchSegmentOfActivity() async {
    List<SegmentOfActivity> segmentOfActivityList = [];

    try {
      final res = await http.get(
        Uri.parse('$uri/segment-of-activity'),
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
      );

      List<dynamic> body = jsonDecode(res.body);

      segmentOfActivityList =
          body.map((dynamic item) => SegmentOfActivity.fromJson(item)).toList();
    } catch (e) {
      print(e);
    }

    return segmentOfActivityList;
  }

  Future<void> connectTag(
    EntityType type,
    String userId,
    int? entityId,
  ) async {
    if (entityId == null) {
      return;
    }

    late String endpoint;
    late String entity;
    switch (type) {
      case EntityType.SegmentOfActivity:
        endpoint = 'segment-of-activity';
        entity = 'segmentOfActivityId';
        break;
      case EntityType.TargetAudience:
        endpoint = 'target-audiences';
        entity = 'targetAudienceId';
        break;
    }

    try {
      final res = await http.post(
        Uri.parse('$uri/$endpoint/connectPsychologist').replace(
          queryParameters: {
            'userId': userId,
            entity: entityId.toString(),
          },
        ),
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> disconnectTag(
    EntityType type,
    String userId,
    int? entityId,
  ) async {
    if (entityId == null) {
      return;
    }

    late String endpoint;
    late String entity;
    switch (type) {
      case EntityType.SegmentOfActivity:
        endpoint = 'segment-of-activity';
        entity = 'segmentOfActivityId';
        break;
      case EntityType.TargetAudience:
        endpoint = 'target-audiences';
        entity = 'targetAudienceId';
        break;
    }

    try {
      final res = await http.post(
        Uri.parse('$uri/$endpoint/disconnectPsychologist').replace(
          queryParameters: {
            'userId': userId,
            entity: entityId.toString(),
          },
        ),
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<TargetAudience>> fetchCurrentPsychologistTargetAudiences(
    String userId,
  ) async {
    final res = await http.get(
      Uri.parse('$uri/psychologist/$userId/targetAudiences'),
    );
    final List data = jsonDecode(res.body);
    return data.map((item) => TargetAudience.fromJson(item)).toList();
  }

  Future<List<SegmentOfActivity>> fetchCurrentPsychologistSegments(
    String userId,
  ) async {
    final res = await http.get(
      Uri.parse('$uri/psychologist/$userId/segmentOfActivities'),
    );
    final List data = jsonDecode(res.body);
    return data.map((item) => SegmentOfActivity.fromJson(item)).toList();
  }
}
