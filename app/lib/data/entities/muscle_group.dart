import 'package:collection/collection.dart';

enum MuscleGroup {
  chest('Chest'),
  shoulders('Shoulders'),
  back('Back'),
  arms('Arms'),
  core('Core'),
  legs('Legs');

  final String name;

  const MuscleGroup(this.name);

  static MuscleGroup? fromString(String value) {
    return MuscleGroup.values.firstWhereOrNull(
      (muscleGroup) => muscleGroup.name == value,
    );
  }
}
