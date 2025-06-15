import '../data/database/app_database.dart';
import '../data/database/dao/workout_dao.dart';
import 'service_locator.dart';

Future<void> setupDatabaseModule() async {
  // Register AppDatabase as a singleton
  serviceLocator.registerSingleton<AppDatabase>(AppDatabase.create());

  // Initialize the database
  await serviceLocator<AppDatabase>().initialize();

  // Register WorkoutDao as a singleton
  serviceLocator.registerSingleton<WorkoutDao>(WorkoutDao(serviceLocator<AppDatabase>()));
}
