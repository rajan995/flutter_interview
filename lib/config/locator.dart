
import 'package:get_it/get_it.dart';
import '../data/repositories/video_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => VideoRepository('https://api.ulearna.com/bytes/all?'));
}
