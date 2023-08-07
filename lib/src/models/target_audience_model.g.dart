// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_audience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetAudience _$TargetAudienceFromJson(Map<String, dynamic> json) =>
    TargetAudience(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      tag: json['tag'] as String,
      psychologists: (json['psychologists'] as List<dynamic>)
          .map((e) => Psychologist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TargetAudienceToJson(TargetAudience instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['tag'] = instance.tag;
  return val;
}
