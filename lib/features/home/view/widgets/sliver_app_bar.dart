import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliverAppBar extends ConsumerWidget {
  const SliverAppBar({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SliverToBoxAdapter(child:Column(children: [

      Padding(   
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                  "Recently Played",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
        





    ],));
  }
}

