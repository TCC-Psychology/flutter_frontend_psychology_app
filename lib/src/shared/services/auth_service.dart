import 'package:flutter_frontend_psychology_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<void> signUp() async {
    final AuthResponse res = await supabase.auth
        .signUp(password: "password", email: "lucas.lopesx1@gmail.com");
  }
}
