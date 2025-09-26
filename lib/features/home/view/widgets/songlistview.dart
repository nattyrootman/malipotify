import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/home/viewmodel/home_view_model.dart';

class Songlistview extends ConsumerWidget {
  const Songlistview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var songProvider = ref.watch(getAllSongsProvider);

    return songProvider.when(
      data: (data) {
        return SliverList(
          delegate: SliverChildListDelegate([
         ListView.builder(
            itemBuilder: (context, int index) {
              return ListTile(
                title: Text(data[index].songName),
                subtitle: Text(data[index].artist),
              );
            },
          ),






          
        ]));
      },
      error: (error, st) {
        return Text(error.toString());
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
