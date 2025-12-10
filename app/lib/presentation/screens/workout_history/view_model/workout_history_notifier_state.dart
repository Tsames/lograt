class WorkoutHistoryNotifierState {
  final List<dynamic> workoutsWithMarkers;
  final bool hasWorkoutsThisWeekMarker;
  final bool hasWorkoutsInLastMonthMarker;
  final bool hasWorkoutsInLastThreeMonthsMarker;
  final DateTime? beginningOfIterationWeek;

  final bool isLoading;
  final String? error;

  final int offset;
  final bool hasMore;

  const WorkoutHistoryNotifierState({
    this.workoutsWithMarkers = const [],
    this.hasWorkoutsThisWeekMarker = false,
    this.hasWorkoutsInLastMonthMarker = false,
    this.hasWorkoutsInLastThreeMonthsMarker = false,
    this.beginningOfIterationWeek,
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  WorkoutHistoryNotifierState copyWith({
    List<dynamic>? workoutsWithMarkers,
    bool? hasWorkoutsThisWeekMarker,
    bool? hasWorkoutsInLastMonthMarker,
    bool? hasWorkoutsInLastThreeMonthsMarker,
    DateTime? beginningOfIterationWeek,
    bool? isLoading,
    String? error,
    int? offset,
    bool? hasMore,
  }) {
    return WorkoutHistoryNotifierState(
      workoutsWithMarkers: workoutsWithMarkers ?? this.workoutsWithMarkers,
      hasWorkoutsThisWeekMarker:
          hasWorkoutsThisWeekMarker ?? this.hasWorkoutsThisWeekMarker,
      hasWorkoutsInLastMonthMarker:
          hasWorkoutsInLastMonthMarker ?? this.hasWorkoutsInLastMonthMarker,
      hasWorkoutsInLastThreeMonthsMarker:
          hasWorkoutsInLastThreeMonthsMarker ??
          this.hasWorkoutsInLastThreeMonthsMarker,
      beginningOfIterationWeek:
          beginningOfIterationWeek ?? this.beginningOfIterationWeek,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
