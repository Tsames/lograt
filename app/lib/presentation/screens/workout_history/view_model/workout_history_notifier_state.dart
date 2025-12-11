class WorkoutHistoryNotifierState {
  final List<dynamic> workoutsWithSectionHeaders;
  final bool hasWorkoutsThisWeekSectionHeader;
  final bool hasWorkoutsInLastMonthSectionHeader;
  final bool hasWorkoutsInLastThreeMonthsSectionHeader;
  final DateTime? beginningOfIterationWeek;

  final bool isLoading;
  final String? error;

  final int offset;
  final bool hasMore;

  const WorkoutHistoryNotifierState({
    this.workoutsWithSectionHeaders = const [],
    this.hasWorkoutsThisWeekSectionHeader = false,
    this.hasWorkoutsInLastMonthSectionHeader = false,
    this.hasWorkoutsInLastThreeMonthsSectionHeader = false,
    this.beginningOfIterationWeek,
    this.isLoading = false,
    this.error,
    this.offset = 0,
    this.hasMore = true,
  });

  WorkoutHistoryNotifierState copyWith({
    List<dynamic>? workoutsWithSectionHeaders,
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
      workoutsWithSectionHeaders:
          workoutsWithSectionHeaders ?? this.workoutsWithSectionHeaders,
      hasWorkoutsThisWeekSectionHeader:
          hasWorkoutsThisWeekMarker ?? hasWorkoutsThisWeekSectionHeader,
      hasWorkoutsInLastMonthSectionHeader:
          hasWorkoutsInLastMonthMarker ?? hasWorkoutsInLastMonthSectionHeader,
      hasWorkoutsInLastThreeMonthsSectionHeader:
          hasWorkoutsInLastThreeMonthsMarker ??
          hasWorkoutsInLastThreeMonthsSectionHeader,
      beginningOfIterationWeek:
          beginningOfIterationWeek ?? this.beginningOfIterationWeek,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
