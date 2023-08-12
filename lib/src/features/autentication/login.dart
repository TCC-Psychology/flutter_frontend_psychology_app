import 'package:flutter/material.dart';

import '../../shared/services/user.service.dart';
import '../psychologist_search/screens/psychologist_search_screen.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserService userService = UserService();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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

    // Simulating an API call
    bool isValidCredentials = await userService.canLogin(phone, password);
    

    setState(() {
      if (isValidCredentials) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PsychologistSearchScreen()), // Replace with the actual route
        );
      } else {
        _message = 'Telefone ou senha invalidos';
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
                fontSize: 24.0, // Ajuste o tamanho do texto conforme necessário
                // Outras propriedades de estilo, como cor, fontWeight, etc.
              ),
            ),
            const SizedBox(height: 120),
            Container(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/logo.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
                onChanged: (_) => _onChange(),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            SizedBox(height: 20),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}