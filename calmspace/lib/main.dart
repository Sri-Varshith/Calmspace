import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  // Ensures Flutter engine is ready before we do anything
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope is the heart of Riverpod
    // It must wrap your entire app
    // Without this, NO provider will work
    const ProviderScope(
      child: CalmSpaceApp(),
    ),
  );
}

class CalmSpaceApp extends StatelessWidget {
  const CalmSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalmSpace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        backgroundColor: Color(0xFF0D0D1A),
        body: Center(
          child: Text(
            'CalmSpace',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}