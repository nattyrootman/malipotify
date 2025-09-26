import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/player_state_notifier.dart';
import 'package:myapp/core/widegets/custom_container.dart';
import 'package:myapp/features/home/models/song_model.dart';

class SongsListview extends ConsumerWidget {
  final List<SongModel> songList;
  final Axis scrollDirection;
  final double width, height;
  final double radius;

  //final Widget Function(BuildContext, int) itemBr;
  //final VoidCallback? onTap;

  const SongsListview({
    super.key,
    required this.songList,
    // required this.itemBr,
    this.scrollDirection = Axis.horizontal,
    this.width = 150,
    this.height = 150,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongNotifier = ref.read(playerStateNotifierProvider.notifier);
    final songNotfier = ref.watch(playerStateNotifierProvider);

    return ListView.builder(
      itemCount: songList.length,
      scrollDirection: scrollDirection,
      itemBuilder: (context, int index) {
        final song = songList[index];

        return GestureDetector(
          onTap: () async {
            await currentSongNotifier.player.stop();
            currentSongNotifier.songIndex = index;
            currentSongNotifier.songList = songList;

            //

            currentSongNotifier.playSong(song);
            print("play music");
          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  width: width,
                  hight: height,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    image: DecorationImage(
                      image: NetworkImage(song.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 5),
                Text(
                  song.songName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  song.artist,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
