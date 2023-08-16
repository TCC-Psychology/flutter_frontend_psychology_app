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
}
