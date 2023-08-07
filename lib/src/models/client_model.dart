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

@JsonSerializable()
class ClientCreate {
  final String? religion;
  final RelationshipStatus? relationshipStatus;
  final String? fatherName;
  final String? fatherOccupation;
  final String? motherName;
  final String? motherOccupation;

  ClientCreate({
    required this.religion,
    required this.relationshipStatus,
    required this.fatherName,
    required this.fatherOccupation,
    required this.motherName,
    required this.motherOccupation,
  });

  Map<String, dynamic> toJson() => _$ClientCreateToJson(this);
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

String relationshipStatusToString(RelationshipStatus status) {
  return status.toString().split('.').last;
}

RelationshipStatus getRelationshipStatusFromString(String status) {
  switch (status) {
    case 'single':
      return RelationshipStatus.single;
    case 'married':
      return RelationshipStatus.married;
    case 'divorced':
      return RelationshipStatus.divorced;
    case 'widowed':
      return RelationshipStatus.widowed;
    case 'separated':
      return RelationshipStatus.separated;
    case 'domesticPartnership':
      return RelationshipStatus.domesticPartnership;
    default:
      return RelationshipStatus.single;
  }
}