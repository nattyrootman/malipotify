
class SongModel {
  final String id;
  final String songName;
  final String uploadedBy;
  final String artist;
  final String song;
  final String thumbnail;
  final String hex_color;

  SongModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.song,
    required this.thumbnail,
    required this.uploadedBy,
    required this.hex_color,
  });

  SongModel copyWith({
    String?id,
    String? songName,
    String? uploadedBy,
    String? artist,
    String? song,
    String? thumbnail,
    String? hex_color,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      artist: artist ?? this.artist,
      song: song ?? this.song,
      thumbnail: thumbnail ?? this.thumbnail,
      hex_color: hex_color ?? this.hex_color,
    );
  }

  @override
  String toString() {
    return "SongModel(songName: $songName, uploadedBy: $uploadedBy, artist: $artist, hexCode: $hex_color)";
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "song_name": songName, // correspond au backend
      "artist": artist,
      "uploaded_by": uploadedBy,
      "song": song,
      "thumbnail": thumbnail,
      "hex_color": hex_color,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map["_id"] ?? map["_id"],
      songName: map["song_name"] ?? "", // ✅ snake_case
      artist: map["artist"] ?? "",
      uploadedBy: map["uploaded_by"] ?? "",
      song: map["song"] ?? "",
      thumbnail: map["thumbnail"] ?? "",
      hex_color: map["hex_color"] ?? "",
    );
  }
  int get hasCode {
    return uploadedBy.hashCode ^
        songName.hashCode ^
        artist.hashCode ^
        thumbnail.hashCode ^
        song.hashCode ^
        hex_color.hashCode;
  }
}
