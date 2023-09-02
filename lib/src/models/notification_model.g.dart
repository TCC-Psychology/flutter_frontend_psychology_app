// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['id'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String,
      viewed: json['viewed'] as bool? ?? false,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      clientId: json['clientId'] as int?,
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
      psychologistId: json['psychologistId'] as int?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['description'] = instance.description;
  val['viewed'] = instance.viewed;
  return val;
}
