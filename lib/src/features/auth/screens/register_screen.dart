import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/style/input_decoration.dart';
import 'package:flutter_frontend_psychology_app/src/shared/validators/auth_validator.dart';

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
  final TextEditingController cpfController = TextEditingController();

  String? registerErrorMessage;

  final AuthService authService = AuthService();

  String userType = "client";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Form(
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
                    height: 70,
                  ),
                  DropdownButtonFormField(
                    value: userType,
                    decoration: ProjectInputDecorations.textFieldDecoration(
                      labelText: "Tipo de usuário",
                    ),
                    items: const [
                      DropdownMenuItem(child: Text("Cliente"), value: "client"),
                      DropdownMenuItem(
                        value: "psychologist",
                        child: Text("Psicólogo"),
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
                        labelText: "Name", prefixIcon: Icons.person),
                    validator: (value) =>
                        AuthValidator.validateGeneric(value, "name"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Email", prefixIcon: Icons.email),
                    validator: (value) => AuthValidator.validateEmail(value),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Senha", prefixIcon: Icons.password),
                    validator: (value) => AuthValidator.validatePassword(value),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "Telefone", prefixIcon: Icons.phone),
                    validator: (value) =>
                        AuthValidator.validateGeneric(value, "telefone"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: cpfController,
                    decoration: ProjectInputDecorations.textFieldDecoration(
                        labelText: "CPF", prefixIcon: Icons.numbers),
                    validator: (value) =>
                        AuthValidator.validateGeneric(value, "CPF"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String email = emailController.text.trim();
                      String password = passwordController.text;

                      if (_key.currentState!.validate()) {
                        String? error =
                            await authService.signUp(email, password);
                        setState(() {
                          registerErrorMessage = error;
                        });

                        print(error);
                      }
                    },
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
              )),
        ),
      ),
    );
  }
}
