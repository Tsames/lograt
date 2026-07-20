import 'package:lograt/database/app_database.dart';
import 'package:lograt/util/uuid.dart';

class MockMuscleGroups {
  static final chest = MuscleGroupRow(id: uuid.v7(), label: 'Chest', description: 'Pectoral muscles');
  static final back = MuscleGroupRow(id: uuid.v7(), label: 'Back', description: 'Latissimus dorsi, traps, rhomboids');
  static final shoulders = MuscleGroupRow(id: uuid.v7(), label: 'Shoulders', description: 'Deltoids');
  static final arms = MuscleGroupRow(id: uuid.v7(), label: 'Arms', description: 'Biceps and triceps');
  static final legs = MuscleGroupRow(id: uuid.v7(), label: 'Legs', description: 'Quadriceps, hamstrings, glutes');
  static final core = MuscleGroupRow(id: uuid.v7(), label: 'Core', description: 'Abdominals and obliques');
}
