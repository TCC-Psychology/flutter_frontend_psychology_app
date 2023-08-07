// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Triage _$TriageFromJson(Map<String, dynamic> json) => Triage(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      chiefComplaint: json['chiefComplaint'] as String,
      triggeringFacts: json['triggeringFacts'] as String,
      currentSymptoms: json['currentSymptoms'] as String,
      medicalAppointments: json['medicalAppointments'] == null
          ? null
          : MedicalAppointment.fromJson(
              json['medicalAppointments'] as Map<String, dynamic>),
      medicalAppointmentId: json['medicalAppointmentId'] as String?,
    );

Map<String, dynamic> _$TriageToJson(Triage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['chiefComplaint'] = instance.chiefComplaint;
  val['triggeringFacts'] = instance.triggeringFacts;
  val['currentSymptoms'] = instance.currentSymptoms;
  return val;
}
