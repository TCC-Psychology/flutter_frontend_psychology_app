import 'package:json_annotation/json_annotation.dart';

enum UserType {
  @JsonValue('CLIENT')
  CLIENT,

  @JsonValue('PSYCHOLOGIST')
  PSYCHOLOGIST,
}

extension UserTypeExtension on UserType {
  String get name {
    switch (this) {
      case UserType.CLIENT:
        return "Cliente";
      case UserType.PSYCHOLOGIST:
        return "Psicólogo";
      default:
        return toString().split('.').last;
    }
  }
}
