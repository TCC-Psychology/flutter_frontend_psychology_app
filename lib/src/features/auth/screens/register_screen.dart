import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/common/widgets/bottom-bar.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/psychologist_search_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/auth_models.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/auth_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/style/input_decoration.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/input_formatter_util.dart.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';
import 'package:flutter_frontend_psychology_app/src/shared/validators/auth_validator.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();
  MaskTextInputFormatter phoneMask =
      InputFormatterUtil.phoneMaskInputFormatter();
  MaskTextInputFormatter cpfMask = InputFormatterUtil.cpfMaskInputFormatter();

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController certificationNumberController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  DateTime? selectedDate;

  String? registerErrorMessage;

  final AuthService authService = AuthService();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  UserType userType = UserType.CLIENT;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                autovalidateMode: _autoValidateMode,
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Registro",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    DropdownButtonFormField(
                      value: userType,
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Tipo de usuário",
                      ),
                      items: [
                        DropdownMenuItem(
                          value: UserType.CLIENT,
                          child: Text(UserType.CLIENT.name),
                        ),
                        DropdownMenuItem(
                          value: UserType.PSYCHOLOGIST,
                          child: Text(UserType.PSYCHOLOGIST.name),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          userType = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Name *",
                        prefixIcon: Icons.person,
                      ),
                      validator: (value) =>
                          AuthValidator.validateGeneric(value, "name"),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Email *",
                        prefixIcon: Icons.email,
                      ),
                      validator: (value) => AuthValidator.validateEmail(value),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Senha *",
                        prefixIcon: Icons.password,
                      ),
                      validator: (value) =>
                          AuthValidator.validatePassword(value),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [phoneMask],
                      controller: phoneNumberController,
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Telefone *",
                        prefixIcon: Icons.phone,
                      ),
                      validator: (value) => AuthValidator.validatePhone(value),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: cpfController,
                      inputFormatters: [cpfMask],
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "CPF *",
                        prefixIcon: Icons.numbers,
                      ),
                      validator: (value) => AuthValidator.validateCpf(value),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: birthDateController,
                      decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Data de nascimento",
                        prefixIcon: Icons.date_range,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            DateFormat format = new DateFormat("dd/MM/yyyy");
                            birthDateController.text =
                                format.format(pickedDate);
                          });
                        }
                      },
                      // validator: (value) => AuthValidator.validateGeneric(value, "data de nascimento"),
                    ),
                    if (this.userType == UserType.PSYCHOLOGIST) ...[
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: certificationNumberController,
                        decoration: ProjectInputDecorations.textFieldDecoration(
                          labelText: "Certificado *",
                          prefixIcon: Icons.numbers,
                        ),
                        validator: (value) => AuthValidator.validateGeneric(
                          value,
                          "certificado",
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: handleRegister,
                      child: const Text("Registrar"),
                    ),
                    if (registerErrorMessage != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          registerErrorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleRegister() async {
    if (!_key.currentState!.validate()) {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }
    String email = emailController.text.trim();
    String password = passwordController.text;
    String name = nameController.text.trim();
    String cpf = InputFormatterUtil.getUnmaskedCpfText(
      cpfController.text.trim(),
    );
    String phone = InputFormatterUtil.getUnmaskedPhoneText(
      phoneNumberController.text.trim(),
    );
    String certificationNumber = certificationNumberController.text;
    DateTime? birthDate = selectedDate?.toUtc();

    SignUpData signUpData = SignUpData(
      email: email,
      password: password,
      cpf: cpf,
      name: name,
      phone: phone,
      certificationNumber: certificationNumber,
      birthDate: birthDate,
      userType: userType,
    );

    try {
      EasyLoading.show(status: 'Carregando...');
      String? error = await authService.signUp(signUpData, true);

      setState(() {
        registerErrorMessage = error;
      });

      if (error == null) {
        navigateToInitialPageWithBottomBar();
      }
    } catch (e) {
      // Handle potential errors
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  void navigateToInitialPageWithBottomBar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomBar()),
    );
  }
}
