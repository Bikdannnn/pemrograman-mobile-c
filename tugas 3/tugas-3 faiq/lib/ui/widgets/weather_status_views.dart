import 'package:flutter/material.dart';

class WeatherInfoBanner extends StatelessWidget {
  final String message;

  const WeatherInfoBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF25324D)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: Color(0xFF6BA6FF),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFB5C2DA),
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherLoadingView extends StatelessWidget {
  final String cityName;

  const WeatherLoadingView({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFF6CA5F8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat data cuaca $cityName...',
            style: const TextStyle(
              color: Color(0xFFB5C2DA),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const WeatherErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF121A2B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A2533)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Color(0xFFF87171),
            ),
            const SizedBox(height: 14),
            const Text(
              'Gagal Memuat Data Cuaca',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFFB5C2DA),
                fontSize: 14,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6CA5F8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
