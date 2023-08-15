// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as int?,
      religion: json['religion'] as String?,
      relationshipStatus: $enumDecodeNullable(
          _$RelationshipStatusEnumMap, json['relationshipStatus']),
      fatherName: json['fatherName'] as String?,
      fatherOccupation: json['fatherOccupation'] as String?,
      motherName: json['motherName'] as String?,
      motherOccupation: json['motherOccupation'] as String?,
      userId: json['userId'] as String?,
      user: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientToJson(Client instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['religion'] = instance.religion;
  val['relationshipStatus'] =
      _$RelationshipStatusEnumMap[instance.relationshipStatus];
  val['fatherName'] = instance.fatherName;
  val['fatherOccupation'] = instance.fatherOccupation;
  val['motherName'] = instance.motherName;
  val['motherOccupation'] = instance.motherOccupation;
  return val;
}

const _$RelationshipStatusEnumMap = {
  RelationshipStatus.single: 'single',
  RelationshipStatus.married: 'married',
  RelationshipStatus.divorced: 'divorced',
  RelationshipStatus.widowed: 'widowed',
  RelationshipStatus.separated: 'separated',
  RelationshipStatus.domesticPartnership: 'domesticPartnership',
};
