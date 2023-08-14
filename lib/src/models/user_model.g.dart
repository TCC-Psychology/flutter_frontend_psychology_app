// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      imageUrl: json['imageUrl'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      cep: json['cep'] as String?,
      phone: json['phone'] as String,
      description: json['description'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      gender: json['gender'] as String?,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      clientId: json['clientId'] as int?,
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
      psychologistId: json['psychologistId'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['cpf'] = instance.cpf;
  val['birthDate'] = instance.birthDate?.toIso8601String();
  val['imageUrl'] = instance.imageUrl;
  val['city'] = instance.city;
  val['state'] = instance.state;
  val['cep'] = instance.cep;
  val['phone'] = instance.phone;
  val['description'] = instance.description;
  val['email'] = instance.email;
  val['password'] = instance.password;
  val['gender'] = instance.gender;
  return val;
}
