import 'package:json_annotation/json_annotation.dart';
import 'psychologist_model.dart';

part 'target_audience_model.g.dart';

@JsonSerializable()
class TargetAudience {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String title;

  @JsonKey(includeToJson: false)
  final List<Psychologist>? psychologists;

  TargetAudience({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.title,
    this.psychologists,
  });

  factory TargetAudience.fromJson(Map<String, dynamic> json) =>
      _$TargetAudienceFromJson(json);

  Map<String, dynamic> toJson() => _$TargetAudienceToJson(this);
}
