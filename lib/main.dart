// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/locator.dart';
import 'data/repositories/video_repository.dart';
import 'presentation/blocs/video_bloc.dart';
import 'presentation/pages/reels_page.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      home: BlocProvider(
        create: (_) => VideoBloc(locator<VideoRepository>()),
        child: ReelsPage(),
      ),
    );
  }
}
