// Use: flutter run/build --dart-define-from-file=secrets.env
// This file reads values provided at build time.

class Env {
  static String get kakaoRestApiKey {
    const value = String.fromEnvironment('KAKAO_REST_API_KEY');
    if (value.isEmpty) {
      throw StateError(
        'KAKAO_REST_API_KEY is missing. Provide it via --dart-define-from-file.',
      );
    }
    return value;
  }
}
