// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as int,
      religion: json['religion'] as String,
      relationshipStatus:
          $enumDecode(_$RelationshipStatusEnumMap, json['relationshipStatus']),
      fatherName: json['fatherName'] as String,
      fatherOccupation: json['fatherOccupation'] as String,
      motherName: json['motherName'] as String,
      motherOccupation: json['motherOccupation'] as String,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'religion': instance.religion,
      'relationshipStatus':
          _$RelationshipStatusEnumMap[instance.relationshipStatus]!,
      'fatherName': instance.fatherName,
      'fatherOccupation': instance.fatherOccupation,
      'motherName': instance.motherName,
      'motherOccupation': instance.motherOccupation,
      'userId': instance.userId,
    };

const _$RelationshipStatusEnumMap = {
  RelationshipStatus.single: 'single',
  RelationshipStatus.married: 'married',
  RelationshipStatus.divorced: 'divorced',
  RelationshipStatus.widowed: 'widowed',
  RelationshipStatus.separated: 'separated',
  RelationshipStatus.domesticPartnership: 'domesticPartnership',
};
