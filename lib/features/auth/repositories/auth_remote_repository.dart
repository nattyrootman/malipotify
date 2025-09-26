import 'dart:convert';
import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/faillure/faill_message.dart';
import 'package:myapp/features/auth/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<FailMessage, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/signup',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      print(response.body);
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(FailMessage(resBody['detail']));
      }

      return Right(UserModel.fromMap(resBody));
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/login',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print(response.body);

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(FailMessage(resBody["detail"]));
      }

      return Right(
        UserModel.fromMap(resBody['user']).copyWith(token: resBody['token']),
      );
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, UserModel>> getcurrentUser2() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(
          'https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/user',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(FailMessage(resBody["detail"]));
      }

      return Right(UserModel.fromMap(resBody['user']).copyWith(token: token));
    } catch (e) {
      print('get current user error: $e');
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, UserModel>> getcurrentUser(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    // final authLocal = await ref.watch(authLocalRepositoryProvider);
    //final token = await authLocal.getToken();
    //authLocal.getToken();
    // authLocal.getUser();
    if (token == null) {
      return Left(FailMessage("Not authenticated"));
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/user',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.body.isEmpty) {
        return Left(FailMessage("Empty response from server"));
      }

      final decoded = jsonDecode(response.body);

      if (decoded == null || decoded is! Map<String, dynamic>) {
        return Left(FailMessage("Invalid response format: ${response.body}"));
      }

      if (response.statusCode != 200) {
        return Left(FailMessage(decoded["detail"] ?? "Unknown error"));
      }

      if (decoded["user"] == null) {
        return Left(FailMessage("User not found in response"));
      }

      final user = UserModel.fromMap(decoded["user"]).copyWith(token: token);

      // ref.read(userNotifierProvider.notifier).addUser(user);

      return Right(user);
    } catch (e) {
      print("get current user error: $e");
      return Left(FailMessage(e.toString()));
    }
  }
}
