import 'package:just_audio/just_audio.dart';
import 'package:myapp/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  final player = AudioPlayer();
  bool isPlaying = false;
  int songIndex = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<SongModel> songList = [];

  double sliderValue = 0.0;

  @override
  SongModel? build() {
    //getDurateAndPostion();
    return null;
  }
}

  /*void playSong(SongModel songModel) async {
    //player = AudioPlayer();
   await player.stop();
    songIndex = songList.indexOf(songModel);
    final source = AudioSource.uri(Uri.parse(songModel.song));
    await player.setAudioSource(source);
    player.play();
    
    isPlaying = true;
    state = songModel;

    ///player.positionStream
  }

  getDurateAndPostion() {
    player.durationStream.listen((d) {
      if (d != null) {
        duration = d;
      }
    });

    player.positionStream.listen((p) {
      position = p;

      sliderValue = (position.inMilliseconds > 0 && duration.inMilliseconds > 0)
          ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
          : 0.0;
    });

    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // state = state?.copyWith(isPlaying: false);
        next();
      }
    });
  }

  void next() async {
    if (songIndex < songList.length - 1) {
     var index=  songIndex++;
     
      state = songList[index];
       playSong(songList[index]);
    }
  }

  void previous() async {
    if (songIndex > 0) {
     // songIndex--;
      playSong(songList[songIndex--]);
      state = songList[songIndex];
    }
  }

  void seekTo(Duration position) {
    player.seek(position);
    state = songList[songIndex];
  }

  void playAnPause() {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play();
       isPlaying = true;
    }
   // isPlaying = !isPlaying;
    state?.copyWith(hex_color: state!.hex_color);
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
*/