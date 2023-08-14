import 'package:json_annotation/json_annotation.dart';

import 'client_model.dart';
import 'psychologist_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(includeIfNull: false)
  final String? id;

  final String name;
  final String cpf;

  final DateTime? birthDate;
  final String? imageUrl;
  final String? city;
  final String? state;
  final String? cep;
  final String phone;
  final String? description;
  final String email;
  final String password;
  final String? gender;

  @JsonKey(includeToJson: false)
  final Client? client;

  @JsonKey(includeToJson: false)
  final int? clientId;

  @JsonKey(includeToJson: false)
  final Psychologist? psychologist;

  @JsonKey(includeToJson: false)
  final int? psychologistId;

  User({
    this.id,
    required this.name,
    required this.cpf,
    this.birthDate,
    this.imageUrl,
    this.city,
    this.state,
    this.cep,
    required this.phone,
    this.description,
    required this.email,
    required this.password,
    this.gender,
    this.client,
    this.clientId,
    this.psychologist,
    this.psychologistId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
