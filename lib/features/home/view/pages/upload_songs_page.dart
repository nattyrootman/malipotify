import 'dart:io';
import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/utilities/themes/app_colors.dart';
import 'package:myapp/core/loaders/loader.dart';
import 'package:myapp/core/utilities/snackbar.dart';
import 'package:myapp/core/widegets/text_fields.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:myapp/features/home/view/widgets/wave_forms.dart';
import 'package:myapp/features/home/viewmodel/home_view_model.dart';

class UploadSongsPage extends ConsumerStatefulWidget {
  const UploadSongsPage({super.key});

  @override
  ConsumerState<UploadSongsPage> createState() => _UploadSongsPageState();
}

class _UploadSongsPageState extends ConsumerState<UploadSongsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController anim;
  String textHint = "Song Name";
  TextEditingController songName = TextEditingController();
  TextEditingController artist = TextEditingController();
  TextEditingController genre = TextEditingController();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  List<double> samples = [];
  double progress = 0.0;
  double currentValue = 0.0;
  AudioPlayer player = AudioPlayer();
  Uint8List? selectedImage;
  File? selectedAudio;
  Uint8List? selectedSong;
  bool isPlaying = true;

  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void selectAudio() async {
    samples = List.generate(50, (i) => Random().nextDouble());

    try {
      final audio = await playAudio();

      if (audio != null) {
        setState(() {
          selectedSong = audio;
        });

        player.play(BytesSource(selectedSong!));
        getDurationAndPosition();
      } else {
        print("resul is null");
      }
    } catch (e) {
      print(" il y a une erreur ${e.toString()}");
    }
  }

  getDurationAndPosition() async {
    player.onPositionChanged.listen((pos) {
      setState(() {
        position = pos;

        player.getDuration().then((value) {
          if (value != null) {
            progress = position.inMilliseconds / value.inMilliseconds;
          }
        });
      });
    });

    player.onDurationChanged.listen((dur) {
      setState(() {
        duration = dur;
      });
    });

    player.onPlayerComplete.listen((_) {
      setState(() {
        position = duration;
        isPlaying = false;
      });
    });
  }

  void togglePlay() async {
    if (isPlaying) {
      await player.pause();
      isPlaying = false;
    } else {
      isPlaying = true;
      player.play(BytesSource(selectedSong!));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
    songName.dispose();
    artist.dispose();
    genre.dispose();
    player.dispose();
  }

  String formt(Duration d) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final minute = twoDigit(d.inMinutes.remainder(60));
    final second = twoDigit(d.inSeconds.remainder(60));

    return '$minute:$second';
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = AppColors.card;

    final isLoading = ref.watch(
      homeViewModelProvider.select((val) => val?.isLoading == true),
    );

  /*  ref.listen(homeViewModelProvider, (prev, next) {
      next?.when(
        data: (data) {
          ShowSnackBar(context, "Upload success");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (contect) => HomePage()),
            (route) => false,
          );
        },
        error: (error, st) {
          print(error.toString());
          ShowSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });*/
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Songs"),
        actions: [IconButton(onPressed: selectAudio, icon: Icon(Icons.upload))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: selectImage,

                  child: selectedImage != null
                      ? SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image.memory(
                            selectedImage!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : DottedBorder(
                          options: RectDottedBorderOptions(
                            gradient: AppColors.dottedBorder,
                            dashPattern: [10, 5],
                            strokeWidth: 2,
                            padding: EdgeInsets.all(16),
                          ),

                          //animation: anim,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder, size: 45),

                                //Icon(Icons.folder, size: 45)
                                SizedBox(height: 10),

                                Text("Select Song"),
                              ],
                            ),
                          ),
                        ),
                ),

                SizedBox(height: 25),

                selectedSong != null
                    ? AudioWavePlayer(
                        player: player,
                        audioPath: selectedSong!,
                        duration: duration,
                        position: position,
                        samples: samples,
                        progress: progress,
                        textFormat: formt(position),
                        isPlaying: isPlaying,
                        onPlay: () {
                          togglePlay();
                        },
                        onSeek: (value) {
                          player.seek(Duration(seconds: value.toInt()));
                          setState(() {
                            currentValue = value;
                          });
                        },
                      )
                    : TextFields(textHint: textHint, controller: songName),
                TextFields(textHint: "Artist", controller: artist),
                TextFields(textHint: "Genre ", controller: genre),
                SizedBox(height: 25),

                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        selectedImage != null &&
                        selectedSong != null) {
                      ref
                          .read(homeViewModelProvider.notifier)
                          .uploadSong(
                            selectedSong: selectedSong!,
                            selectedThumbnail: selectedImage!,
                            artist: artist.text,
                            songName: songName.text,
                            selectedColor: selectedColor,
                          );
                    } else {
                      ShowSnackBar(context, "Please select song and image");
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      gradient: AppColors.line1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isLoading ? Loader() : Text("Upload"),
                  ),
                ),

                ColorPicker(
                  pickersEnabled: {
                    //ColorPickerType.primary: true,
                    ColorPickerType.wheel: true,
                  },
                  color: selectedColor,

                  onColorChanged: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
