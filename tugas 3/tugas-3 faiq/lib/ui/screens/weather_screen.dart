import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import '../../services/weather_service.dart';
import '../widgets/weather_hero_card.dart';
import '../widgets/weather_metric_card.dart';
import '../widgets/weather_status_views.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherService? weatherService;

  const WeatherScreen({super.key, this.weatherService});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherService _weatherService;
  late final bool _ownsService;

  CityLocation _selectedCity = CityLocation.presets.first;
  WeatherData? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ownsService = widget.weatherService == null;
    _weatherService = widget.weatherService ?? WeatherService();
    _loadWeather();
  }

  @override
  void dispose() {
    if (_ownsService) {
      _weatherService.dispose();
    }
    super.dispose();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _weatherService.fetchCurrentWeather(_selectedCity);
      if (!mounted) return;
      setState(() {
        _weather = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _selectCity(CityLocation city) {
    if (city.name == _selectedCity.name && _weather != null) return;
    setState(() {
      _selectedCity = city;
    });
    _loadWeather();
  }

  void _showCityPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121A2B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Kota',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...CityLocation.presets.map((city) {
                  final isSelected = city.name == _selectedCity.name;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: Icon(
                      Icons.location_city_rounded,
                      color: isSelected
                          ? const Color(0xFF6CA5F8)
                          : const Color(0xFF8C9BB8),
                    ),
                    title: Text(
                      city.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF6CA5F8),
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectCity(city);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cuaca Hari Ini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Material(
                    color: const Color(0xFF151E32),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _showCityPicker,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF25324D)),
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Color(0xFFDDE7F7),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildBody()),
              if (!_isLoading && _errorMessage == null && _weather != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _loadWeather,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text(
                      'Perbarui Data',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6CA5F8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return WeatherLoadingView(cityName: _selectedCity.name);
    }

    if (_errorMessage != null) {
      return WeatherErrorView(
        message: _errorMessage!,
        onRetry: _loadWeather,
      );
    }

    final weather = _weather;
    if (weather == null) {
      return WeatherErrorView(
        message: 'Data cuaca belum tersedia.',
        onRetry: _loadWeather,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWeather,
      color: const Color(0xFF6CA5F8),
      backgroundColor: const Color(0xFF151E32),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          WeatherHeroCard(weather: weather),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: WeatherMetricCard(
                  icon: Icons.water_drop_outlined,
                  label: 'Kelembapan',
                  value: '${weather.humidity}',
                  unit: '%',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: WeatherMetricCard(
                  icon: Icons.air_rounded,
                  label: 'Angin',
                  value: '${weather.windSpeed.round()}',
                  unit: 'km/j',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: WeatherMetricCard(
                  icon: Icons.thermostat_outlined,
                  label: 'Terasa Seperti',
                  value: '${weather.apparentTemperature.round()}',
                  unit: '°C',
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: WeatherMetricCard(
                  icon: Icons.speed_rounded,
                  label: 'Tekanan',
                  value: '${weather.surfacePressure.round()}',
                  unit: 'hPa',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          WeatherInfoBanner(message: weather.windAdvisory),
        ],
      ),
    );
  }
}
