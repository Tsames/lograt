class Workout {
  final int? id;
  final String name;
  final DateTime createdOn;

  const Workout({this.id, required this.name, required this.createdOn});

  Map<String, Object?> toMap() {
    return {if (id != null) 'id': id, 'name': name, 'createdOn': createdOn.millisecondsSinceEpoch};
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(id: map['id'], name: map['name'], createdOn: map['createdOn']);
  }

  @override
  String toString() {
    return 'Workout {id: ${id ?? "No Id"},name: $name, createdOn: ${createdOn.toIso8601String()}';
  }
}
