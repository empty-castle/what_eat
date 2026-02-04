import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../constants/app_messages.dart';
import '../constants/nearby_constants.dart';
import '../models/kakao_keyword_search_models.dart';

Future<({double x, double y})> fetchCurrentCoordinates() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception(AppMessages.locationServiceDisabled);
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception(AppMessages.locationPermissionDenied);
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(AppMessages.locationPermissionDeniedForever);
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );

  return (x: position.longitude, y: position.latitude);
}

Future<KakaoKeywordSearchResponse> fetchNearbyByKeyword(
  String query, {
  int page = 1,
  int size = 15,
  NearbySort sort = NearbySort.accuracy,
}) async {
  final coordinates = await fetchCurrentCoordinates();
  final uri = Uri.https(
    'dapi.kakao.com',
    '/v2/local/search/keyword.json',
    {
      'query': query,
      'x': coordinates.x.toString(),
      'y': coordinates.y.toString(),
      'radius': '1000',
      'sort': sort.queryValue,
      'category_group_code': 'FD6',
      'page': page.toString(),
      'size': size.toString(),
    },
  );

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'KakaoAK ${Env.kakaoRestApiKey}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        '${AppMessages.kakaoApiRequestFailed} (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception(AppMessages.kakaoApiInvalidResponse);
    }
    return KakaoKeywordSearchResponse.fromJson(decoded);
  } on Exception {
    rethrow;
  } catch (error) {
    throw Exception('${AppMessages.networkError} $error');
  }
}
