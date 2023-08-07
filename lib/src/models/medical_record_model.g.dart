// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) =>
    MedicalRecord(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      theme: json['theme'] as String,
      mood: json['mood'] as String,
      objective: json['objective'] as String,
      evolutionRecord: json['evolutionRecord'] as String,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      clientId: json['clientId'] as int?,
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
      psychologistId: json['psychologistId'] as int?,
    );

Map<String, dynamic> _$MedicalRecordToJson(MedicalRecord instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['notes'] = instance.notes;
  val['theme'] = instance.theme;
  val['mood'] = instance.mood;
  val['objective'] = instance.objective;
  val['evolutionRecord'] = instance.evolutionRecord;
  return val;
}
