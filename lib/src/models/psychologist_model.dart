import 'package:json_annotation/json_annotation.dart';

part 'psychologist_model.g.dart';

@JsonSerializable()
class Psychologist {
  final int id;
  final String certificationNumber;
  final int userId;

  Psychologist({
    required this.id,
    required this.certificationNumber,
    required this.userId,
  });

  factory Psychologist.fromJson(Map<String, dynamic> json) =>
      _$PsychologistFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologistToJson(this);
}
