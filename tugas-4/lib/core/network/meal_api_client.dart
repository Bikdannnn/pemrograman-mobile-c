import 'dart:convert';
import 'package:http/http.dart' as http;

/// Data model untuk hidangan dari TheMealDB & DummyJSON Recipes API
class MealRecipeItem {
  final String id;
  final String name;
  final String category;
  final String cuisine;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;
  final int calories;
  final int prepTimeMinutes;
  final double rating;
  final String priceFormatted;

  const MealRecipeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.cuisine,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    this.calories = 400,
    this.prepTimeMinutes = 20,
    this.rating = 4.8,
    required this.priceFormatted,
  });
}

/// Client HTTP untuk TheMealDB dan DummyJSON Recipes API
class MealApiClient {
  final http.Client _client;

  MealApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil resep/menu berdasarkan kategori FoodView (Nasi, Ayam, Seafood, Mie, Minuman)
  Future<List<MealRecipeItem>> fetchMealsByCategory(
    String category, {
    int limit = 10,
  }) async {
    final query = _mapCategoryToSearchTerm(category);
    return fetchRecipes(query: query, limit: limit);
  }

  /// Mengambil daftar resep dari DummyJSON Recipes dengan fallback TheMealDB
  Future<List<MealRecipeItem>> fetchRecipes({
    String query = '',
    int limit = 12,
  }) async {
    try {
      final cleanQuery = query.trim();
      final uri = cleanQuery.isEmpty
          ? Uri.parse('https://dummyjson.com/recipes?limit=$limit')
          : Uri.parse(
              'https://dummyjson.com/recipes/search?q=${Uri.encodeComponent(cleanQuery)}',
            );

      final response = await _client.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final recipes = (decoded['recipes'] as List<dynamic>?) ?? [];
        if (recipes.isNotEmpty) {
          return recipes.take(limit).map((raw) {
            final map = raw as Map<String, dynamic>;
            final id = 'recipe_${map['id']}';
            final name = (map['name'] as String?) ?? 'Menu Lezat';
            final cuisine = (map['cuisine'] as String?) ?? 'Asian';
            final mealTypes = (map['mealType'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Main Course'];
            final calories = (map['caloriesPerServing'] as num?)?.toInt() ?? 420;
            final prep = (map['prepTimeMinutes'] as num?)?.toInt() ?? 20;
            final rating = (map['rating'] as num?)?.toDouble() ?? 4.8;
            final ingredients = (map['ingredients'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final instructionsList = (map['instructions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
            final priceNum = ((calories.clamp(200, 750) ~/ 10) * 1000);

            return MealRecipeItem(
              id: id,
              name: name,
              category: mealTypes.first,
              cuisine: cuisine,
              imageUrl: (map['image'] as String?) ?? '',
              instructions: instructionsList.join(' '),
              ingredients: ingredients,
              calories: calories,
              prepTimeMinutes: prep,
              rating: rating,
              priceFormatted: 'Rp${_formatThousands(priceNum)}',
            );
          }).toList();
        }
      }

      // Fallback ke TheMealDB Open API
      final mealSearch = cleanQuery.isEmpty ? 'chicken' : cleanQuery;
      final mealUri = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(mealSearch)}',
      );
      final mealResp = await _client.get(mealUri).timeout(const Duration(seconds: 8));
      if (mealResp.statusCode == 200) {
        final decoded = json.decode(mealResp.body) as Map<String, dynamic>;
        final meals = (decoded['meals'] as List<dynamic>?) ?? [];
        if (meals.isNotEmpty) {
          return meals.take(limit).map((raw) {
            final jsonMap = raw as Map<String, dynamic>;
            final ingredients = <String>[];
            for (var i = 1; i <= 6; i++) {
              final ing = (jsonMap['strIngredient$i'] as String?)?.trim() ?? '';
              if (ing.isNotEmpty) ingredients.add(ing);
            }
            return MealRecipeItem(
              id: (jsonMap['idMeal'] as String?) ?? 'meal_${DateTime.now().millisecondsSinceEpoch}',
              name: (jsonMap['strMeal'] as String?) ?? 'Menu Pilihan',
              category: (jsonMap['strCategory'] as String?) ?? 'Makanan',
              cuisine: (jsonMap['strArea'] as String?) ?? 'Nusantara',
              imageUrl: (jsonMap['strMealThumb'] as String?) ?? '',
              instructions: (jsonMap['strInstructions'] as String?) ?? '',
              ingredients: ingredients,
              calories: 450,
              prepTimeMinutes: 25,
              rating: 4.9,
              priceFormatted: 'Rp32.000',
            );
          }).toList();
        }
      }
    } catch (_) {
      // Fallback lokal jika offline
    }

    return _fallbackMeals.take(limit).toList();
  }

  String _mapCategoryToSearchTerm(String category) {
    switch (category.toLowerCase()) {
      case 'ayam':
        return 'chicken';
      case 'seafood':
        return 'salmon';
      case 'mie':
        return 'pasta';
      case 'nasi':
        return 'rice';
      case 'minuman':
        return 'smoothie';
      default:
        return category;
    }
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

  static const List<MealRecipeItem> _fallbackMeals = [
    MealRecipeItem(
      id: 'fallback_01',
      name: 'Ayam Bakar Madu Spesial',
      category: 'Ayam',
      cuisine: 'Indonesian',
      imageUrl: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=600&auto=format&fit=crop&q=80',
      instructions: 'Ayam bakar dengan bumbu kecap madu khas nusantara yang gurih manis.',
      ingredients: ['Ayam Kampung', 'Madu Hutan', 'Kecap Manis', 'Bawang Merah', 'Cabai Rawit'],
      calories: 480,
      prepTimeMinutes: 30,
      rating: 4.9,
      priceFormatted: 'Rp38.000',
    ),
    MealRecipeItem(
      id: 'fallback_02',
      name: 'Nasi Goreng Seafood Spesial',
      category: 'Seafood',
      cuisine: 'Indonesian',
      imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600&auto=format&fit=crop&q=80',
      instructions: 'Nasi goreng harum dengan udang segar, cumi, dan telur mata sapi.',
      ingredients: ['Nasi Putih', 'Udang Segar', 'Cumi', 'Telur', 'Bumbu Rempah'],
      calories: 520,
      prepTimeMinutes: 20,
      rating: 4.8,
      priceFormatted: 'Rp35.000',
    ),
  ];
}
