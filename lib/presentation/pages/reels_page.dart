
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/video_bloc.dart';
import '../widgets/video_items.dart';

class ReelsPage extends StatefulWidget {
  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _loadMoreVideos(1);
  }
 

  void _loadMoreVideos(int page) {
    
    BlocProvider.of<VideoBloc>(context).add(FetchVideosEvent(page));
  
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoading) {
              return Center(child: CircularProgressIndicator(color: Colors.white,));
            } else if (state is VideoError) {
              return Center(child: Text(state.message));
            } else if (state is VideoLoaded) {
              return  VideoItems(videos: state.videos,page:state.page,total:state.total,fetchData:_loadMoreVideos,pageLoading: state.pageLoading);
            }
      
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
