class CategorySpec {
  const CategorySpec({
    required this.label,
    required this.imageAsset,
    required this.isEnabled,
    required this.isPressed,
    required this.setEnabled,
    required this.setPressed,
  });

  final String label;
  final String imageAsset;
  final bool Function() isEnabled;
  final bool Function() isPressed;
  final void Function(bool value) setEnabled;
  final void Function(bool value) setPressed;
}
