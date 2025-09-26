import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibrairePage extends ConsumerWidget {
  const LibrairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(child: Text("Libraire"));
  }
}
