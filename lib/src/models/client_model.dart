import 'package:json_annotation/json_annotation.dart';

part 'client_model.g.dart';

@JsonSerializable()
class Client {
  final int id;
  final String religion;
  final RelationshipStatus relationshipStatus;
  final String fatherName;
  final String fatherOccupation;
  final String motherName;
  final String motherOccupation;
  final int userId;

  Client({
    required this.id,
    required this.religion,
    required this.relationshipStatus,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherOccupation,
    required this.userId,
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
