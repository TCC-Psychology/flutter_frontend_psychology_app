import 'package:json_annotation/json_annotation.dart';

import 'client_model.dart';
import 'psychologist_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String cpf;
  final DateTime birthDate;
  final String imageUrl;
  final String city;
  final String state;
  final String cep;
  final String phone;
  final String description;
  final String email;
  final String password;
  final String gender;
  final Client? client;
  final Psychologist? psychologist;

  User({
    required this.id,
    required this.name,
    required this.cpf,
    required this.birthDate,
    required this.imageUrl,
    required this.city,
    required this.state,
    required this.cep,
    required this.phone,
    required this.description,
    required this.email,
    required this.password,
    required this.gender,
    this.client,
    this.psychologist,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserCreate {
  final String name;
  final String cpf;
  final DateTime? birthDate;
  final String? imageUrl;
  final String? city;
  final String? state;
  final String? cep;
  final String phone;
  final String? description;
  final String? email;
  final String password;
  final String? gender;

  UserCreate({
    required this.name,
    required this.cpf,
    this.birthDate,
    this.imageUrl,
    this.city,
    this.state,
    this.cep,
    required this.phone,
    this.description,
    this.email,
    required this.password,
    this.gender,
  });

  Map<String, dynamic> toJson() => _$UserCreateToJson(this);
}
