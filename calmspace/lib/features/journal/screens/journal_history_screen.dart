import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';

class JournalHistoryScreen extends StatelessWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal', style: AppTheme.headingSmall),
      ),
      body: const Center(
        child: Text('Journal History Coming Soon'),
      ),
    );
  }
}