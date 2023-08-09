import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';
import 'psychologist_model.dart';

part 'review_model.g.dart';

@JsonSerializable()
class Review {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String? description;
  final int rating;

  @JsonKey(includeToJson: false)
  final Client? client;

  @JsonKey(includeToJson: false)
  final int? clientId;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  Review({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.description,
    required this.rating,
    this.client,
    this.clientId,
    this.psychologist,
    this.psychologistId,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
