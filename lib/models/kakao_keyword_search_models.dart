double? _toDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

int? _toInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

class KakaoKeywordSearchResponse {
  const KakaoKeywordSearchResponse({
    required this.meta,
    required this.documents,
  });

  final KakaoKeywordSearchMeta meta;
  final List<KakaoPlaceDocument> documents;

  factory KakaoKeywordSearchResponse.fromJson(Map<String, dynamic> json) {
    return KakaoKeywordSearchResponse(
      meta: KakaoKeywordSearchMeta.fromJson(
        json['meta'] as Map<String, dynamic>,
      ),
      documents: (json['documents'] as List<dynamic>)
          .map((item) => KakaoPlaceDocument.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'meta': meta.toJson(),
        'documents': documents.map((item) => item.toJson()).toList(),
      };
}

class KakaoKeywordSearchMeta {
  const KakaoKeywordSearchMeta({
    required this.totalCount,
    required this.pageableCount,
    required this.isEnd,
    this.sameName,
  });

  final int? totalCount;
  final int? pageableCount;
  final bool isEnd;
  final KakaoSameName? sameName;

  factory KakaoKeywordSearchMeta.fromJson(Map<String, dynamic> json) {
    return KakaoKeywordSearchMeta(
      totalCount: _toInt(json['total_count']),
      pageableCount: _toInt(json['pageable_count']),
      isEnd: json['is_end'] as bool? ?? false,
      sameName: json['same_name'] is Map<String, dynamic>
          ? KakaoSameName.fromJson(
              json['same_name'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_count': totalCount,
        'pageable_count': pageableCount,
        'is_end': isEnd,
        'same_name': sameName?.toJson(),
      };
}

class KakaoSameName {
  const KakaoSameName({
    required this.region,
    required this.keyword,
    required this.selectedRegion,
  });

  final List<String> region;
  final String keyword;
  final String selectedRegion;

  factory KakaoSameName.fromJson(Map<String, dynamic> json) {
    return KakaoSameName(
      region: (json['region'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      keyword: json['keyword'] as String? ?? '',
      selectedRegion: json['selected_region'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'region': region,
        'keyword': keyword,
        'selected_region': selectedRegion,
      };
}

class KakaoPlaceDocument {
  const KakaoPlaceDocument({
    required this.id,
    required this.placeName,
    required this.placeUrl,
    required this.categoryName,
    required this.categoryGroupCode,
    required this.categoryGroupName,
    required this.phone,
    required this.addressName,
    required this.roadAddressName,
    required this.x,
    required this.y,
    required this.distance,
  });

  final String id;
  final String placeName;
  final String placeUrl;
  final String categoryName;
  final String categoryGroupCode;
  final String categoryGroupName;
  final String phone;
  final String addressName;
  final String roadAddressName;
  final double? x;
  final double? y;
  final int? distance;

  factory KakaoPlaceDocument.fromJson(Map<String, dynamic> json) {
    return KakaoPlaceDocument(
      id: json['id'] as String? ?? '',
      placeName: json['place_name'] as String? ?? '',
      placeUrl: json['place_url'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      categoryGroupCode: json['category_group_code'] as String? ?? '',
      categoryGroupName: json['category_group_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      addressName: json['address_name'] as String? ?? '',
      roadAddressName: json['road_address_name'] as String? ?? '',
      x: _toDouble(json['x']),
      y: _toDouble(json['y']),
      distance: _toInt(json['distance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'place_name': placeName,
        'place_url': placeUrl,
        'category_name': categoryName,
        'category_group_code': categoryGroupCode,
        'category_group_name': categoryGroupName,
        'phone': phone,
        'address_name': addressName,
        'road_address_name': roadAddressName,
        'x': x,
        'y': y,
        'distance': distance,
      };
}
