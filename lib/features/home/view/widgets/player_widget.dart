import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/player_state_notifier.dart';
import 'package:myapp/core/utilities/snackbar.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/features/home/view/widgets/fullScreenPlayer.dart';
import 'package:myapp/features/home/view/widgets/miniplayer.dart';

class PlayerWidget extends ConsumerWidget {
  final DraggableScrollableController draggableController;
  const PlayerWidget({super.key, required this.draggableController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongNotifier = ref.watch(playerStateNotifierProvider);
    final songNotifer = ref.read(playerStateNotifierProvider.notifier);
    final songModel = currentSongNotifier!.currentSong;

    if (currentSongNotifier.currentSong == null) {
      print("current Song is null");
      return SizedBox();
    }
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 1.0,
      //expand: true,
      //snapSizes: [0.1, 0.5, 1.0],
      builder: (context, scrollController) {
        return LayoutBuilder(
          builder: (context, constraint) {
            final isMini =
                constraint.maxHeight < MediaQuery.of(context).size.height * 0.3;

            return Container(
              width: double.infinity,

              decoration: BoxDecoration(gradient: AppColors.line2),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: isMini
                      ? InkWell(
                          onTap: () {
                            draggableController.animateTo(
                              1.0,
                              duration: Duration(seconds: 2),
                              curve: Curves.easeInCubic,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  toHexColor(songModel!.hex_color),
                                  const Color.fromARGB(255, 83, 6, 67),
                                ],
                              ),
                            ),
                            child: Miniplayer(context),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    draggableController.animateTo(
                                      0.12,
                                      duration: Duration(seconds: 2),
                                      curve: Curves.easeInCubic,
                                    );
                                  },
                                  icon: Icon(Icons.arrow_drop_down, size: 30),
                                ),
                                 Text(songModel!.songName),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),

                            Fullscreenplayer(),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
