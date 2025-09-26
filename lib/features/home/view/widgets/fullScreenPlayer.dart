import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/player_state_notifier.dart';
import 'package:myapp/core/utilities/snackbar.dart';
import 'package:myapp/core/widegets/custom_container.dart';
import 'package:myapp/features/home/viewmodel/home_view_model.dart';

class Fullscreenplayer extends StatelessWidget {
  const Fullscreenplayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final fav = ref.watch(getAllSongsProvider);
        // final playerState=ref.read(playerStateNotifierProvider.notifier);
        final currentSongNotifier = ref.watch(playerStateNotifierProvider);
        final songNotifer = ref.read(playerStateNotifierProvider.notifier);
        final songModel = currentSongNotifier!.currentSong;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            ///
            children: [
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    hight: 250,

                    boxDecoration: BoxDecoration(
                      // gradient: AppColors.line2,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          toHexColor(songModel!.hex_color),
                          const Color.fromARGB(0, 182, 46, 187),
                        ],
                        stops: const [0.0, 0.3],
                      ),

                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: songModel.thumbnail.isEmpty
                            ? AssetImage("assets/potify.png")
                            : NetworkImage(songModel.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    songModel.songName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(songModel.artist),
                  IconButton(onPressed: () {
                  
                  }, icon: Icon(Icons.favorite)),

                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 20),

              ///
              ///)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.shuffle)),
                  IconButton(
                    onPressed: () {
                      print("previous");
                      songNotifer.previous();
                    },
                    icon: Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: () {
                      songNotifer.playAnPause();
                    },
                    icon: Icon(
                      currentSongNotifier.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      songNotifer.next();
                    },
                    icon: Icon(Icons.skip_next),
                  ),

                  IconButton(onPressed: () {}, icon: Icon(Icons.repeat)),
                ],
              ),

              SizedBox(height: 20),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 5),
                ),
                child: Slider(
                  //padding: EdgeInsets.only(left: 20, right: 20),
                  value: currentSongNotifier.position.inSeconds
                      .toDouble()
                      .clamp(
                        0.0,
                        currentSongNotifier.duration.inSeconds.toDouble(),
                      ),
                  min: 0.0,
                  max: currentSongNotifier.duration.inSeconds.toDouble(),
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,

                  onChanged: (value) {
                    songNotifer.seekTo(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(songNotifer.format(currentSongNotifier.position)),
                  Text(songNotifer.format(currentSongNotifier.duration)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
