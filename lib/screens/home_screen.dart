import 'package:flutter/material.dart';

import 'package:what_eat/constants/food_categories.dart';
import 'package:what_eat/models/category_spec.dart';
import 'package:what_eat/screens/nearby_restaurants_screen.dart';

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

  List<CategorySpec> get _categories => [
        CategorySpec(
          label: FoodCategory.korean.label,
          imageAsset: FoodCategory.korean.imageAsset,
          isEnabled: () => isKoreanEnabled,
          isPressed: () => isKoreanPressed,
          setEnabled: (value) => isKoreanEnabled = value,
          setPressed: (value) => isKoreanPressed = value,
        ),
        CategorySpec(
          label: FoodCategory.western.label,
          imageAsset: FoodCategory.western.imageAsset,
          isEnabled: () => isWesternEnabled,
          isPressed: () => isWesternPressed,
          setEnabled: (value) => isWesternEnabled = value,
          setPressed: (value) => isWesternPressed = value,
        ),
        CategorySpec(
          label: FoodCategory.chinese.label,
          imageAsset: FoodCategory.chinese.imageAsset,
          isEnabled: () => isChineseEnabled,
          isPressed: () => isChinesePressed,
          setEnabled: (value) => isChineseEnabled = value,
          setPressed: (value) => isChinesePressed = value,
        ),
        CategorySpec(
          label: FoodCategory.japanese.label,
          imageAsset: FoodCategory.japanese.imageAsset,
          isEnabled: () => isJapaneseEnabled,
          isPressed: () => isJapanesePressed,
          setEnabled: (value) => isJapaneseEnabled = value,
          setPressed: (value) => isJapanesePressed = value,
        ),
        CategorySpec(
          label: FoodCategory.snack.label,
          imageAsset: FoodCategory.snack.imageAsset,
          isEnabled: () => isSnackEnabled,
          isPressed: () => isSnackPressed,
          setEnabled: (value) => isSnackEnabled = value,
          setPressed: (value) => isSnackPressed = value,
        ),
      ];

  void _resetAllCategories() {
    isKoreanEnabled = true;
    isChineseEnabled = true;
    isWesternEnabled = true;
    isJapaneseEnabled = true;
    isSnackEnabled = true;

    isKoreanPressed = false;
    isChinesePressed = false;
    isWesternPressed = false;
    isJapanesePressed = false;
    isSnackPressed = false;
  }

  String? _getSingleEnabledCategoryLabel() {
    final enabledLabels = _categories
        .where((category) => category.isEnabled())
        .map((category) => category.label)
        .toList();

    if (enabledLabels.length == 1) {
      return enabledLabels.first;
    }

    return null;
  }

  void _toggleCategory(CategorySpec category) {
    setState(() {
      category.setEnabled(!category.isEnabled());
    });
    _navigateIfSingleEnabled();
  }

  void _setCategoryPressed(CategorySpec category, bool value) {
    setState(() {
      category.setPressed(value);
    });
  }

  void _navigateIfSingleEnabled() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final String? label = _getSingleEnabledCategoryLabel();
      if (label == null) {
        return;
      }

      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (_) => NearbyRestaurantsScreen(categoryLabel: label),
            ),
          )
          .then((_) {
            if (!mounted) {
              return;
            }
            setState(() {
              _resetAllCategories();
            });
          });
    });
  }

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
      final Color overlayColor = Colors.black.withValues(alpha: overlayOpacity);
      final Color effectiveForeground = enabled
          ? foreground
          : foreground.withValues(alpha: 0.6);

      return Container(
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
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
        children: _buildCategoryItems(buildCategory),
      ),
    );
  }

  List<Widget> _buildCategoryItems(
    Widget Function({
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
    }) buildCategory,
  ) {
    return List<Widget>.generate(_categories.length, (index) {
      final category = _categories[index];
      final bool showDivider = index < _categories.length - 1;
      return Expanded(
        child: buildCategory(
          label: category.label,
          imageAsset: category.imageAsset,
          foreground: Colors.white,
          enabled: category.isEnabled(),
          pressed: category.isPressed(),
          showDivider: showDivider,
          onTap: () => _toggleCategory(category),
          onTapDown: (_) => _setCategoryPressed(category, true),
          onTapUp: (_) => _setCategoryPressed(category, false),
          onTapCancel: () => _setCategoryPressed(category, false),
        ),
      );
    });
  }
}
