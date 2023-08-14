import 'package:flutter_frontend_psychology_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<String?> signUp(String email, String password) async {
    try {
      await supabase.auth.signUp(password: password, email: email);
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'Erro inesperado, verifique sua conexão com a internet';
    }
    return null;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(password: password, email: email);
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'Erro inesperado, verifique sua conexão com a internet';
    }
    return null;
  }
}
