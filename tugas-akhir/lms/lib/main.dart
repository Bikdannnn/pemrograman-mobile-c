import 'package:flutter/material.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/main_navigation_screen.dart';

void main() {
  runApp(const LMSApp());
}

class LMSApp extends StatelessWidget {
  const LMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LMS - Lele Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const MainNavigationScreen(),
    );
  }
}
