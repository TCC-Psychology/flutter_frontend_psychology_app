import 'package:flutter_frontend_psychology_app/src/models/segment_of_activity_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/target_audience_model.dart';
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

  @JsonKey(includeToJson: false)
  final List<TargetAudience>? targetAudiences;

  @JsonKey(includeToJson: false)
  final List<SegmentOfActivity>? segmentOfActivities;

  Psychologist({
    this.id,
    this.certificationNumber,
    this.userId,
    this.user,
    this.targetAudiences,
    this.segmentOfActivities,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) =>
      _$PsychologistFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologistToJson(this);
}
