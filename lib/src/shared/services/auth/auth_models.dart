import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';

class SignUpData {
  final String email;
  final String password;
  final String cpf;
  final String name;
  final String phone;
  final DateTime? birthDate;
  final String certificationNumber;
  final UserType userType;

  SignUpData({
    required this.email,
    required this.password,
    required this.cpf,
    required this.name,
    required this.phone,
    this.birthDate,
    required this.certificationNumber,
    required this.userType,
  });
}

class SignInData {
  final String email;
  final String password;

  SignInData({
    required this.email,
    required this.password,
  });
}
