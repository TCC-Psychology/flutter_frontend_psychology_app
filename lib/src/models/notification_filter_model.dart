import 'package:json_annotation/json_annotation.dart';

part 'notification_filter_model.g.dart';

@JsonSerializable()
class NotificationFilter {
  @JsonKey(includeIfNull: false)
  DateTime? createdAtBefore;

  @JsonKey(includeIfNull: false)
  DateTime? createdAtAfter;

  @JsonKey(includeIfNull: false)
  bool? viewed;

  @JsonKey(includeIfNull: false)
  int? clientId;

  @JsonKey(includeIfNull: false)
  int? psychologistId;

  NotificationFilter({
    this.createdAtBefore,
    this.createdAtAfter,
    this.viewed,
    this.clientId,
    this.psychologistId,
  });

  Map<String, dynamic> toJson() => _$NotificationFilterToJson(this);
}
