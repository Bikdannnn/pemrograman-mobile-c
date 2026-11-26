import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseHost = 'api.open-meteo.com';
  static const String _forecastPath = '/v1/forecast';

  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherData> fetchCurrentWeather(CityLocation city) async {
    final uri = Uri.https(_baseHost, _forecastPath, {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,surface_pressure,wind_speed_10m',
      'timezone': 'auto',
    });

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        throw Exception(
          'Server mengembalikan status ${response.statusCode}. Silakan coba lagi.',
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherData.fromJson(decoded, cityName: city.name);
    } on TimeoutException {
      throw Exception(
        'Koneksi terlalu lama (timeout). Periksa jaringan internet Anda.',
      );
    } on FormatException {
      throw Exception('Format data dari server tidak sesuai.');
    } on http.ClientException {
      throw Exception(
        'Gagal terhubung ke server Open-Meteo. Pastikan perangkat terhubung ke internet.',
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      throw Exception(
        message.isEmpty ? 'Terjadi kesalahan saat memuat data cuaca.' : message,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
