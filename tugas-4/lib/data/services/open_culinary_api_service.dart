import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model Hidangan dari Open-Source API (TheMealDB & DummyJSON Recipes)
class OpenApiDishModel {
  final String id;
  final String name;
  final String category;
  final String areaOrCuisine;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;
  final int caloriesPerServing;
  final int prepTimeMinutes;
  final double rating;
  final int reviewCount;
  final String estimatedPrice;

  const OpenApiDishModel({
    required this.id,
    required this.name,
    required this.category,
    required this.areaOrCuisine,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    this.caloriesPerServing = 420,
    this.prepTimeMinutes = 20,
    this.rating = 4.9,
    this.reviewCount = 128,
    this.estimatedPrice = 'Rp35.000',
  });

  /// Deserialisasi menggunakan Dart 3 Map Pattern Matching dari DummyJSON Recipes API
  factory OpenApiDishModel.fromDummyJson(Map<String, dynamic> json) {
    final id = switch (json['id']) {
      final int i => 'recipe_$i',
      final String s => s,
      _ => 'recipe_0',
    };
    final name = (json['name'] as String?) ?? 'Menu Spesial';
    final cuisine = (json['cuisine'] as String?) ?? 'Internasional';
    final mealTypes = (json['mealType'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const ['Main Course'];
    final ingredients = (json['ingredients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];
    final instructionsList = (json['instructions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];
    final calories = (json['caloriesPerServing'] as num?)?.toInt() ?? 380;
    final prep = (json['prepTimeMinutes'] as num?)?.toInt() ?? 20;
    final rating = (json['rating'] as num?)?.toDouble() ?? 4.8;
    final reviews = (json['reviewCount'] as num?)?.toInt() ?? 95;
    final priceNum = ((calories.clamp(200, 800) ~/ 10) * 1000);

    return OpenApiDishModel(
      id: id,
      name: name,
      category: mealTypes.first,
      areaOrCuisine: cuisine,
      imageUrl: (json['image'] as String?) ?? '',
      instructions: instructionsList.join(' '),
      ingredients: ingredients,
      caloriesPerServing: calories,
      prepTimeMinutes: prep,
      rating: rating,
      reviewCount: reviews,
      estimatedPrice: 'Rp${_formatThousands(priceNum)}',
    );
  }

  /// Deserialisasi dari TheMealDB Open API
  factory OpenApiDishModel.fromMealDb(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (var i = 1; i <= 8; i++) {
      final ing = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (ing.isNotEmpty) {
        ingredients.add(measure.isNotEmpty ? '$ing ($measure)' : ing);
      }
    }

    return OpenApiDishModel(
      id: (json['idMeal'] as String?) ?? 'meal_0',
      name: (json['strMeal'] as String?) ?? 'Hidangan Spesial',
      category: (json['strCategory'] as String?) ?? 'Kuliner',
      areaOrCuisine: (json['strArea'] as String?) ?? 'Nusantara',
      imageUrl: (json['strMealThumb'] as String?) ?? '',
      instructions: (json['strInstructions'] as String?) ?? '',
      ingredients: ingredients,
      caloriesPerServing: 450,
      prepTimeMinutes: 25,
      rating: 4.9,
      reviewCount: 210,
      estimatedPrice: 'Rp32.000',
    );
  }

  static String _formatThousands(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

/// Model Cuaca & Rekomendasi Kuliner Kontekstual dari Open-Meteo API
class CulinaryWeatherContext {
  final double temperatureC;
  final int weatherCode;
  final String conditionLabel;
  final String culinaryTip;
  final String recommendedCategory;

  const CulinaryWeatherContext({
    required this.temperatureC,
    required this.weatherCode,
    required this.conditionLabel,
    required this.culinaryTip,
    required this.recommendedCategory,
  });
}

/// Model Lokasi hasil Geocoding OpenStreetMap Nominatim API
class OsmPlaceResult {
  final String displayName;
  final double latitude;
  final double longitude;

  const OsmPlaceResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });
}

/// Service yang mengintegrasikan 3 Open-Source REST API tanpa API key berbayar:
/// 1. DummyJSON Recipes & TheMealDB Open API (Katalog Kuliner, Kalori, Resep & Bahan)
/// 2. Open-Meteo Weather API (Rekomendasi Kuliner berdasarkan cuaca Makassar real-time)
/// 3. OpenStreetMap Nominatim Geocoding API (Pencarian Koordinat & Alamat Restoran)
class OpenCulinaryApiService {
  final http.Client _client;

  OpenCulinaryApiService({http.Client? client})
      : _client = client ?? http.Client();

  /// Mengambil daftar hidangan dari Open-Source API (DummyJSON Recipes & TheMealDB fallback).
  Future<List<OpenApiDishModel>> fetchOpenApiDishes({String query = ''}) async {
    try {
      final cleanQuery = query.trim();
      final uri = cleanQuery.isEmpty
          ? Uri.parse('https://dummyjson.com/recipes?limit=12')
          : Uri.parse(
              'https://dummyjson.com/recipes/search?q=${Uri.encodeComponent(cleanQuery)}',
            );

      final response =
          await _client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final recipes = (decoded['recipes'] as List<dynamic>?) ?? [];
        if (recipes.isNotEmpty) {
          return recipes
              .whereType<Map<String, dynamic>>()
              .map(OpenApiDishModel.fromDummyJson)
              .toList();
        }
      }

      // Fallback ke TheMealDB Open API
      final mealUri = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(cleanQuery.isEmpty ? "chicken" : cleanQuery)}',
      );
      final mealResp =
          await _client.get(mealUri).timeout(const Duration(seconds: 8));
      if (mealResp.statusCode == 200) {
        final decoded = json.decode(mealResp.body) as Map<String, dynamic>;
        final meals = (decoded['meals'] as List<dynamic>?) ?? [];
        return meals
            .whereType<Map<String, dynamic>>()
            .map(OpenApiDishModel.fromMealDb)
            .toList();
      }
    } catch (_) {
      // Gunakan fallback lokal jika perangkat sedang offline
    }
    return _offlineFallbackDishes;
  }

  /// Mengambil cuaca Makassar saat ini dari Open-Meteo API untuk rekomendasi kuliner cerdas.
  Future<CulinaryWeatherContext> fetchMakassarCulinaryWeather() async {
    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=-5.1486&longitude=119.4319'
        '&current=temperature_2m,weather_code&timezone=auto',
      );
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 7));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final current = data['current'] as Map<String, dynamic>? ?? {};
        final temp = (current['temperature_2m'] as num?)?.toDouble() ?? 30.0;
        final code = (current['weather_code'] as num?)?.toInt() ?? 1;

        return switch (code) {
          >= 51 => CulinaryWeatherContext(
              temperatureC: temp,
              weatherCode: code,
              conditionLabel: 'Hujan di Makassar (${temp.toStringAsFixed(1)}°C)',
              culinaryTip:
                  'Cuaca sedang hujan, paling pas menikmati Mie kuah hangat, Bakso Goreng, atau Dimsum Soup!',
              recommendedCategory: 'Mie',
            ),
          _ when temp >= 30.0 => CulinaryWeatherContext(
              temperatureC: temp,
              weatherCode: code,
              conditionLabel: 'Cerah Hangat (${temp.toStringAsFixed(1)}°C)',
              culinaryTip:
                  'Cuaca Makassar cukup terik, segarkan harimu dengan kategori Minuman dingin & Dessert!',
              recommendedCategory: 'Minuman',
            ),
          _ => CulinaryWeatherContext(
              temperatureC: temp,
              weatherCode: code,
              conditionLabel: 'Cerah Berawan (${temp.toStringAsFixed(1)}°C)',
              culinaryTip:
                  'Waktu terbaik menjelajahi kuliner Ayam Goreng Rica & Seafood segar di sekitar Makassar!',
              recommendedCategory: 'Ayam',
            ),
        };
      }
    } catch (_) {
      // Fallback jika offline
    }
    return const CulinaryWeatherContext(
      temperatureC: 29.5,
      weatherCode: 1,
      conditionLabel: 'Makassar • 29.5°C',
      culinaryTip:
          'Rekomendasi hari ini: Cicipi Ayam Goreng Rica & aneka kuliner favorit Makassar!',
      recommendedCategory: 'Ayam',
    );
  }

  /// Mencari koordinat alamat restoran menggunakan OpenStreetMap Nominatim API.
  Future<List<OsmPlaceResult>> searchAddressOnOsm(String query) async {
    if (query.trim().isEmpty) return const [];
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent("${query.trim()} Makassar")}'
        '&format=json&limit=4',
      );
      final response = await _client.get(
        uri,
        headers: const {'User-Agent': 'FoodViewMobileApp/1.0'},
      ).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final list = json.decode(response.body) as List<dynamic>;
        return list.whereType<Map<String, dynamic>>().map((item) {
          return OsmPlaceResult(
            displayName: (item['display_name'] as String?) ?? query,
            latitude:
                double.tryParse(item['lat']?.toString() ?? '') ?? -5.1486,
            longitude:
                double.tryParse(item['lon']?.toString() ?? '') ?? 119.4319,
          );
        }).toList();
      }
    } catch (_) {}
    return const [
      OsmPlaceResult(
        displayName: 'Jl. Samata, Borong Indah, Gowa/Makassar',
        latitude: -5.2035,
        longitude: 119.4932,
      ),
    ];
  }

  static const List<OpenApiDishModel> _offlineFallbackDishes = [
    OpenApiDishModel(
      id: 'fallback_1',
      name: 'Chicken Teriyaki Rice Bowl',
      category: 'Nasi',
      areaOrCuisine: 'Asian',
      imageUrl: '',
      instructions:
          'Ayam panggang saus teriyaki manis gurih disajikan di atas nasi hangat dengan taburan wijen.',
      ingredients: ['Dada Ayam', 'Saus Teriyaki', 'Nasi Putih', 'Wijen', 'Brokoli'],
      caloriesPerServing: 460,
      prepTimeMinutes: 20,
      rating: 4.9,
      reviewCount: 340,
      estimatedPrice: 'Rp35.000',
    ),
    OpenApiDishModel(
      id: 'fallback_2',
      name: 'Spicy Garlic Butter Shrimp',
      category: 'Seafood',
      areaOrCuisine: 'Mediterranean',
      imageUrl: '',
      instructions:
          'Udang segar dimasak dengan mentega bawang putih, cabai merah, dan perasan lemon.',
      ingredients: ['Udang Segar', 'Mentega', 'Bawang Putih', 'Lemon', 'Cabai'],
      caloriesPerServing: 390,
      prepTimeMinutes: 15,
      rating: 4.8,
      reviewCount: 215,
      estimatedPrice: 'Rp55.000',
    ),
  ];
}
