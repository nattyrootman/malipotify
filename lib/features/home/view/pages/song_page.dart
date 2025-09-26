import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/player_state_notifier.dart';
import 'package:myapp/core/providers/user_notifier.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/core/loaders/loader.dart';
import 'package:myapp/core/widegets/custom_container.dart';
import 'package:myapp/core/widegets/songs_listview.dart';
import 'package:myapp/core/widegets/padding_widget.dart';
import 'package:myapp/features/home/view/widgets/category_list.dart';
import 'package:myapp/features/home/viewmodel/home_view_model.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var songProvider = ref.watch(getAllSongsProvider);
    final songPlayerNotifier = ref.read(playerStateNotifierProvider.notifier);

    final currentUser = ref.watch(userNotifierProvider);
    if (currentUser == null) {
      print("crrent user is null");
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("assets/potify.png", height: 75, width: 75),
              ),
              expandedHeight: 80,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                IconButton(onPressed: () {}, icon: Icon(Icons.person)),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: CategoryListWidgedt(),
              ),
              flexibleSpace: _FlexibleSpaceBarWidget(),
            ),

            songProvider.when(
              data: (data) {
                //songPlayerNotifier.songList = data;
                var filter = data
                    .where((song) => song.artist.contains("Bob Marley"))
                    .toList();
                return SliverList(
                  delegate: SliverChildListDelegate([
                    // CategoryListWidgedt(),
                    PaddingWidget(
                      text: "Recentes",
                      padding: EdgeInsetsGeometry.only(left: 8.0),
                    ),

                    SizedBox(height: 230, child: SongsListview(songList: data)),

                    // SizedBox(height: 10),
                    // CategoryListWidgedt(),
                    /// SizedBox(height: 10),
                    PaddingWidget(
                      text: "Top Chansons",
                      padding: EdgeInsetsGeometry.only(left: 8.0),
                    ),

                    SizedBox(
                      height: 230,
                      child: SongsListview(songList: filter),
                    ),
                  ]),
                );
              },
              error: (error, st) {
                return SliverToBoxAdapter(
                  child: Text("y a erreur ${error.toString()}}"),
                );
              },
              loading: () {
                return SliverToBoxAdapter(child: Center(child: Loader()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FlexibleSpaceBarWidget extends StatelessWidget {
  const _FlexibleSpaceBarWidget();

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: CustomContainer(
        boxDecoration: BoxDecoration(gradient: AppColors.line1),
      ),
    );
  }
}
