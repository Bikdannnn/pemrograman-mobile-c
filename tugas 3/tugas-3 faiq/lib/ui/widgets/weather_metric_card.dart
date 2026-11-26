import 'package:flutter/material.dart';

class WeatherMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const WeatherMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF121A2B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF25324D),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF6BA6FF),
          ),
          const SizedBox(height: 14),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF8C9BB8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  color: Color(0xFF9AA8C4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
