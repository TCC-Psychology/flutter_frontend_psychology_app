// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment_of_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentOfActivity _$SegmentOfActivityFromJson(Map<String, dynamic> json) =>
    SegmentOfActivity(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      psychologists: (json['psychologists'] as List<dynamic>?)
          ?.map((e) => Psychologist.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SegmentOfActivityToJson(SegmentOfActivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  return val;
}
