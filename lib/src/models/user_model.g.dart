// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      imageUrl: json['imageUrl'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      cep: json['cep'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      gender: json['gender'] as String,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cpf': instance.cpf,
      'birthDate': instance.birthDate.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'city': instance.city,
      'state': instance.state,
      'cep': instance.cep,
      'phone': instance.phone,
      'description': instance.description,
      'email': instance.email,
      'password': instance.password,
      'gender': instance.gender,
      'client': instance.client,
      'psychologist': instance.psychologist,
    };
