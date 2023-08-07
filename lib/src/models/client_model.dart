import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_model.g.dart';

@JsonSerializable()
class Client {
  @JsonKey(includeIfNull: false)
  final int? id;

  final String? religion;
  final RelationshipStatus? relationshipStatus;
  final String? fatherName;
  final String? fatherOccupation;
  final String? motherName;
  final String? motherOccupation;

  @JsonKey(includeToJson: false)
  final User? user;

  @JsonKey(includeToJson: false)
  final int? userId;

  Client({
    this.id,
    this.religion,
    this.relationshipStatus,
    this.fatherName,
    this.fatherOccupation,
    this.motherName,
    this.motherOccupation,
    this.userId,
    this.user,
  });

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);
}

enum RelationshipStatus {
  @JsonValue('single')
  single,

  @JsonValue('married')
  married,

  @JsonValue('divorced')
  divorced,

  @JsonValue('widowed')
  widowed,

  @JsonValue('separated')
  separated,

  @JsonValue('domesticPartnership')
  domesticPartnership,
}
