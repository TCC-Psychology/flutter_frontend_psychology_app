// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_formation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcademicFormation _$AcademicFormationFromJson(Map<String, dynamic> json) =>
    AcademicFormation(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      institution: json['institution'] as String,
      course: json['course'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
      psychologistId: json['psychologistId'] as int?,
    );

Map<String, dynamic> _$AcademicFormationToJson(AcademicFormation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['institution'] = instance.institution;
  val['course'] = instance.course;
  val['description'] = instance.description;
  val['startDate'] = instance.startDate.toIso8601String();
  val['endDate'] = instance.endDate.toIso8601String();
  return val;
}
