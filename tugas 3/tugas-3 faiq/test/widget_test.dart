import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_3_faiq/models/weather_model.dart';

void main() {
  test('WeatherData.fromJson parses Open-Meteo response accurately', () {
    final json = <String, dynamic>{
      'current': {
        'time': '2026-11-26T14:54',
        'temperature_2m': 33.8,
        'relative_humidity_2m': 47,
        'apparent_temperature': 36.2,
        'is_day': 1,
        'precipitation': 0.2,
        'weather_code': 51,
        'surface_pressure': 1009.4,
        'wind_speed_10m': 12.1,
      },
    };

    final weather = WeatherData.fromJson(json, cityName: 'Jakarta');

    expect(weather.cityName, 'Jakarta');
    expect(weather.temperature, 33.8);
    expect(weather.humidity, 47);
    expect(weather.windSpeed, 12.1);
    expect(weather.conditionLabel, 'Gerimis');
    expect(weather.formattedTime, '14:54');
  });
}
