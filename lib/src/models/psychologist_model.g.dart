// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychologist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Psychologist _$PsychologistFromJson(Map<String, dynamic> json) => Psychologist(
      id: json['id'] as int?,
      certificationNumber: json['certificationNumber'] as String?,
      userId: json['userId'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PsychologistToJson(Psychologist instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['certificationNumber'] = instance.certificationNumber;
  return val;
}
