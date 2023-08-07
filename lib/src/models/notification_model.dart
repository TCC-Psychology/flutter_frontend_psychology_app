import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';
import 'psychologist_model.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(includeIfNull: false)
  final int? id;

  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  final String description;
  final bool viewed;

  @JsonKey(includeToJson: false)
  final Client? client;

  @JsonKey(includeToJson: false)
  final int? clientId;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  Notification({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.description,
    required this.viewed,
    this.client,
    this.clientId,
    this.psychologist,
    this.psychologistId,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
