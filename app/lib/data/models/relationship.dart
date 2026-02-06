import 'package:lograt/data/models/model.dart';

abstract interface class Relationship<L extends Model, R extends Model> {
  String get id;

  String get leftId;

  String get rightId;

  String get nameOfTable;

  String get idField;

  String get leftModelIdField;

  String get rightModelIdField;

  Map<String, dynamic> toMap();
}
