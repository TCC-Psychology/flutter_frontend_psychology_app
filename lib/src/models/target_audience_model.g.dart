// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_audience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetAudience _$TargetAudienceFromJson(Map<String, dynamic> json) =>
    TargetAudience(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tag: json['tag'] as String,
      psychologists: (json['psychologists'] as List<dynamic>)
          .map((e) => Psychologist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TargetAudienceToJson(TargetAudience instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'tag': instance.tag,
      'psychologists': instance.psychologists,
    };
