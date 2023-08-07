import 'package:json_annotation/json_annotation.dart';
import 'psychologist_model.dart';

part 'academic_formation_model.g.dart';

@JsonSerializable()
class AcademicFormation {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String institution;
  final String course;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  AcademicFormation({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.institution,
    required this.course,
    this.description,
    required this.startDate,
    required this.endDate,
    this.psychologist,
    this.psychologistId,
  });

  factory AcademicFormation.fromJson(Map<String, dynamic> json) =>
      _$AcademicFormationFromJson(json);

  Map<String, dynamic> toJson() => _$AcademicFormationToJson(this);
}
