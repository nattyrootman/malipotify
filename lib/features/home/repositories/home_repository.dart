import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/constants/constants.dart';
import 'package:myapp/core/faillure/faill_message.dart';

import 'package:dio/dio.dart';
import 'package:myapp/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ef) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<FailMessage, String>> upload({
    required Uint8List selectedSong,
    required Uint8List selectedThumbnail,
    required String artist,
    required String songName,
    required String hexColor,
    required String token,
    required String uploaded_by,
  }) async {
    try {
      final data = FormData.fromMap({
        "song": MultipartFile.fromBytes(selectedSong, filename: "audio.mp3"),
        "thumbnail": MultipartFile.fromBytes(
          selectedThumbnail,
          filename: "image.png",
        ),
        "artist": artist,
        "song_name": songName,
        "hex_color": hexColor,
        "uploaded_by": uploaded_by,
      });
      final response = await Dio().post(
        upload_url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 201) {
        return Left(FailMessage(response.data));
      }

      print("✅ Upload success: $response");
      return Right(await response.data);
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, List<SongModel>>> getSongList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    try {
      List<SongModel> songs = [];

      final response = await http.get(
        Uri.parse(
          "https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/songlist",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      var resBody = jsonDecode(response.body);
      print(resBody);

      if (response.statusCode != 200) {
        final failmsg = resBody as Map<String, dynamic>;
        return Left(FailMessage(failmsg["detail"]));
      }
      resBody = resBody as List;

      for (var map in resBody) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, List<SongModel>>> FavoriteSong(
    String token,
  ) async {
    try {
      final res = await http.get(
        Uri.parse(favorSong_ur),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final List<SongModel> songs = [];
      List<dynamic> data = jsonDecode(res.body);
      if (res.statusCode != 200) {
        final failmsg = data as Map<String, dynamic>;
        return Left(FailMessage(failmsg["detail"]));
      }

      for (var map in data) {
        songs.add(SongModel.fromMap(map));
      }
      return Right(songs);
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, String>> addFavorite(
    String songId,
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$addFavorite_url/$songId"),
        headers: {
          'Content-Type': 'appplication/json',
          'Authorization': 'Bearer $token',
        },
      );
      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        Left(FailMessage(data["detail"]));
      }
      return Right(data['favorite']);
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }

  Future<Either<FailMessage, String>> removeFavorite(
    String songId,
    String token,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$addFavorite_url/$songId"),
        headers: {
          'Content-Type': 'appplication/json',
          'Authorization': 'Bearer $token',
        },
      );
      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        Left(FailMessage(data["detail"]));
      }
      return Right(data['message']);
    } catch (e) {
      return Left(FailMessage(e.toString()));
    }
  }
}
