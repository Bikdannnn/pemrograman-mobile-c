import 'package:flutter/material.dart';

/// High contrast color palette optimized for outdoor sunlight readability
/// and clear risk signaling for catfish pond farmers.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Branding & Surfaces
  static const Color primaryHeader = Color(0xFF0F172A); // Dark Slate Blue
  static const Color surfaceBackground = Color(0xFFF1F5F9); // Light Grey/Slate
  static const Color cardSurface = Color(0xFFFFFFFF); // Pure White
  static const Color textPrimary = Color(0xFF0F172A); // High Contrast Dark
  static const Color textSecondary = Color(0xFF475569); // Muted Dark Slate
  static const Color borderOutline = Color(0xFFCBD5E1);

  // Risk Levels (Medicine Test Warnings)
  // Low Risk / Aman
  static const Color riskLowBackground = Color(0xFF15803D); // Strong Green
  static const Color riskLowLight = Color(0xFFDCFCE7);
  static const Color riskLowText = Color(0xFF14532D);

  // Medium Risk / Waspada
  static const Color riskMediumBackground = Color(0xFFC2410C); // Vibrant Rust / Dark Amber
  static const Color riskMediumLight = Color(0xFFFFEDD5);
  static const Color riskMediumText = Color(0xFF7C2D12);

  // High Risk / Bahaya (Critical Loss Threat)
  static const Color riskHighBackground = Color(0xFFB91C1C); // Deep Red
  static const Color riskHighLight = Color(0xFFFEE2E2);
  static const Color riskHighText = Color(0xFF7F1D1D);

  // Action & Buttons
  static const Color primaryButton = Color(0xFF0284C7); // High contrast Cyan/Blue
  static const Color expertContact = Color(0xFF25D366); // WhatsApp Green
  static const Color expertContactDark = Color(0xFF128C7E);
}
