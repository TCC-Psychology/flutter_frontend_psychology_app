import 'package:json_annotation/json_annotation.dart';

import 'medical_appointment_model.dart';

part 'triage_model.g.dart';

@JsonSerializable()
class Triage {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String chiefComplaint;
  final String triggeringFacts;
  final String currentSymptoms;
  final MedicalAppointment medicalAppointments;

  Triage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.chiefComplaint,
    required this.triggeringFacts,
    required this.currentSymptoms,
    required this.medicalAppointments,
  });

  factory Triage.fromJson(Map<String, dynamic> json) => _$TriageFromJson(json);

  Map<String, dynamic> toJson() => _$TriageToJson(this);
}
