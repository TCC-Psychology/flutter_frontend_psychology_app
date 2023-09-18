import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/features/auth/screens/login_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/tag/screens/tag_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/secure_storage_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';

import '../../user/screens/user_edit.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final SecureStorageService _storageService = SecureStorageService();
  UserType? _userType;

  void _fetchUserType() async {
    final currentUser = await _storageService.getCurrentUser();

    setState(() {
      _userType = currentUser?.userType;
    });
    print(currentUser);
  }

  @override
  void initState() {
    super.initState();
    _fetchUserType();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> userSpecificWidgets;

    if (_userType == UserType.PSYCHOLOGIST) {
      userSpecificWidgets = [
        ListTile(
          leading: const Icon(Icons.tag_sharp),
          title: const Text('Tags'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TagScreen()),
            );
          },
        ),
      ];
    } else if (_userType == UserType.CLIENT) {
      userSpecificWidgets = [];
    } else {
      userSpecificWidgets = [];
    }

    List<Widget> userCommonWidgets = [
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Perfil'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserProfileEdit()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ...userCommonWidgets,
          ...userSpecificWidgets,
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
