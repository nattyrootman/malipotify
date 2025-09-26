import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/player_state_notifier.dart';

@override
Widget Miniplayer(BuildContext context) {
  return Consumer(
    builder: (context, ref, child) {
      final currentSongNotifier = ref.watch(playerStateNotifierProvider);
      final playerState = ref.read(playerStateNotifierProvider.notifier);
      final songModel = currentSongNotifier!.currentSong;
      bool isPlaying = currentSongNotifier.isPlaying;
        
        

      if (currentSongNotifier.currentSong == null) {
        print("current Song is null");
        return SizedBox();
      }
      return   Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                       height: 45,
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                        
                       ),
                          
                        child: Image.network(songModel!.thumbnail,fit: BoxFit.cover)),
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songModel.songName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(songModel.artist, style: TextStyle(fontSize: 6)),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite, size: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        playerState.playAnPause();
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Positioned(
              bottom: 0,
              child: Container(height: 4, color: Colors.grey[800])),
              Positioned(
                bottom: 0,
                child: Container(
                  //duration: const Duration(milliseconds: 200),
                  height: 4,
                  width: playerState.sliderValue*MediaQuery.of(context).size.width,
                  color: Colors.green,
                ),
              ),

           
          ],
        
      );
    },
  );
}
