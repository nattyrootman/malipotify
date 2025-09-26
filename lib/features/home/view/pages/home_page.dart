import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/user_notifier.dart';
import 'package:myapp/features/home/view/pages/libraire.dart';
import 'package:myapp/features/home/view/pages/song_page.dart';
import 'package:myapp/features/home/view/pages/upload_songs_page.dart';
import 'package:myapp/features/home/view/widgets/player_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentIndex = 0;
  double _panelSize = 0.12; // Start at mini-player height
  final double _hideNavThreshold = 0.6;
  late DraggableScrollableController _draggableController;

  List pages = [
    SongPage(),
    UploadSongsPage(),
    LibrairePage(),

    //SongPage()
  ];

  final url =
      "https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/songlist";

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    _draggableController.addListener(_handleDraggable);
  }

  void _handleDraggable() {
    setState(() {
      _panelSize = _draggableController.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userNotifierProvider);
    return Scaffold(
      bottomNavigationBar:_panelSize< _hideNavThreshold? BottomNavigationBar(
        selectedItemColor: Colors.grey.shade200,
        iconSize: 18,
        // unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.upload_sharp), label: "Upload"),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            label: "Bibliotheque",
          ),
        ],
      ):null,

      body: Stack(
          children: [
            pages[currentIndex],
            Positioned.fill(
             
              child: PlayerWidget(
                  draggableController: _draggableController,
              ),
            )
          ],
        ),
      
    );
  }
}
