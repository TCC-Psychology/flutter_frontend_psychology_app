import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputFormatterUtil {
  static MaskTextInputFormatter phoneMaskInputFormatter() {
    return MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  static String getUnmaskedPhoneText(String value) {
    return '+55${value!.replaceAll(RegExp(r'[^0-9]'), '')}';
  }

  static MaskTextInputFormatter cpfMaskInputFormatter() {
    return MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  static String getUnmaskedCpfText(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String formatCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

    if (cpf.length >= 11) {
      cpf = cpf.substring(0, 11);
      cpf =
          '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
    }

    return cpf;
  }

  static String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (phoneNumber.startsWith('55')) {
      phoneNumber = phoneNumber.substring(2);
    }

    if (phoneNumber.length >= 11) {
      phoneNumber = phoneNumber.substring(0, 11);
      phoneNumber =
          '(${phoneNumber.substring(0, 2)}) ${phoneNumber.substring(2, 7)}-${phoneNumber.substring(7)}';
    }

    return phoneNumber;
  }

  static MaskTextInputFormatter cepMaskInputFormatter() {
    return MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  static String formatCEP(String input) {
    final cleanedInput = input.replaceAll(RegExp(r'[^0-9]'), '');
    final formattedInput =
        '${cleanedInput.substring(0, 5)}-${cleanedInput.substring(5, 8)}';
    return formattedInput;
  }

  static String getUnmaskedCep(String formattedCEP) {
    final unformattedCEP = formattedCEP.replaceAll('-', '');

    return unformattedCEP;
  }
}
