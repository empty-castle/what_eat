import 'package:flutter/foundation.dart';

import '../constants/nearby_constants.dart';
import '../constants/app_messages.dart';
import '../models/kakao_keyword_search_models.dart';
import '../models/paging_state.dart';
import '../services/kakao_place_service.dart';

class NearbyRestaurantsController extends ChangeNotifier {
  NearbyRestaurantsController({
    required String categoryLabel,
    required int pageSize,
  })  : _categoryLabel = categoryLabel,
        _pageSize = pageSize;

  final int _pageSize;
  final List<KakaoPlaceDocument> _places = [];
  PagingState _paging = PagingState.initial();
  NearbySort _currentSort = NearbySort.distance;
  String _categoryLabel;
  bool _isDisposed = false;

  List<KakaoPlaceDocument> get places => List.unmodifiable(_places);
  PagingState get paging => _paging;
  NearbySort get currentSort => _currentSort;

  Future<void> loadInitial() async {
    await _fetchPage(1, isRefresh: true);
  }

  Future<void> loadNextPage() async {
    await _fetchPage(_paging.currentPage + 1, isRefresh: false);
  }

  void resetAndReload() {
    _places.clear();
    _paging = PagingState.initial();
    _safeNotify();
    _fetchPage(1, isRefresh: true);
  }

  void updateSort(NearbySort sort) {
    if (_currentSort == sort) {
      return;
    }
    _currentSort = sort;
    resetAndReload();
  }

  void updateCategoryLabel(String label) {
    if (_categoryLabel == label) {
      return;
    }
    _categoryLabel = label;
    resetAndReload();
  }

  bool _isLastPageByCount(int? pageableCount, int currentPage) {
    if (pageableCount == null) {
      return false;
    }
    final totalPages = (pageableCount / _pageSize).ceil();
    return currentPage >= totalPages;
  }

  Future<void> _fetchPage(
    int page, {
    required bool isRefresh,
  }) async {
    if (!isRefresh && (_paging.isLoadingMore || _paging.isEnd)) {
      return;
    }
    _paging = _paging.copyWith(
      isInitialLoading: isRefresh,
      isLoadingMore: !isRefresh,
      initialLoadError: isRefresh ? null : _paging.initialLoadError,
      loadMoreError: isRefresh ? _paging.loadMoreError : null,
    );
    _safeNotify();
    try {
      final response = await fetchNearbyByKeyword(
        _categoryLabel,
        page: page,
        size: _pageSize,
        sort: _currentSort,
      );
      if (_isDisposed) {
        return;
      }
      final newCurrentPage = page;
      final newPageableCount = response.meta.pageableCount;
      final isEnd =
          response.meta.isEnd || _isLastPageByCount(newPageableCount, newCurrentPage);
      if (isRefresh) {
        _places
          ..clear()
          ..addAll(response.documents);
      } else {
        _places.addAll(response.documents);
      }
      _paging = _paging.copyWith(
        currentPage: newCurrentPage,
        totalCount: response.meta.totalCount,
        pageableCount: newPageableCount,
        isEnd: isEnd,
        isInitialLoading: false,
        isLoadingMore: false,
      );
      _safeNotify();
    } catch (error) {
      if (_isDisposed) {
        return;
      }
      _paging = _paging.copyWith(
        isInitialLoading: false,
        isLoadingMore: false,
        initialLoadError:
            isRefresh ? AppMessages.nearbyLoadFailed : _paging.initialLoadError,
        loadMoreError:
            isRefresh ? _paging.loadMoreError : AppMessages.nearbyLoadMoreFailed,
      );
      _safeNotify();
    }
  }

  void _safeNotify() {
    if (_isDisposed) {
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
