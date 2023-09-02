import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/features/auth/screens/login_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/secure_storage_service.dart';

class MenuScreen extends StatelessWidget {
  final SecureStorageService _storageService = SecureStorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Outros botoes...'),
            onTap: () {},
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8.0),
                  Text("Sign Out"),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
          )
        ],
      ),
    );
  }

  void _signOut(BuildContext context) {
    _storageService.deleteToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
