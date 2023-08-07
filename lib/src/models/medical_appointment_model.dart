import 'package:json_annotation/json_annotation.dart';

import 'client_model.dart';
import 'psychologist_model.dart';
import 'triage_model.dart';

part 'medical_appointment_model.g.dart';

@JsonSerializable()
class MedicalAppointment {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final DateTime date;
  final AppointmentStatus status;
  final AppointmentType appointmentType;
  final Triage? triage;

  @JsonKey(includeToJson: false)
  final Client? client;

  @JsonKey(includeToJson: false)
  final int? clientId;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  MedicalAppointment({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.date,
    required this.status,
    required this.appointmentType,
    this.triage,
    this.client,
    this.clientId,
    this.psychologist,
    this.psychologistId,
  });

  factory MedicalAppointment.fromJson(Map<String, dynamic> json) =>
      _$MedicalAppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalAppointmentToJson(this);
}

enum AppointmentType {
  @JsonValue('Online')
  online,
  @JsonValue('Presencial')
  presencial
}

enum AppointmentStatus {
  @JsonValue('Pendente')
  pending,

  @JsonValue('Confirmado')
  confirmed,

  @JsonValue('Reagendado')
  rescheduled,

  @JsonValue('Cancelado')
  canceled
}
