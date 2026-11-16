import 'package:flutter/material.dart';

/// Palet warna persis dari ekstraksi SVG Figma (`Components.svg`, `USER.svg`, `PEMILIK RESTORAN.svg`):
/// - Hijau Tua Header (`#183A1D`)
/// - Hijau Muda Pill/Chat Bubble (`#E1EEDD`)
/// - Oranye Utama (`#F0A04B` / `#F1A14C`)
/// - Oranye Gelap Active/Pressed (`#D9750B` / `#D8750B`)
/// - Krem Splash & Top of the Week (`#FEFBE9` / `#FFFDE8`)
/// - Emas Bintang Rating (`#FFBF00`)
/// - Abu-abu Komponen & Input (`#DEDEDE`, `#EFEFEF`, `#E0E0E0`, `#8D8D8D`)
/// - Merah Error Validasi (`#FF0606`)
class AppColors {
  static const Color primaryGreen = Color(0xFF183A1D);
  static const Color lightGreenPill = Color(0xFFE1EEDD);
  static const Color greenOnline = Color(0xFF2C8939);

  static const Color primaryOrange = Color(0xFFF0A04B);
  static const Color darkOrange = Color(0xFFD9750B);
  static const Color lightOrange = Color(0xFFF4B670);

  static const Color splashCream = Color(0xFFFEFBE9);
  static const Color starYellow = Color(0xFFFFBF00);

  static const Color componentCanvasGray = Color(0xFFDEDEDE);
  static const Color chipGray = Color(0xFFEFEFEF);
  static const Color disabledButtonGray = Color(0xFFE0E0E0);
  static const Color inputBgGray = Color(0xFFF6F6F6);
  static const Color borderGray = Color(0xFFBDBDBD);

  static const Color textDark = Color(0xFF222227);
  static const Color textGray = Color(0xFF8D8D8D);
  static const Color textMuted = Color(0xFF606060);
  static const Color errorRed = Color(0xFFFF0606);

  // Alias agar kompatibel di seluruh komponen
  static const Color accentOrange = primaryOrange;
  static const Color accentOrangeDark = darkOrange;
  static const Color starGold = starYellow;
}

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      primary: AppColors.primaryGreen,
      secondary: AppColors.primaryOrange,
      surface: Colors.white,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabledButtonGray,
          disabledForegroundColor: AppColors.textDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
