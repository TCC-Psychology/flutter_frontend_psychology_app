// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_formation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcademicFormation _$AcademicFormationFromJson(Map<String, dynamic> json) =>
    AcademicFormation(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      institution: json['institution'] as String,
      course: json['course'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      psychologist:
          Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AcademicFormationToJson(AcademicFormation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'institution': instance.institution,
      'course': instance.course,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'psychologist': instance.psychologist,
    };
