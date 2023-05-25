// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_of_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentOfActivity _$SegmentOfActivityFromJson(Map<String, dynamic> json) =>
    SegmentOfActivity(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      segment: json['segment'] as String,
      psychologists: (json['psychologists'] as List<dynamic>)
          .map((e) => Psychologist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SegmentOfActivityToJson(SegmentOfActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'segment': instance.segment,
      'psychologists': instance.psychologists,
    };
