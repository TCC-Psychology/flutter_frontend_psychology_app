import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';
import 'psychologist_model.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class Notification {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String description;
  final bool viewed;
  final Client? client;
  final Psychologist? psychologist;

  Notification({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.viewed,
    this.client,
    this.psychologist,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
