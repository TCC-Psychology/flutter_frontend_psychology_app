import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<bool> storeToken(String token) async {
    try {
      await _storage.write(key: 'token', value: token);
      return true; // Successful storage
    } catch (e) {
      print('Error storing token: $e');
      return false; // Error encountered
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      print('Error fetching token: $e');
      return null; // Error encountered or no token available
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
