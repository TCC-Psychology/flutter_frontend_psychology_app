import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';
import 'package:json_annotation/json_annotation.dart';

import 'client_model.dart';
import 'psychologist_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserProfile {
  @JsonKey(includeIfNull: false)
  final String? id;

  final String name;
  final String cpf;
  final String phone;

  final DateTime? birthDate;
  String? imageUrl;
  final String? city;
  final String? latitude;
  final String? longitude;
  final String? state;
  final String? cep;
  final String? description;
  final String? gender;
  final UserType userType;

  @JsonKey(includeToJson: false)
  final Client? client;

  @JsonKey(includeToJson: false)
  final int? clientId;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  UserProfile({
    this.id,
    required this.name,
    required this.cpf,
    required this.phone,
    this.birthDate,
    this.imageUrl,
    this.city,
    this.state,
    this.cep,
    this.description,
    this.gender,
    this.client,
    this.clientId,
    this.psychologist,
    this.psychologistId,
    this.latitude,
    this.longitude,
    required this.userType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
