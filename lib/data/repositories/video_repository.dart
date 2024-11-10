
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/video_model.dart';

class VideoRepository {
  final String baseUrl;

  VideoRepository(this.baseUrl);

  Future<Map<String,dynamic>> fetchVideos(int page) async {
    final response = await http.get(Uri.parse('$baseUrl&page=$page&limit=10&country=United+States'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']['data'];
           final Map<String,dynamic> metaData = json.decode(response.body)['data']['meta_data'];
      List<VideoModel> videoModel = data.map((json) => VideoModel.fromJson(json)).toList();
      print(data);
      return {"video":videoModel,"total":metaData['total'],'page':metaData['page']};
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
