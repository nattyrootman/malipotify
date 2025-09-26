import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences prefs;

  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  void saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userString = prefs.getString(_userKey);
    if (userString != null) {
      try {
        final userMap = jsonDecode(userString);
        return UserModel.fromMap(userMap);
      } catch (e) {
        print('Error parsing saved user: $e');
        return null;
      }
    }
    return null;
  }

  clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_userKey);
  }
}
