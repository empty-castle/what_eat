import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdArea extends StatelessWidget {
  const BannerAdArea({
    super.key,
    required this.size,
    required this.isLoaded,
    required this.bannerAd,
  });

  final AdSize size;
  final bool isLoaded;
  final BannerAd? bannerAd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height.toDouble(),
      width: double.infinity,
      child: isLoaded && bannerAd != null
          ? AdWidget(ad: bannerAd!)
          : const SizedBox.shrink(),
    );
  }
}
