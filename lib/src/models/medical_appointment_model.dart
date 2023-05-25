import 'package:json_annotation/json_annotation.dart';

import 'client_model.dart';
import 'psychologist_model.dart';
import 'triage_model.dart';

part 'medical_appointment_model.g.dart';

@JsonSerializable()
class MedicalAppointment {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final String status;
  final String appointmentType;
  final Triage? triage;
  final Client client;
  final Psychologist psychologist;

  MedicalAppointment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.status,
    required this.appointmentType,
    this.triage,
    required this.client,
    required this.psychologist,
  });

  factory MedicalAppointment.fromJson(Map<String, dynamic> json) =>
      _$MedicalAppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalAppointmentToJson(this);
}
