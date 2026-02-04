enum NearbySort {
  accuracy,
  distance,
}

extension NearbySortX on NearbySort {
  String get label {
    switch (this) {
      case NearbySort.accuracy:
        return '정확도순';
      case NearbySort.distance:
        return '거리순';
    }
  }

  String get queryValue {
    switch (this) {
      case NearbySort.accuracy:
        return 'accuracy';
      case NearbySort.distance:
        return 'distance';
    }
  }
}

class NearbyLabels {
  const NearbyLabels._();

  static const String mapLaunchFailed = '지도를 열 수 없습니다.';
  static const String mapInvalidUrl = '유효하지 않은 주소입니다.';
}
