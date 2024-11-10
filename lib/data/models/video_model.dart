
import 'dart:convert';

import 'package:video_player/video_player.dart';

class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final bool isInitializeVideo;

final VideoPlayerController controller;
  VideoModel({required this.id, required this.title, required this.thumbnailUrl, required this.controller, this.isInitializeVideo = false});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'].toString(),
      title: json['title'],
      thumbnailUrl: json['thumb_cdn_url'],
  
        controller:      VideoPlayerController.networkUrl(Uri.parse(json['cdn_url']))..setLooping(true)
      
    );
  }
  VideoModel copyWith({bool? isInitializeVideo}){
    return VideoModel(id: id, title: title, thumbnailUrl: thumbnailUrl, controller: controller,isInitializeVideo: isInitializeVideo ?? this.isInitializeVideo);
  }
}
