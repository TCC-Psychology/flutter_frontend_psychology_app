import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';
import 'psychologist_model.dart';

part 'medical_record_model.g.dart';

@JsonSerializable()
class MedicalRecord {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String notes;
  final String theme;
  final String mood;
  final String objective;
  final String evolutionRecord;
  final Client? client;
  final Psychologist psychologist;

  MedicalRecord({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.notes,
    required this.theme,
    required this.mood,
    required this.objective,
    required this.evolutionRecord,
    this.client,
    required this.psychologist,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordToJson(this);
}
