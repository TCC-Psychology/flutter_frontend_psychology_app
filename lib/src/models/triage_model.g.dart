// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Triage _$TriageFromJson(Map<String, dynamic> json) => Triage(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      chiefComplaint: json['chiefComplaint'] as String,
      triggeringFacts: json['triggeringFacts'] as String,
      currentSymptoms: json['currentSymptoms'] as String,
      medicalAppointments: MedicalAppointment.fromJson(
          json['medicalAppointments'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TriageToJson(Triage instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'chiefComplaint': instance.chiefComplaint,
      'triggeringFacts': instance.triggeringFacts,
      'currentSymptoms': instance.currentSymptoms,
      'medicalAppointments': instance.medicalAppointments,
    };
