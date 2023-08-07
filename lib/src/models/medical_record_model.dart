import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';
import 'psychologist_model.dart';

part 'medical_record_model.g.dart';

@JsonSerializable()
class MedicalRecord {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String? notes;
  final String theme;
  final String mood;
  final String objective;
  final String evolutionRecord;
  @JsonKey(includeToJson: false)
  final Client? client;

  @JsonKey(includeToJson: false)
  final int? clientId;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  MedicalRecord({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.notes,
    required this.theme,
    required this.mood,
    required this.objective,
    required this.evolutionRecord,
    this.client,
    this.clientId,
    this.psychologist,
    this.psychologistId,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordToJson(this);
}
