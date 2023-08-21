import 'package:flutter_frontend_psychology_app/src/models/academic_formation_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/target_audience_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'psychologist_model.g.dart';

@JsonSerializable()
class Psychologist {
  @JsonKey(includeIfNull: false)
  final int? id;

  final String? certificationNumber;
  final String? approach;
  final List<TargetAudience>? targetAudience;
  final List<AcademicFormation>? academicFormations;
  @JsonKey(includeToJson: false)
  final int? userId;

  @JsonKey(includeToJson: true)
  final User? user;

  Psychologist({
    this.id,
    this.certificationNumber,
    this.approach,
    this.userId,
    this.user,
    this.targetAudience,
    this.academicFormations,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) =>
      _$PsychologistFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologistToJson(this);
}
