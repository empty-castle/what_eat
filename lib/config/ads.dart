class AdmobConfig {
  const AdmobConfig._();

  // Test banner ad unit ID (Android)
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/9214589741';

  // For production, inject via dart-define.
  // Example: --dart-define=ADMOB_BANNER_AD_UNIT_ID=ca-app-pub-xxxxx/yyyyy
  static const String bannerAdUnitId = String.fromEnvironment(
    'ADMOB_BANNER_AD_UNIT_ID',
    defaultValue: testBannerAdUnitId,
  );
}
