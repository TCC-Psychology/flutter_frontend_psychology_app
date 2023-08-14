import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/features/auth/screens/register_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                  validator: (value) => AuthValidator.validatePassword(value),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text;

                    if (_key.currentState!.validate()) {
                      String? error = await authService.signIn(email, password);
                      setState(() {
                        loginErrorMessage = error;
                      });
                    }
                  },
                  child: Text('Login'),
                ),
                if (loginErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      loginErrorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
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
}
