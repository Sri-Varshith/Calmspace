import 'package:flutter/material.dart';
import '../../../data/models/ambience.dart';

class AmbienceDetailScreen extends StatelessWidget {
  final Ambience ambience;

  const AmbienceDetailScreen({
    super.key,
    required this.ambience,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(ambience.title),
      ),
    );
  }
}