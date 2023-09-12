import 'dart:convert';

import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<bool> storeToken(String token) async {
    try {
      await _storage.write(key: 'token', value: token);
      return true;
    } catch (e) {
      print('Error storing token: $e');
      return false;
    }
  }

  Future<bool> storeCurrentUser(UserProfile? user) async {
    try {
      if (user == null) {
        return false;
      }
      Map<String, dynamic> userMap = user!.toJson();
      String userJson = json.encode(userMap);
      await _storage.write(key: 'currentUser', value: userJson);
      return true;
    } catch (e) {
      print('Error storing user profile: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      print('Error fetching token: $e');
      return null;
    }
  }

  Future<UserProfile?> getCurrentUser() async {
    try {
      String? storedUserJson = await _storage.read(key: 'currentUser');

      if (storedUserJson == null) {
        return null; // No user data found
      }

      Map<String, dynamic> userMap = json.decode(storedUserJson);
      return UserProfile.fromJson(userMap);
    } catch (e) {
      print('Error retrieving user profile: $e');
      return null; // Error encountered or no user found
    }
  }

  Future<bool> deleteToken() async {
    try {
      await _storage.delete(key: 'token');
      return true; // Successfully deleted
    } catch (e) {
      print('Error deleting token: $e');
      return false; // Error encountered
    }
  }
}
