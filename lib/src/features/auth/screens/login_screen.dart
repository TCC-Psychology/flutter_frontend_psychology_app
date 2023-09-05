import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/auth/screens/register_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/common/widgets/bottom-bar.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/auth_models.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/auth_service.dart';

import '../../../shared/validators/auth_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? loginErrorMessage;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    isAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 70),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => AuthValidator.validateEmail(value),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) => AuthValidator.validatePassword(value),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text('Login'),
                ),
                if (loginErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      loginErrorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  ),
                  child: Text("Registre-se"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleLogin() async {
    if (!_key.currentState!.validate()) return;

    String email = emailController.text.trim();
    String password = passwordController.text;

    SignInData data = SignInData(
      email: email,
      password: password,
    );

    String? error;
    try {
      error = await authService.signIn(data);
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
      return;
    } finally {
      EasyLoading.dismiss();
    }

    setState(() {
      loginErrorMessage = error;
    });

    if (error == null) {
      navigateToInitialPageWithBottomBar();
    }
  }

  isAuthenticated() async {
    final alreadyAuthenticated = await authService.isAuthenticated();
    if (alreadyAuthenticated) {
      navigateToInitialPageWithBottomBar();
    }
  }

  void navigateToInitialPageWithBottomBar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomBar()),
    );
  }
}
