import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class WeatherHeroCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherHeroCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF162238),
            Color(0xFF1F3557),
            Color(0xFF28436B),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF334E78).withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Color(0xFFB6C6E2),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      color: Color(0xFFDDE7F7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                'Diperbarui ${weather.formattedTime}',
                style: const TextStyle(
                  color: Color(0xFF9EB3D6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      weather.conditionIcon,
                      size: 36,
                      color: weather.conditionAccentColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.conditionLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
