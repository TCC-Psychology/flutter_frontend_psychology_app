// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationFilter _$NotificationFilterFromJson(Map<String, dynamic> json) =>
    NotificationFilter(
      createdAtBefore: json['createdAtBefore'] == null
          ? null
          : DateTime.parse(json['createdAtBefore'] as String),
      createdAtAfter: json['createdAtAfter'] == null
          ? null
          : DateTime.parse(json['createdAtAfter'] as String),
      viewed: json['viewed'] as bool?,
      clientId: json['clientId'] as int?,
      psychologistId: json['psychologistId'] as int?,
    );

Map<String, dynamic> _$NotificationFilterToJson(NotificationFilter instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAtBefore', instance.createdAtBefore?.toIso8601String());
  writeNotNull('createdAtAfter', instance.createdAtAfter?.toIso8601String());
  writeNotNull('viewed', instance.viewed);
  writeNotNull('clientId', instance.clientId);
  writeNotNull('psychologistId', instance.psychologistId);
  return val;
}
