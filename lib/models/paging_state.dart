class PagingState {
  const PagingState({
    required this.currentPage,
    required this.totalCount,
    required this.pageableCount,
    required this.isEnd,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.initialLoadError,
    required this.loadMoreError,
  });

  final int currentPage;
  final int? totalCount;
  final int? pageableCount;
  final bool isEnd;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? initialLoadError;
  final String? loadMoreError;

  factory PagingState.initial() => const PagingState(
        currentPage: 0,
        totalCount: null,
        pageableCount: null,
        isEnd: false,
        isInitialLoading: true,
        isLoadingMore: false,
        initialLoadError: null,
        loadMoreError: null,
      );

  PagingState copyWith({
    int? currentPage,
    int? totalCount,
    int? pageableCount,
    bool? isEnd,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? initialLoadError,
    String? loadMoreError,
  }) {
    return PagingState(
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      pageableCount: pageableCount ?? this.pageableCount,
      isEnd: isEnd ?? this.isEnd,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      initialLoadError: initialLoadError ?? this.initialLoadError,
      loadMoreError: loadMoreError ?? this.loadMoreError,
    );
  }
}
