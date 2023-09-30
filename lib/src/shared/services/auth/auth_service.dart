import 'dart:convert';

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
import 'package:http/http.dart' as http;

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

      if (response.user != null) {
        final currentUser = await userProfileService.fetchUserByUserId(
          response.user!.id,
        );
        await _storageService.storeCurrentUser(currentUser);
      }

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

  Future<String?> signUpOnBackend(String email, String password) async {
    try {
      final Uri endpoint = Uri.parse('$uri/auth/signUp');
      final http.Response res = await http.post(
        endpoint,
        headers: {
          'Content-Type': CONTENT_TYPE,
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 201) {
        throw Exception(
          'Failed to signUp with status: ${res.statusCode}',
        );
      }

      return res.body;
    } catch (error) {
      print(error);
      throw Exception(
        'Failed to signUp',
      );
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      var data = await supabase.auth.admin.getUserById(id);
      return data.user;
    } catch (_) {
      return null;
    }
  }

  Future<String?> signUp(SignUpData data, bool shouldStoreSessionToken,
      {bool? isRegistryByRecord}) async {
    if (await _userWithCpfExists(data.cpf)) {
      return 'Erro de registro. Verifique seus detalhes e tente novamente.';
    }

    final userId = await _registerWithSupabase(
      data.email,
      data.password,
      shouldStoreSessionToken,
    );

    if (userId == null) {
      return "Erro de registro!";
    }

    final dataInsertionResult = await _insertUserDataToDatabase(
      userId,
      data.email,
      data.cpf,
      data.name,
      data.phone,
      data.birthDate,
      data.userType,
    );

    final currentUser = await userProfileService.fetchUserByUserId(
      userId,
    );
    await _storageService.storeCurrentUser(currentUser);

    if (dataInsertionResult == null) {
      return "Erro na criação do usuario no banco de dados";
    }

    if (isRegistryByRecord != null) return dataInsertionResult.id!;

    return null;
  }

  Future<UserProfile?> _insertUserDataToDatabase(
    String userId,
    String email,
    String cpf,
    String name,
    String phone,
    DateTime? birthDate,
    UserType userType,
  ) async {
    final UserProfile userProfile = UserProfile(
      id: userId,
      cpf: cpf,
      name: name,
      phone: phone,
      userType: userType,
    );

    UserProfile? userCreateResponse;

    switch (userType) {
      case UserType.CLIENT:
        final my_models.Client client = my_models.Client();
        userCreateResponse =
            await userProfileService.createUserAndClient(userProfile, client);
        break;
      case UserType.PSYCHOLOGIST:
        final Psychologist psychologist = Psychologist();
        userCreateResponse = await userProfileService.createUserAndPsychologist(
            userProfile, psychologist);
        break;
    }

    if (userCreateResponse == null) {
      await supabase.auth.admin.deleteUser(userId);
      return null;
    }

    return userCreateResponse; // Successful data insertion
  }

  Future<String?> _registerWithSupabase(
      String email, String password, bool shouldStoreSessionToken) async {
    try {
      AuthResponse? response;
      String? userId;
      if (shouldStoreSessionToken) {
        response = await supabase.auth.signUp(
          password: password,
          email: email,
        );
      } else {
        userId = await signUpOnBackend(email, password);
      }

      if (response != null) {
        return response.user?.id;
      }
      if (userId != null) {
        return userId;
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  Future<bool> _userWithCpfExists(String cpf) async {
    var user = await userProfileService.fetchUserByProperties(cpf, null, null);
    return user != null;
  }
}
