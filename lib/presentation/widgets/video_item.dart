import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/models/video_model.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/blocs/video_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  VideoModel video;

  bool showLoader;
  VideoItem({required this.video, required this.showLoader});
  _VideoItem createState() => _VideoItem();
}

class _VideoItem extends State<VideoItem> {
  bool pageChange = false;
  void initState() {
    super.initState();

  
  }
  didChangeDependencies(){
    super.didChangeDependencies();
      initializeVideo();
  }

  initializeVideo() async {
    try {
      pageChange = false;
      if (!widget.video.controller.value.isInitialized) {
        await widget.video.controller.initialize().then((d){
  BlocProvider.of<VideoBloc>(context).add(InitializeVideoEvent( widget.video.id));
        });
   
      }
      if (!pageChange) {
        widget.video.controller.play();
        setState(() {});
      }
    } catch (err) {
      print(err);
    }
  }

  void dispose() {
    pageChange = true;
    super.dispose();
    if (widget.video.controller.value.isInitialized) {
      widget.video.controller.pause();

      widget.video.controller.seekTo(Duration.zero);
    } 
  }

  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        if (widget.video.controller.value.isPlaying) {
          widget.video.controller.pause();
          setState(() {});
        } else {
          widget.video.controller.play();
          setState(() {
            
          });
        }
      },
      child: SizedBox(
        child: Stack(
          children: [
            Stack(
              children: [
                widget.video.controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: widget.video.controller.value.aspectRatio,
                        child: VideoPlayer(widget.video.controller))
                    : Image.network(
                        widget.video.thumbnailUrl,
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 200,
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      children: [
                        Text(
                          widget.video.title.substring(
                              0,
                              widget.video.title.length > 200
                                  ? 200
                                  : widget.video.title.length),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                if (!widget.video.controller.value.isPlaying &&
                    widget.video.controller.value.isInitialized)
                  Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.6,
                        child: Container(
                          width: 150,
                          height: 150,
                         
                         decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(100))),
                          child: Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      )),
                if (widget.showLoader)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: VideoProgressIndicator(widget.video.controller,
                    allowScrubbing: true)),
          ],
        ),
      ),
    );
  }
}
