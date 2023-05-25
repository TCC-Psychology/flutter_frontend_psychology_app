import 'package:json_annotation/json_annotation.dart';
import 'psychologist_model.dart';

part 'academic_formation_model.g.dart';

@JsonSerializable()
class AcademicFormation {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String institution;
  final String course;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Psychologist psychologist;

  AcademicFormation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.institution,
    required this.course,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.psychologist,
  });

  factory AcademicFormation.fromJson(Map<String, dynamic> json) =>
      _$AcademicFormationFromJson(json);

  Map<String, dynamic> toJson() => _$AcademicFormationToJson(this);
}
