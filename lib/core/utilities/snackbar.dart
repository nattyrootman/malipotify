import 'dart:convert';
import 'dart:io';

///import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

String toRGB(Color color) {
  return color.toARGB32().toRadixString(16).substring(2).padLeft(6, '0');
}
Color toHexColor(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) {
    hex = "FF$hex"; // add alpha if not provided
  }
  return Color(int.parse(hex, radix: 16));
}

void ShowSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message.toString())));
}

Future<Uint8List?> pickImage() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      final Uint8List uint8list = result.files.first.bytes!;
      return uint8list;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<Uint8List?> playAudio() async {
  try {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return null;
    final file = result.files.first;
    if (kIsWeb) {
      return file.bytes;
    }

    if (file.bytes != null) {
      return file.bytes;
    } else if (file.path != null) {
      return await File(file.path!).readAsBytes();
    }

    return null;
  } catch (e) {
    print("y a une erreur${e.toString()}");

    return null;
  }
}

Future<void> playFromBytesAnFile(
  Uint8List bytes,
  String filename,
  AudioPlayer player,
  String path,
) async {
  if (kIsWeb) {
    // On Web -> create blob URL

    final url = playFromBytes(bytes, filename);
    await player.setUrl(url);
    await player.play();
  } else {
    // On Mobile -> save to file then play
    await player.setAudioSource(AudioSource.file(path));
    await player.play();
  }
}

Future<Uint8List?> pickAudio2() async {
  try {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      final path = result.files.single.bytes!;
      return path;
    } else {
      return null;
    }
  } catch (e) {
    print("erreur se pass${e.toString()}");
    return null;
  }
}

String playFromBytes(Uint8List bytes, String fileName) {
  final memeType = getMemeType(fileName);
  final base64 = base64Encode(bytes);

  return 'data:audio/mpeg;base64,$base64';
}

String getMemeType(String fileName) {
  if (fileName.endsWith(".mp3")) return "audio/mp3";
  if (fileName.endsWith(".wav")) return "audio/wav";
  if (fileName.endsWith(".flac")) return "audio/flac";
  if (fileName.endsWith('".ogg"')) return "audio/ogg";
  if (fileName.endsWith('".aac"')) return "audio/aac";
  return "audio/mpeg";
}
