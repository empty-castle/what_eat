import 'package:flutter/material.dart';

class NearbyRestaurantsScreen extends StatelessWidget {
  const NearbyRestaurantsScreen({super.key, required this.categoryLabel});

  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryLabel)),
      body: Center(
        child: Text(categoryLabel),
      ),
    );
  }
}
