class Workout {
  final int id;
  final String name;
  final DateTime createdOn;

  const Workout({required this.id, required this.name, required this.createdOn});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'createdOn': createdOn.millisecondsSinceEpoch};
  }

  @override
  String toString() {
    return 'Workout {id: $id, name: $name, createdOn: ${createdOn.toIso8601String()}';
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(id: map['id'], name: map['name'], createdOn: map['createdOn']);
  }
}
