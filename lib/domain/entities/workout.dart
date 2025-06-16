class Workout {
  final int? id;
  final String name;
  final DateTime createdOn;

  const Workout({this.id, required this.name, required this.createdOn});

  bool get isRecent => DateTime.now().difference(createdOn).inDays < 14;
}
