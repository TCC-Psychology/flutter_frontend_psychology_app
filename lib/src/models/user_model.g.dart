// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String?,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      phone: json['phone'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      imageUrl: json['imageUrl'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      cep: json['cep'] as String?,
      description: json['description'] as String?,
      gender: json['gender'] as String?,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      clientId: json['clientId'] as int?,
      psychologist: json['psychologist'] == null
          ? null
          : Psychologist.fromJson(json['psychologist'] as Map<String, dynamic>),
      psychologistId: json['psychologistId'] as int?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['cpf'] = instance.cpf;
  val['phone'] = instance.phone;
  val['birthDate'] = instance.birthDate?.toIso8601String();
  val['imageUrl'] = instance.imageUrl;
  val['city'] = instance.city;
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  val['state'] = instance.state;
  val['cep'] = instance.cep;
  val['description'] = instance.description;
  val['gender'] = instance.gender;
  val['userType'] = _$UserTypeEnumMap[instance.userType]!;
  return val;
}

const _$UserTypeEnumMap = {
  UserType.CLIENT: 'CLIENT',
  UserType.PSYCHOLOGIST: 'PSYCHOLOGIST',
};
