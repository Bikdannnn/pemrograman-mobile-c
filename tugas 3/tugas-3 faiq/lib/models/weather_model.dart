import 'package:flutter/material.dart';

class CityLocation {
  final String name;
  final double latitude;
  final double longitude;

  const CityLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  static const List<CityLocation> presets = [
    CityLocation(name: 'Makassar', latitude: -5.1477, longitude: 119.4327),
    CityLocation(name: 'Jakarta', latitude: -6.2088, longitude: 106.8456),
    CityLocation(name: 'Surabaya', latitude: -7.2575, longitude: 112.7521),
    CityLocation(name: 'Bandung', latitude: -6.9175, longitude: 107.6191),
    CityLocation(name: 'Yogyakarta', latitude: -7.7956, longitude: 110.3695),
    CityLocation(name: 'Denpasar', latitude: -8.6705, longitude: 115.2126),
  ];
}

class WeatherData {
  final String cityName;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final double surfacePressure;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final String observationTime;

  const WeatherData({
    required this.cityName,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.surfacePressure,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.observationTime,
  });

  factory WeatherData.fromJson(
    Map<String, dynamic> json, {
    required String cityName,
  }) {
    final current = json['current'] as Map<String, dynamic>?;
    if (current == null) {
      throw const FormatException('Data cuaca tidak ditemukan pada respons API.');
    }

    return WeatherData(
      cityName: cityName,
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).round(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      surfacePressure: (current['surface_pressure'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      isDay: (current['is_day'] as num? ?? 1).toInt() == 1,
      observationTime: (current['time'] as String? ?? ''),
    );
  }

  String get formattedTime {
    final tIndex = observationTime.indexOf('T');
    if (tIndex != -1 && tIndex + 1 < observationTime.length) {
      return observationTime.substring(tIndex + 1);
    }
    return observationTime.isEmpty ? '-' : observationTime;
  }

  String get conditionLabel {
    switch (weatherCode) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah Berawan';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Mendung';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
      case 53:
      case 55:
        return 'Gerimis';
      case 56:
      case 57:
        return 'Gerimis Dingin';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 80:
      case 81:
      case 82:
        return 'Hujan Lokal';
      case 95:
      case 96:
      case 99:
        return 'Badai Petir';
      default:
        return 'Berawan';
    }
  }

  IconData get conditionIcon {
    switch (weatherCode) {
      case 0:
        return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
      case 1:
      case 2:
        return isDay ? Icons.wb_cloudy_rounded : Icons.nights_stay_rounded;
      case 3:
      case 45:
      case 48:
        return Icons.cloud_rounded;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return Icons.grain_rounded;
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.water_drop_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.cloud_queue_rounded;
    }
  }

  Color get conditionAccentColor {
    if (weatherCode == 0 || weatherCode == 1) {
      return const Color(0xFFFBBF24);
    }
    if (weatherCode >= 51 && weatherCode <= 57) {
      return const Color(0xFFF59E0B);
    }
    if (weatherCode >= 61 && weatherCode <= 82) {
      return const Color(0xFF60A5FA);
    }
    if (weatherCode >= 95) {
      return const Color(0xFFF87171);
    }
    return const Color(0xFF93C5FD);
  }

  String get windAdvisory {
    if (windSpeed < 10) {
      return 'Kondisi angin tenang. Data bersumber dari Open-Meteo.';
    }
    if (windSpeed < 25) {
      return 'Kondisi angin sedang. Data bersumber dari Open-Meteo.';
    }
    return 'Kondisi angin cukup kencang, tetap berhati-hati. Data bersumber dari Open-Meteo.';
  }
}
