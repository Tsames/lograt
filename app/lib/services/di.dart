import 'package:get_it/get_it.dart';
import 'package:lograt/database/app_database.dart';
import 'package:lograt/services/workout_repository.dart';

final di = GetIt.instance;

void configureDependencies() {
  // Register your services
  di.registerSingleton<AppDatabase>(AppDatabase());
  di.registerSingleton<WorkoutRepository>(WorkoutRepository(di<AppDatabase>()));
}
