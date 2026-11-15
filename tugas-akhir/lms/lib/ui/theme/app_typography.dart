import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography configuration designed for outdoor high-sunlight contrast
/// and easy readability on budget Android devices.
class AppTypography {
  AppTypography._();

  static const TextStyle screenHeader = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle riskHeader = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle riskReason = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.3,
  );

  static const TextStyle actionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle actionBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}
