import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/main.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/client_model.dart'
    as my_models;
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/auth_models.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/secure_storage_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/user.service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  UserProfileService userProfileService = UserProfileService();
  final SecureStorageService _storageService = SecureStorageService();

  Future<bool> isAuthenticated() async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<String?> signIn(SignInData data) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(password: data.password, email: data.email);

      if (response.session != null) {
        await _storageService.storeToken(response.session!.accessToken);
      }
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'Erro inesperado, verifique sua conexão com a internet';
    }
    return null;
  }

  Future<User?> getUserById(String id) async {
    try {
      var data = await supabase.auth.admin.getUserById(id);
      return data.user;
    } catch (_) {
      return null;
    }
  }

  Future<String?> signUp(SignUpData data) async {
    if (await _userWithCpfExists(data.cpf)) {
      return 'Erro de registro. Verifique seus detalhes e tente novamente.';
    }

    final signUpResult = await _registerWithSupabase(
      data.email,
      data.password,
    );

    if (signUpResult != null) {
      return signUpResult;
    }

    final dataInsertionResult = await _insertUserDataToDatabase(
      data.email,
      data.cpf,
      data.name,
      data.phone,
      data.birthDate,
      data.userType,
    );

    if (dataInsertionResult != null) {
      return dataInsertionResult;
    }

    return null;
  }

  Future<String?> _insertUserDataToDatabase(
    String email,
    String cpf,
    String name,
    String phone,
    DateTime? birthDate,
    UserType userType,
  ) async {
    final user = await supabase.auth.currentUser;

    if (user == null) {
      return 'Erro de autenticação. Por favor, tente novamente.';
    }

    final UserProfile userProfile = UserProfile(
      id: user.id, cpf: cpf, name: name, phone: phone,
      // birthDate: birthDate,
    );

    UserProfile? userCreateResponse;
    if (userType == UserType.client) {
      final my_models.Client client = my_models.Client();

      userCreateResponse =
          await userProfileService.createUserAndClient(userProfile, client);
    }

    if (userType == UserType.psychologist) {
      final Psychologist psychologist = Psychologist();

      userCreateResponse = await userProfileService.createUserAndPsychologist(
          userProfile, psychologist);
    }

    if (userCreateResponse == null) {
      await supabase.auth.admin.deleteUser(user.id);
      return 'Erro ao completar registro. Por favor, tente novamente mais tarde.';
    }

    return null; // Successful data insertion
  }

  Future<String?> _registerWithSupabase(String email, String password) async {
    try {
      var x = await supabase.auth.signUp(
        password: password,
        email: email,
      );
      print(x);
      return null;
    } on AuthException catch (error) {
      return error.message;
    } catch (error) {
      return 'Erro inesperado, verifique sua conexão com a internet';
    }
  }

  Future<bool> _userWithCpfExists(String cpf) async {
    var user = await userProfileService.fetchUserByProperties(cpf, null, null);
    return user != null;
  }
}
