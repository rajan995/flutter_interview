import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../data/models/video_model.dart';
import '../../data/repositories/video_repository.dart';

abstract class VideoEvent {}

class FetchVideosEvent extends VideoEvent {
  final int page;
  FetchVideosEvent(this.page);

}
class InitializeVideoEvent extends VideoEvent {
  final String id;
  InitializeVideoEvent(this.id);

}

abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoModel> videos;
  final int total;
  final bool pageLoading;
  final int page;
  VideoLoaded(
      {this.pageLoading = false,
      required this.videos,
      required this.total,
      required this.page});
  VideoLoaded copyWith(
      {bool? pageLoading, List<VideoModel>? videos, int? total, int? page}) {
    return VideoLoaded(
        pageLoading: pageLoading ?? this.pageLoading,
        videos: videos ?? this.videos,
        total: total ?? this.total,
        page: page ?? this.page);
  }
}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository videoRepository;
  VideoLoaded? videoLoaded;
  VideoBloc(this.videoRepository) : super(VideoInitial()) {
    on<InitializeVideoEvent>((event, emit) {
            videoLoaded!.videos.forEach((action){
                 if(!action.controller.value.isInitialized){
                    action.controller.initialize().then((d){});
                 }
            });
    },);
    on<FetchVideosEvent>((event, emit) async {
      if (event.page == 1) {
        emit(VideoLoading());
        videoLoaded = null;
      } else {
        videoLoaded!.copyWith(pageLoading: true);
        emit(videoLoaded!);
      }

      try {
        final videos = await videoRepository.fetchVideos(event.page);

        if (videoLoaded == null) {
          videoLoaded = VideoLoaded(
              videos: videos['video'],
              total: videos['total'],
              page: videos['page']);
        } else {
          final newVideos = [
            ...videoLoaded!.videos,
            ...(videos['video'] as List<VideoModel>)
          ];
          videoLoaded = videoLoaded!.copyWith(
              videos: newVideos,
              total: videos['total'],
              page: videos['page'],
              pageLoading: false);
        }
 
        emit(videoLoaded!);
      } catch (e) {
        emit(VideoError(e.toString()));
      }
    });
  }
}
