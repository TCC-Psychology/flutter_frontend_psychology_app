import 'package:email_validator/email_validator.dart';

class AuthValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um email';
    }
    final bool isValid = EmailValidator.validate(value);
    if (!isValid) {
      return 'Email inválido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a senha';
    }

    if (value.length < 8) {
      return 'Mínimo de 8 caracteres';
    }

    return null;
  }

  static String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o CPF';
    }

    if (value.length != 11) {
      return 'CPF inválido';
    }

    return null;
  }

  static String? validateGeneric(String? value, String type) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um ${type}';
    }
    return null;
  }
}
