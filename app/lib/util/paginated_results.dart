class PaginatedResults<T> {
  final T results;
  final int nextOffset;
  final bool hasMore;

  const PaginatedResults(this.results, this.nextOffset, this.hasMore);
}
