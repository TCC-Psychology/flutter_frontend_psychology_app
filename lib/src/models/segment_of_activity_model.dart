import 'package:json_annotation/json_annotation.dart';
import 'psychologist_model.dart';

part 'segment_of_activity_model.g.dart';

@JsonSerializable()
class SegmentOfActivity {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String segment;
  final List<Psychologist> psychologists;

  SegmentOfActivity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.segment,
    required this.psychologists,
  });

  factory SegmentOfActivity.fromJson(Map<String, dynamic> json) =>
      _$SegmentOfActivityFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentOfActivityToJson(this);
}
