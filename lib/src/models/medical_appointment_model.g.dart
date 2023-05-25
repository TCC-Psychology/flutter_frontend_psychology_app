// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalAppointment _$MedicalAppointmentFromJson(Map<String, dynamic> json) =>
    MedicalAppointment(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      appointmentType: json['appointmentType'] as String,
      triage: json['triage'] == null
          ? null
          : Triage.fromJson(json['triage'] as Map<String, dynamic>),
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      psychologist:
          Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicalAppointmentToJson(MedicalAppointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'date': instance.date.toIso8601String(),
      'status': instance.status,
      'appointmentType': instance.appointmentType,
      'triage': instance.triage,
      'client': instance.client,
      'psychologist': instance.psychologist,
    };
