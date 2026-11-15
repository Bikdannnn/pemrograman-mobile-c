import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum RiskLevel { low, medium, high }

class RiskBannerCard extends StatelessWidget {
  final RiskLevel riskLevel;
  final String title;
  final String reason;
  final String lastCheckTime;
  final VoidCallback? onReportFalseAlarm;

  const RiskBannerCard({
    super.key,
    required this.riskLevel,
    required this.title,
    required this.reason,
    required this.lastCheckTime,
    this.onReportFalseAlarm,
  });

  Color get _backgroundColor {
    switch (riskLevel) {
      case RiskLevel.high:
        return AppColors.riskHighBackground;
      case RiskLevel.medium:
        return AppColors.riskMediumBackground;
      case RiskLevel.low:
        return AppColors.riskLowBackground;
    }
  }

  IconData get _icon {
    switch (riskLevel) {
      case RiskLevel.high:
        return Icons.warning_amber_rounded;
      case RiskLevel.medium:
        return Icons.info_outline_rounded;
      case RiskLevel.low:
        return Icons.check_circle_outline_rounded;
    }
  }

  String get _badgeText {
    switch (riskLevel) {
      case RiskLevel.high:
        return 'TINGKAT RISIKO: BAHAYA';
      case RiskLevel.medium:
        return 'TINGKAT RISIKO: WASPADA';
      case RiskLevel.low:
        return 'TINGKAT RISIKO: AMAN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge & Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(_icon, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        _badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Cek Terakhir: $lastCheckTime',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Title
            Text(title, style: AppTypography.riskHeader),
            const SizedBox(height: 8),

            // Reason Callout Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⚠️ ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      reason,
                      style: AppTypography.riskReason,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Actions (Report False Alarm button)
            if (onReportFalseAlarm != null)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: onReportFalseAlarm,
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag_outlined, color: Colors.white70, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Lapor Alarm Palsu',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
