import 'package:flutter/material.dart';
import 'ui/screens/weather_screen.dart';

void main() {
  runApp(const CuacaHariIniApp());
}

class CuacaHariIniApp extends StatelessWidget {
  const CuacaHariIniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuaca Hari Ini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B101D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6CA5F8),
          surface: Color(0xFF121A2B),
        ),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}
