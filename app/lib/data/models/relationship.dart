import 'package:lograt/data/models/model.dart';

abstract interface class Relationship<L extends Model, R extends Model> {
  String get id;

  String get leftId;

  String get rightId;

  Map<String, dynamic> toMap();
}
