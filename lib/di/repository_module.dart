import '../data/database/dao/workout_dao.dart';
import '../data/repositories/workout_repository_impl.dart';
import 'service_locator.dart';

void setupRepositoryModule() {
  // Register WorkoutRepository as a factory
  serviceLocator.registerFactory<WorkoutRepository>(() => WorkoutRepository(serviceLocator<WorkoutDao>()));
}
