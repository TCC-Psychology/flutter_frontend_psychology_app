import 'package:flutter/material.dart';

import '../../shared/services/user.service.dart';
import '../psychologist_search/screens/psychologist_search_screen.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserService userService = UserService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String phone = '';
  String password = '';
  String _message = '';

  void _onChange() {
    phone = _phoneController.text;
    password = _passwordController.text;

    setState(() {
      _message = '';
    });
  }

  Future<void> _login() async {
    phone = _phoneController.text;
    password = _passwordController.text;

    bool isValidCredentials = await userService.canLogin(phone, password);    

    setState(() {
      if (isValidCredentials) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PsychologistSearchScreen()),
        );
      } else {
        _message = 'Telefone ou senha inválidos.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text(
              'Nome aplicativo',
              style: TextStyle(
                fontSize: 24.0, 
              ),
            ),
            const SizedBox(height: 120),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
                onChanged: (_) => _onChange(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
                obscureText: true,
                onChanged: (_) => _onChange(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 20),
            Text(_message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}