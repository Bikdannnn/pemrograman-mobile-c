import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WildanWeatherApp());
}

class WildanWeatherApp extends StatelessWidget {
  const WildanWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca - Wildan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        cardTheme: const CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: const WeatherHomePage(),
    );
  }
}

/// Model data lokasi / kota
class CityLocation {
  final String name;
  final String admin1;
  final String country;
  final double latitude;
  final double longitude;

  const CityLocation({
    required this.name,
    required this.admin1,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName {
    if (admin1.isNotEmpty && admin1 != name) {
      return '$name, $admin1';
    }
    return '$name, $country';
  }

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      name: json['name'] as String? ?? 'Tidak diketahui',
      admin1: json['admin1'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Model data cuaca saat ini
class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final DateTime time;

  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature:
          (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      isDay: (json['is_day'] as num?)?.toInt() == 1,
      time: DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

/// Model ramalan harian
class DailyForecastItem {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;

  const DailyForecastItem({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
  });
}

/// Helper untuk menerjemahkan WMO Weather Code
class WeatherInfo {
  final String label;
  final IconData icon;
  final Color primaryColor;
  final List<Color> gradient;

  const WeatherInfo({
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.gradient,
  });

  static WeatherInfo fromCode(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return WeatherInfo(
          label: isDay ? 'Cerah' : 'Malam Cerah',
          icon: isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          primaryColor: Colors.amber.shade700,
          gradient: isDay
              ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
              : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
        );
      case 1:
        return WeatherInfo(
          label: 'Cerah Berawan',
          icon: Icons.wb_cloudy_rounded,
          primaryColor: Colors.orange.shade600,
          gradient: [const Color(0xFF38BDF8), const Color(0xFF0284C7)],
        );
      case 2:
        return WeatherInfo(
          label: 'Sebagian Berawan',
          icon: Icons.cloud_queue_rounded,
          primaryColor: Colors.blue.shade600,
          gradient: [const Color(0xFF60A5FA), const Color(0xFF2563EB)],
        );
      case 3:
        return WeatherInfo(
          label: 'Mendung',
          icon: Icons.cloud_rounded,
          primaryColor: Colors.blueGrey.shade600,
          gradient: [const Color(0xFF64748B), const Color(0xFF475569)],
        );
      case 45:
      case 48:
        return const WeatherInfo(
          label: 'Berkabut',
          icon: Icons.foggy,
          primaryColor: Colors.blueGrey,
          gradient: [Color(0xFF94A3B8), Color(0xFF64748B)],
        );
      case 51:
      case 53:
      case 55:
        return WeatherInfo(
          label: 'Gerimis Ringan',
          icon: Icons.grain_rounded,
          primaryColor: Colors.lightBlue.shade700,
          gradient: [const Color(0xFF38BDF8), const Color(0xFF0284C7)],
        );
      case 61:
      case 63:
      case 65:
        return WeatherInfo(
          label: 'Hujan',
          icon: Icons.water_drop_rounded,
          primaryColor: Colors.blue.shade800,
          gradient: [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
        );
      case 80:
      case 81:
      case 82:
        return WeatherInfo(
          label: 'Hujan Deras',
          icon: Icons.beach_access_rounded,
          primaryColor: Colors.indigo.shade700,
          gradient: [const Color(0xFF2563EB), const Color(0xFF1E40AF)],
        );
      case 95:
      case 96:
      case 99:
        return WeatherInfo(
          label: 'Badai Petir',
          icon: Icons.thunderstorm_rounded,
          primaryColor: Colors.deepPurple.shade700,
          gradient: [const Color(0xFF7C3AED), const Color(0xFF4C1D95)],
        );
      default:
        return WeatherInfo(
          label: 'Sebagian Berawan',
          icon: Icons.wb_cloudy_rounded,
          primaryColor: Colors.blue.shade600,
          gradient: [const Color(0xFF38BDF8), const Color(0xFF1D4ED8)],
        );
    }
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  // Lokasi default: Makassar (Kampus Unhas / Wildan)
  CityLocation _selectedCity = const CityLocation(
    name: 'Makassar',
    admin1: 'Sulawesi Selatan',
    country: 'Indonesia',
    latitude: -5.1486,
    longitude: 119.4319,
  );

  // Daftar kota rekomendasi untuk akses cepat
  final List<CityLocation> _presetCities = const [
    CityLocation(
      name: 'Makassar',
      admin1: 'Sulawesi Selatan',
      country: 'Indonesia',
      latitude: -5.1486,
      longitude: 119.4319,
    ),
    CityLocation(
      name: 'Jakarta',
      admin1: 'DKI Jakarta',
      country: 'Indonesia',
      latitude: -6.2088,
      longitude: 106.8456,
    ),
    CityLocation(
      name: 'Surabaya',
      admin1: 'Jawa Timur',
      country: 'Indonesia',
      latitude: -7.2575,
      longitude: 112.7521,
    ),
    CityLocation(
      name: 'Bandung',
      admin1: 'Jawa Barat',
      country: 'Indonesia',
      latitude: -6.9175,
      longitude: 107.6191,
    ),
    CityLocation(
      name: 'Denpasar',
      admin1: 'Bali',
      country: 'Indonesia',
      latitude: -8.6705,
      longitude: 115.2126,
    ),
    CityLocation(
      name: 'Yogyakarta',
      admin1: 'DI Yogyakarta',
      country: 'Indonesia',
      latitude: -7.7956,
      longitude: 110.3695,
    ),
  ];

  bool _isLoading = false;
  String? _errorMessage;
  CurrentWeather? _currentWeather;
  List<DailyForecastItem> _forecastList = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Mengambil data cuaca dari Open-Meteo API
  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?'
      'latitude=${_selectedCity.latitude}&'
      'longitude=${_selectedCity.longitude}&'
      'current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m&'
      'daily=weather_code,temperature_2m_max,temperature_2m_min&'
      'timezone=auto',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Parse cuaca saat ini
        final currentJson = data['current'] as Map<String, dynamic>;
        final current = CurrentWeather.fromJson(currentJson);

        // Parse ramalan harian
        final dailyJson = data['daily'] as Map<String, dynamic>;
        final times = (dailyJson['time'] as List<dynamic>?) ?? [];
        final weatherCodes = (dailyJson['weather_code'] as List<dynamic>?) ?? [];
        final maxTemps = (dailyJson['temperature_2m_max'] as List<dynamic>?) ?? [];
        final minTemps = (dailyJson['temperature_2m_min'] as List<dynamic>?) ?? [];

        final List<DailyForecastItem> forecast = [];
        for (int i = 0; i < times.length; i++) {
          final date = DateTime.tryParse(times[i].toString()) ?? DateTime.now();
          final code = (weatherCodes[i] as num).toInt();
          final maxT = (maxTemps[i] as num).toDouble();
          final minT = (minTemps[i] as num).toDouble();
          forecast.add(
            DailyForecastItem(
              date: date,
              weatherCode: code,
              maxTemp: maxT,
              minTemp: minT,
            ),
          );
        }

        setState(() {
          _currentWeather = current;
          _forecastList = forecast;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Gagal memuat cuaca (Status: ${response.statusCode}). Silakan coba lagi.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Tidak dapat terhubung ke internet atau server cuaca. Pastikan koneksi aktif.';
        _isLoading = false;
      });
    }
  }

  /// Dialog pencarian kota menggunakan Geocoding API
  void _openSearchDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _CitySearchBottomSheet(
          onCitySelected: (city) {
            Navigator.pop(ctx);
            setState(() {
              _selectedCity = city;
            });
            _fetchWeatherData();
          },
        );
      },
    );
  }

  String _formatDayName(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hari Ini';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Besok';
    }

    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final weatherInfo = _currentWeather != null
        ? WeatherInfo.fromCode(
            _currentWeather!.weatherCode,
            isDay: _currentWeather!.isDay,
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aplikasi Cuaca',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tugas 3 • M. Wildan (D121241058)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cari Kota',
            icon: const Icon(Icons.search_rounded),
            onPressed: _openSearchDialog,
          ),
          IconButton(
            tooltip: 'Muat Ulang',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _isLoading ? null : _fetchWeatherData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchWeatherData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pilihan Cepat Kota
              _buildPresetCities(),

              const SizedBox(height: 12),

              // Konten Utama: Loading / Error / Data
              if (_isLoading && _currentWeather == null) ...[
                const SizedBox(height: 100),
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Memuat prakiraan cuaca...'),
                    ],
                  ),
                ),
              ] else if (_errorMessage != null && _currentWeather == null) ...[
                _buildErrorCard(),
              ] else if (_currentWeather != null) ...[
                // Kartu Cuaca Utama
                _buildMainWeatherCard(weatherInfo!),

                const SizedBox(height: 16),

                // Grid Detail Parameter Cuaca
                _buildWeatherMetricsGrid(),

                const SizedBox(height: 20),

                // Ramalan Harian (Daily Forecast)
                _buildDailyForecastSection(),

                const SizedBox(height: 20),

                // Kartu Informasi Tugas & Sumber API
                _buildIdentityFooter(),

                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Widget chip pilihan kota cepat
  Widget _buildPresetCities() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _presetCities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final city = _presetCities[index];
          final isSelected = city.name == _selectedCity.name;
          return ChoiceChip(
            label: Text(city.name),
            selected: isSelected,
            selectedColor: const Color(0xFF2563EB),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : Colors.grey.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (selected) {
              if (selected && city.name != _selectedCity.name) {
                setState(() {
                  _selectedCity = city;
                });
                _fetchWeatherData();
              }
            },
          );
        },
      ),
    );
  }

  /// Kartu Cuaca Utama yang Menarik & Bersih
  Widget _buildMainWeatherCard(WeatherInfo info) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: info.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: info.gradient.last.withAlpha(70),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kota & Tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _selectedCity.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (_selectedCity.admin1.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          '${_selectedCity.admin1}, ${_selectedCity.country}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(210),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatDate(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Suhu dan Ikon Cuaca
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentWeather!.temperature.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    info.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Terasa seperti ${_currentWeather!.apparentTemperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Icon(
                info.icon,
                size: 92,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Grid 4 parameter cuaca (Kelembapan, Angin, Curah Hujan, dsb.)
  Widget _buildWeatherMetricsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Kelembapan',
            value: '${_currentWeather!.humidity}%',
            icon: Icons.water_drop_outlined,
            iconColor: const Color(0xFF0284C7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Kecepatan Angin',
            value: '${_currentWeather!.windSpeed.toStringAsFixed(1)} km/h',
            icon: Icons.air_rounded,
            iconColor: const Color(0xFF0D9488),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Curah Hujan',
            value: '${_currentWeather!.precipitation.toStringAsFixed(1)} mm',
            icon: Icons.umbrella_outlined,
            iconColor: const Color(0xFF6366F1),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withAlpha(25),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Prakiraan Cuaca 7 Hari
  Widget _buildDailyForecastSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                'Prakiraan 7 Hari ke Depan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _forecastList.length,
            separatorBuilder: (_, __) => const Divider(
              height: 16,
              thickness: 0.5,
              color: Color(0xFFF1F5F9),
            ),
            itemBuilder: (context, index) {
              final item = _forecastList[index];
              final info = WeatherInfo.fromCode(item.weatherCode);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 85,
                      child: Text(
                        _formatDayName(item.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: index == 0
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: index == 0
                              ? const Color(0xFF2563EB)
                              : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      info.icon,
                      size: 24,
                      color: info.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        info.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${item.maxTemp.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${item.minTemp.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Kartu identitas mahasiswa & tugas
  Widget _buildIdentityFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.school_rounded,
                size: 20,
                color: Color(0xFF1D4ED8),
              ),
              const SizedBox(width: 8),
              Text(
                'Informasi Mahasiswa',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Nama : M. Wildan Humaisi S. Budi',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Text(
            'NIM    : D121241058',
            style: TextStyle(fontSize: 13),
          ),
          const Text(
            'Kelas  : Pemrograman Mobile C - Tugas 3',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Data Cuaca: Open-Meteo REST API (Gratis & Real-time)',
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue.shade800,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Tampilan jika terjadi error
  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Gagal Mengambil Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Terjadi kesalahan sistem.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _fetchWeatherData,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal Bottom Sheet untuk pencarian kota
class _CitySearchBottomSheet extends StatefulWidget {
  final ValueChanged<CityLocation> onCitySelected;

  const _CitySearchBottomSheet({required this.onCitySelected});

  @override
  State<_CitySearchBottomSheet> createState() => _CitySearchBottomSheetState();
}

class _CitySearchBottomSheetState extends State<_CitySearchBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<CityLocation> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchCity(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(trimmed)}&count=8&language=id&format=json',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = (data['results'] as List<dynamic>?) ?? [];

        final List<CityLocation> cities = [];
        for (var item in results) {
          cities.add(CityLocation.fromJson(item as Map<String, dynamic>));
        }

        setState(() {
          _searchResults = cities;
          _isSearching = false;
          if (cities.isEmpty) {
            _searchError = 'Kota "$trimmed" tidak ditemukan.';
          }
        });
      } else {
        setState(() {
          _searchError = 'Gagal mencari kota.';
          _isSearching = false;
        });
      }
    } catch (_) {
      setState(() {
        _searchError = 'Gagal menghubungi server pencarian.';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cari Lokasi / Kota',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Ketik nama kota (misal: Makassar, Gowa, Tokyo)...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _searchResults.clear();
                          _searchError = null;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onSubmitted: _searchCity,
          ),
          const SizedBox(height: 12),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_searchError != null)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  _searchError!,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        'Masukkan nama kota lalu tekan Enter / Cari',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final city = _searchResults[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFEFF6FF),
                            child: Icon(
                              Icons.location_city_rounded,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          title: Text(
                            city.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(city.displayName),
                          onTap: () => widget.onCitySelected(city),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
