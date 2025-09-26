

import 'package:myapp/features/home/models/song_model.dart';

class PlayerStateModel {
  final SongModel? currentSong;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isShuffling;
  final RepeatMode repeatMode; // none, one, all
  final List<SongModel>? queue;
   int currentIndex;  

   PlayerStateModel({
    this.currentSong,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.isShuffling = false,
    this.repeatMode = RepeatMode.off,
     this.queue ,
    this. currentIndex=0
  });

  PlayerStateModel copyWith({
    SongModel? currentSong,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isShuffling,
    RepeatMode? repeatMode,
    List<SongModel>? queue,
    int, currentIndex 
  }) {
    return PlayerStateModel(
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffling: isShuffling ?? this.isShuffling,
      repeatMode: repeatMode ?? this.repeatMode,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

enum RepeatMode { off, one, all }
