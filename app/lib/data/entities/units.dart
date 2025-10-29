enum Units {
  pounds('pounds'),
  kilograms('kilograms');

  final String name;

  const Units(this.name);

  String get abbreviation => switch (name) {
    'kilograms' => 'kg',
    _ => 'lbs',
  };

  static Units fromString(String value) {
    return Units.values.firstWhere(
      (unit) => unit.name == value,
      orElse: () => Units.pounds,
    );
  }
}
