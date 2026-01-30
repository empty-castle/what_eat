import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isKoreanEnabled = true;
  bool isChineseEnabled = true;
  bool isWesternEnabled = true;
  bool isJapaneseEnabled = true;
  bool isSnackEnabled = true;

  bool isKoreanPressed = false;
  bool isChinesePressed = false;
  bool isWesternPressed = false;
  bool isJapanesePressed = false;
  bool isSnackPressed = false;

  @override
  Widget build(BuildContext context) {
    Widget buildCategory({
      required String label,
      required String imageAsset,
      required Color foreground,
      required bool enabled,
      required bool pressed,
      required bool showDivider,
      required VoidCallback onTap,
      required VoidCallback onTapCancel,
      required void Function(TapDownDetails details) onTapDown,
      required void Function(TapUpDetails details) onTapUp,
    }) {
      final double overlayOpacity = enabled
          ? (pressed ? 0.22 : 0.12)
          : (pressed ? 0.55 : 0.48);
      final Color overlayColor = Colors.black.withOpacity(overlayOpacity);
      final Color effectiveForeground =
          enabled ? foreground : foreground.withOpacity(0.6);

      return Container(
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          elevation: pressed ? 1 : (enabled ? 6 : 0),
          color: Colors.transparent,
          shadowColor: Colors.black54,
          shape: BoxShape.rectangle,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  color: overlayColor,
                  colorBlendMode: BlendMode.darken,
                ),
                GestureDetector(
                  onTap: onTap,
                  onTapDown: onTapDown,
                  onTapUp: onTapUp,
                  onTapCancel: onTapCancel,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: effectiveForeground,
                        shadows: const [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('뭐먹지')),
      body: Column(
        children: [
          Expanded(
            child: buildCategory(
              label: '한식',
              imageAsset: 'assets/images/korean.png',
              foreground: Colors.white,
              enabled: isKoreanEnabled,
              pressed: isKoreanPressed,
              showDivider: true,
              onTap: () => setState(() {
                isKoreanEnabled = !isKoreanEnabled;
              }),
              onTapDown: (_) => setState(() {
                isKoreanPressed = true;
              }),
              onTapUp: (_) => setState(() {
                isKoreanPressed = false;
              }),
              onTapCancel: () => setState(() {
                isKoreanPressed = false;
              }),
            ),
          ),
          Expanded(
            child: buildCategory(
              label: '중식',
              imageAsset: 'assets/images/chinese.png',
              foreground: Colors.white,
              enabled: isChineseEnabled,
              pressed: isChinesePressed,
              showDivider: true,
              onTap: () => setState(() {
                isChineseEnabled = !isChineseEnabled;
              }),
              onTapDown: (_) => setState(() {
                isChinesePressed = true;
              }),
              onTapUp: (_) => setState(() {
                isChinesePressed = false;
              }),
              onTapCancel: () => setState(() {
                isChinesePressed = false;
              }),
            ),
          ),
          Expanded(
            child: buildCategory(
              label: '양식',
              imageAsset: 'assets/images/western.png',
              foreground: Colors.white,
              enabled: isWesternEnabled,
              pressed: isWesternPressed,
              showDivider: true,
              onTap: () => setState(() {
                isWesternEnabled = !isWesternEnabled;
              }),
              onTapDown: (_) => setState(() {
                isWesternPressed = true;
              }),
              onTapUp: (_) => setState(() {
                isWesternPressed = false;
              }),
              onTapCancel: () => setState(() {
                isWesternPressed = false;
              }),
            ),
          ),
          Expanded(
            child: buildCategory(
              label: '일식',
              imageAsset: 'assets/images/japanese.png',
              foreground: Colors.white,
              enabled: isJapaneseEnabled,
              pressed: isJapanesePressed,
              showDivider: true,
              onTap: () => setState(() {
                isJapaneseEnabled = !isJapaneseEnabled;
              }),
              onTapDown: (_) => setState(() {
                isJapanesePressed = true;
              }),
              onTapUp: (_) => setState(() {
                isJapanesePressed = false;
              }),
              onTapCancel: () => setState(() {
                isJapanesePressed = false;
              }),
            ),
          ),
          Expanded(
            child: buildCategory(
              label: '분식',
              imageAsset: 'assets/images/snack.png',
              foreground: Colors.white,
              enabled: isSnackEnabled,
              pressed: isSnackPressed,
              showDivider: false,
              onTap: () => setState(() {
                isSnackEnabled = !isSnackEnabled;
              }),
              onTapDown: (_) => setState(() {
                isSnackPressed = true;
              }),
              onTapUp: (_) => setState(() {
                isSnackPressed = false;
              }),
              onTapCancel: () => setState(() {
                isSnackPressed = false;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
