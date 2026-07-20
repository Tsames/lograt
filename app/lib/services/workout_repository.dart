import 'package:lograt/database/app_database.dart';

class WorkoutRepository {
  final AppDatabase _appDatabase;

  const WorkoutRepository(AppDatabase appDatabase) : _appDatabase = appDatabase;
}
