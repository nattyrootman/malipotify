import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/providers/user_notifier.dart';
import 'package:myapp/features/auth/view/pages/signup_screen.dart';
import 'package:myapp/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:myapp/features/home/view/pages/home_page.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );




  final container = ProviderContainer();

  try {
    await container.read(authViewModelProvider.notifier).initSharePref();
    await container.read(authViewModelProvider.notifier).getDatatUser();
  } catch (e) {
    print('Error during initialization: $e');
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: currentUser == null ? SignupScreen() : HomePage(),
    );
  }
}
//uvicorn main:app --host 0.0.0.0 --port 8000 --proxy-headers
