import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:myapp/features/home/models/player_state_model.dart';
import 'package:myapp/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_state_notifier.g.dart';

@riverpod
class PlayerStateNotifier extends _$PlayerStateNotifier {
  final player = AudioPlayer();
  double sliderValue = 0.0;
  List<SongModel> songList = [];
  int songIndex = 0;

  @override
  PlayerStateModel? build() {
    getDurateAndPostion();
    return PlayerStateModel();
  }

  getDurateAndPostion() {
    player.durationStream.listen((d) {
      if (d != null) {
        state = state!.copyWith(duration: d);
      }
    });

    player.positionStream.listen((p) {
      state = state!.copyWith(position: p);

      sliderValue =
          (state!.position.inMilliseconds > 0 &&
              state!.duration.inMilliseconds > 0)
          ? (state!.position.inMilliseconds / state!.duration.inMilliseconds)
                .clamp(0.0, 1.0)
          : 0.0;
    });

    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // state = state?.copyWith(isPlaying: false);
        next();
      }
    });
  }

  void playSong(SongModel songModel) async {
    //await player.stop();
    try {
      final source = AudioSource.uri(
        Uri.parse(songModel.song),
        tag: MediaItem(
          id: songModel.id,
          title: songModel.songName,
          artist: songModel.artist,
          album: "Iconnnu",
          artUri: Uri.parse(songModel.thumbnail),
        ),
      );
      await player.setAudioSource(source);
      player.play();
      state = state?.copyWith(
        currentSong: songModel,
        isPlaying: true,
        position: Duration.zero,
      );
    } catch (e) {
      print(e);
    }
  }

  void next() async {
    if (songIndex < songList.length - 1) {
      songIndex++;
    } else {
      songIndex = 0;
    }

    playSong(songList[songIndex]);
    state?.copyWith(currentIndex: songIndex, currentSong: state?.currentSong);
  }

  void previous() async {
    if (songIndex > 0) {
      songIndex--;
      // playSong(songList[songIndex]);
    }
    playSong(songList[songIndex]);
    state?.copyWith(currentIndex: songIndex, currentSong: state?.currentSong);
  }

  void playAnPause() async {
    if (state!.isPlaying) {
      player.pause();
    } else {
      player.play();
    }
    state = state?.copyWith(isPlaying: !state!.isPlaying);
  }

  void seekTo(Duration position) {
    player.seek(position);
    state = state?.copyWith(position: position);
  }

  void setVolume(double volume) {
    player.setVolume(volume);
  }

  String format(Duration pos) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String twoDigitMinutes = twoDigits(pos.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(pos.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    player.dispose();
  }
}
