import 'package:json_annotation/json_annotation.dart';
import 'psychologist_model.dart';

part 'target_audience_model.g.dart';

@JsonSerializable()
class TargetAudience {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String tag;
  final List<Psychologist> psychologists;

  TargetAudience({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.tag,
    required this.psychologists,
  });

  factory TargetAudience.fromJson(Map<String, dynamic> json) =>
      _$TargetAudienceFromJson(json);

  Map<String, dynamic> toJson() => _$TargetAudienceToJson(this);
}
