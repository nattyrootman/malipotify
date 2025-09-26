import 'dart:io';

var upload_url =
    "https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/upload";

var songUrl =
    "https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/favorite";

String url = Platform.isAndroid
    ? 'http://10.0.2.2:8000'
    : 'http://127.0.0.1:8000';

final String favorSong_ur =
    "https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/songlist";
final String addFavorite_url =
    "https://8000-firebase-malipotify-1747165252567.cluster-l6vkdperq5ebaqo3qy4ksvoqom.cloudworkstations.dev/auth/favarite";

final List<String> categories = [
  'All',
  'Manding',
  'Hip Hop',
  'Reggea',
  'Pop',
  'Rock',
  'Jazz',
  'Electronic',
  'Classical',
  'R&B',
];
