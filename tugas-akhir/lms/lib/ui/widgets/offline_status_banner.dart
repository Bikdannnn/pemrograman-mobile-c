import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Banner showing offline status and local rules engine indicator
class OfflineStatusBanner extends StatelessWidget {
  final bool isOffline;

  const OfflineStatusBanner({
    super.key,
    this.isOffline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primaryHeader,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isOffline ? Colors.amberAccent : Colors.greenAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isOffline
                  ? 'Mode Offline — Aturan Risiko Berjalan Lokal di HP'
                  : 'Terhubung — Sinkronisasi Data Aktif',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.wifi_off_rounded,
            color: Colors.white70,
            size: 16,
          ),
        ],
      ),
    );
  }
}
