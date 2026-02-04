enum FoodCategory {
  korean,
  chinese,
  western,
  japanese,
  snack;

  static const List<FoodCategory> all = FoodCategory.values;

  String get label {
    switch (this) {
      case FoodCategory.korean:
        return '한식';
      case FoodCategory.chinese:
        return '중식';
      case FoodCategory.western:
        return '양식';
      case FoodCategory.japanese:
        return '일식';
      case FoodCategory.snack:
        return '분식';
    }
  }

  String get imageAsset {
    switch (this) {
      case FoodCategory.korean:
        return 'assets/images/korean.png';
      case FoodCategory.chinese:
        return 'assets/images/chinese.png';
      case FoodCategory.western:
        return 'assets/images/western.png';
      case FoodCategory.japanese:
        return 'assets/images/japanese.png';
      case FoodCategory.snack:
        return 'assets/images/snack.png';
    }
  }
}
