// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) =>
    MedicalRecord(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String,
      theme: json['theme'] as String,
      mood: json['mood'] as String,
      objective: json['objective'] as String,
      evolutionRecord: json['evolutionRecord'] as String,
      client: 
          Client.fromJson(json['client'] as Map<String, dynamic>),
      psychologist:
          Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicalRecordToJson(MedicalRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notes': instance.notes,
      'theme': instance.theme,
      'mood': instance.mood,
      'objective': instance.objective,
      'evolutionRecord': instance.evolutionRecord,
      'client': instance.client,
      'psychologist': instance.psychologist,
    };

Map<String, dynamic> _$MedicalRecordCreatToJson(MedicalRecord instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'theme': instance.theme,
      'mood': instance.mood,
      'objective': instance.objective,
      'evolutionRecord': instance.evolutionRecord,
      'client': instance.client,
      'psychologist': instance.psychologist,
    };
