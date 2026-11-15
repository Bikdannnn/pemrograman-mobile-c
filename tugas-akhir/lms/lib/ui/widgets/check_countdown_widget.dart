import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CheckCountdownWidget extends StatelessWidget {
  final String nextCheckTime; // e.g. "09:00 WIB"
  final String remainingText; // e.g. "3 Jam 15 Menit Lagi"
  final VoidCallback? onStartCheckNow;

  const CheckCountdownWidget({
    super.key,
    required this.nextCheckTime,
    required this.remainingText,
    this.onStartCheckNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryHeader,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: Colors.amberAccent,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jadwal Cek Kolam Berikutnya',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$nextCheckTime ($remainingText)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (onStartCheckNow != null)
            TextButton(
              onPressed: onStartCheckNow,
              style: TextButton.styleFrom(
                foregroundColor: Colors.amberAccent,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('Cek Sekarang'),
            ),
        ],
      ),
    );
  }
}
