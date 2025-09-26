import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/providers/user_notifier.dart';
import 'package:myapp/core/utilities/snackbar.dart';
import 'package:myapp/features/home/models/song_model.dart';
import 'package:myapp/features/home/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_view_model.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final user = ref.watch(userNotifierProvider);

  final res = await ref.watch(homeRepositoryProvider).getSongList();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> favSong(Ref ref) async {
  final token = ref.watch(userNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).FavoriteSong(token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<String> addFavorite(Ref ref, String songId) async {
  final token = ref.watch(userNotifierProvider.select((user) => user!.token));

  final res = await ref
      .watch(homeRepositoryProvider)
      .addFavorite(token, songId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  void uploadSong({
    required Uint8List selectedSong,
    required Uint8List selectedThumbnail,
    required String artist,
    required String songName,
    required Color selectedColor,
  }) async {
    state = AsyncValue.loading();

    final res = await _homeRepository.upload(
      selectedSong: selectedSong,
      selectedThumbnail: selectedThumbnail,
      artist: artist,
      songName: songName,
      hexColor: toRGB(selectedColor),
      token: ref.read(userNotifierProvider)!.token,
      uploaded_by: ref.read(userNotifierProvider)!.id,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }
}
