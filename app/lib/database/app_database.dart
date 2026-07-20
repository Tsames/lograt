import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:lograt/database/models/set_type.dart';
import 'package:lograt/database/models/units.dart';
import 'package:lograt/database/type_converters.dart';
import 'package:lograt/util/uuid.dart';
import 'package:path_provider/path_provider.dart';

part 'generated/app_database.g.dart';
part 'tables/exercise_instances_table.dart';
part 'tables/exercises_table.dart';
part 'tables/muscle_groups_table.dart';
part 'tables/muscle_groups_to_exercises_table.dart';
part 'tables/sets_table.dart';
part 'tables/workout_template_sets_table.dart';
part 'tables/workout_templates_table.dart';
part 'tables/workouts_table.dart';

@DriftDatabase(
  tables: [
    WorkoutsTable,
    WorkoutTemplatesTable,
    WorkoutTemplateSetsTable,
    ExercisesTable,
    ExerciseInstanceTable,
    SetsTable,
    MuscleGroupsTable,
    MuscleGroupsToExercisesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lograt_database',
      native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
    );
  }
}
