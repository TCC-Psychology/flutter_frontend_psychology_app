// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychologist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Psychologist _$PsychologistFromJson(Map<String, dynamic> json) => Psychologist(
      id: json['id'] as int,
      certificationNumber: json['certificationNumber'] as String,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$PsychologistToJson(Psychologist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'certificationNumber': instance.certificationNumber,
      'userId': instance.userId,
    };
