// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalAppointment _$MedicalAppointmentFromJson(Map<String, dynamic> json) =>
    MedicalAppointment(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      date: DateTime.parse(json['date'] as String),
      status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
      appointmentType:
          $enumDecode(_$AppointmentTypeEnumMap, json['appointmentType']),
      triage: json['triage'] == null
          ? null
          : Triage.fromJson(json['triage'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      clientId: json['clientId'] as int?,
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
      psychologistId: json['psychologistId'] as int?,
    );

Map<String, dynamic> _$MedicalAppointmentToJson(MedicalAppointment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['date'] = instance.date.toIso8601String();
  val['status'] = _$AppointmentStatusEnumMap[instance.status]!;
  val['appointmentType'] = _$AppointmentTypeEnumMap[instance.appointmentType]!;
  val['triage'] = instance.triage;
  return val;
}

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pending: 'Pendente',
  AppointmentStatus.confirmed: 'Confirmado',
  AppointmentStatus.rescheduled: 'Reagendado',
  AppointmentStatus.canceled: 'Cancelado',
};

const _$AppointmentTypeEnumMap = {
  AppointmentType.online: 'Online',
  AppointmentType.presencial: 'Presencial',
};
