import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/features/auth/screens/login_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/tag/screens/tag_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/secure_storage_service.dart';

import '../../user/screens/user_edit.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileEdit()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.tag_sharp),
            title: const Text('Tags'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TagScreen()),
              );
            },
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
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
