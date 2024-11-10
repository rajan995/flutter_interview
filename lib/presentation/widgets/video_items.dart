
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app/presentation/widgets/video_item.dart';
import '../../data/models/video_model.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatelessWidget {
  final List<VideoModel> videos;
  final int page;
  final int total;
  final bool pageLoading;
  Function(int page) fetchData;

  final PageController controller = PageController(initialPage: 0);
  VideoItems(
      {required this.videos,
      required this.pageLoading,
      required this.page,
 
      required this.total,
      required this.fetchData});

  @override
  Widget build(
    BuildContext context,
  ) {
    return RefreshIndicator(
      onRefresh: ()async{
        videos.forEach((element) {
          if(element.controller.value.isPlaying){
            element.controller.pause();
            element.controller.dispose();
          }

        },);
        
   fetchData(1);
      },
      child: PageView.builder(
        itemCount: videos.length,
        scrollDirection: Axis.vertical,
        controller: controller,
        onPageChanged: (index) {
          if (videos.length == index + 1) {
            if (page <= total && pageLoading == false) {
      
              fetchData(page + 1);
            }
          }
          
        },
        itemBuilder: (context, index) {
          
          return VideoItem(video: videos[index],showLoader: (index+1 == videos.length && pageLoading));
        },
      ),
    );
  }
}
