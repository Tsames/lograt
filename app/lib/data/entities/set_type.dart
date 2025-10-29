enum SetType {
  warmup('Warm-up'),
  working('Working Set'), // Main work sets at target weight
  dropSet('Drop Set'), // Reduce weight mid-set
  failure('To Failure'); // Performed until failure

  const SetType(this.name);
  final String name;

  static SetType fromString(String value) {
    return SetType.values.firstWhere(
      (setType) => setType.name == value,
      orElse: () => SetType.working,
    );
  }
}
