import 'package:drift/drift.dart';
import 'package:lograt/database/models/set_type.dart';
import 'package:lograt/database/models/units.dart';

class SetTypeConverter extends NullAwareTypeConverter<SetType, String> {
  const SetTypeConverter();

  @override
  SetType requireFromSql(String fromDb) => SetType.fromString(fromDb);

  @override
  String requireToSql(SetType value) => value.name;
}

class UnitsConverter extends NullAwareTypeConverter<Units, String> {
  const UnitsConverter();

  @override
  Units requireFromSql(String fromDb) => Units.fromString(fromDb);

  @override
  String requireToSql(Units value) => value.name;
}
