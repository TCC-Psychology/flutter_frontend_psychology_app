import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'psychologist_model.g.dart';

@JsonSerializable()
class Psychologist {
  @JsonKey(includeIfNull: false)
  final int? id;

  final String? certificationNumber;

  @JsonKey(includeToJson: false)
  final String? userId;

  @JsonKey(includeToJson: false)
  final UserProfile? user;

  Psychologist({
    this.id,
    this.certificationNumber,
    this.userId,
    this.user,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) =>
      _$PsychologistFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologistToJson(this);
}
