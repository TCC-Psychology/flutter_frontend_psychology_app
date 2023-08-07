import 'package:json_annotation/json_annotation.dart';
import 'psychologist_model.dart';

part 'segment_of_activity_model.g.dart';

@JsonSerializable()
class SegmentOfActivity {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String segment;

  @JsonKey(includeToJson: false)
  final List<Psychologist>? psychologists;

  SegmentOfActivity({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.segment,
    this.psychologists,
  });

  factory SegmentOfActivity.fromJson(Map<String, dynamic> json) =>
      _$SegmentOfActivityFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentOfActivityToJson(this);
}
