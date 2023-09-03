import 'package:json_annotation/json_annotation.dart';

import 'medical_appointment_model.dart';

part 'triage_model.g.dart';

@JsonSerializable()
class Triage {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String chiefComplaint;
  final String triggeringFacts;
  final String currentSymptoms;

  @JsonKey(includeToJson: false)
  final MedicalAppointment? medicalAppointments;

  @JsonKey(includeToJson: false)
  final int? medicalAppointmentId;

  Triage({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.chiefComplaint,
    required this.triggeringFacts,
    required this.currentSymptoms,
    this.medicalAppointments,
    this.medicalAppointmentId,
  });

  factory Triage.fromJson(Map<String, dynamic> json) => _$TriageFromJson(json);

  Map<String, dynamic> toJson() => _$TriageToJson(this);
}
