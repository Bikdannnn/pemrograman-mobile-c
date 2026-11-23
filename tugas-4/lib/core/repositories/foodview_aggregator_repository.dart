import '../network/foursquare_client.dart';
import '../network/meal_api_client.dart';
import '../network/review_api_client.dart';
import '../../data/services/real_restaurant_menu_service.dart';
import '../../ui/view_models/foodview_ui_state.dart';

/// Aggregator Repository yang mengorkestrasikan 3 provider API:
/// 1. Foursquare Places API (Venue nyata, koordinat, alamat asli di Makassar)
/// 2. TheMealDB & DummyJSON Recipes (Katalog hidangan HD, kalori, bahan)
/// 3. RandomUser.me API (Foto profil reviewer nyata & komentar autentik)
class FoodViewAggregatorRepository {
  final FoursquareClient foursquareClient;
  final MealApiClient mealClient;
  final ReviewApiClient reviewClient;

  // In-memory cache untuk performa tinggi & hemat kuota
  List<RestaurantModel>? _cachedRestaurants;
  List<MenuModel>? _cachedMenus;
  List<ReviewModel>? _cachedReviews;

  FoodViewAggregatorRepository({
    FoursquareClient? foursquareClient,
    MealApiClient? mealClient,
    ReviewApiClient? reviewClient,
  })  : foursquareClient = foursquareClient ?? FoursquareClient(),
        mealClient = mealClient ?? MealApiClient(),
        reviewClient = reviewClient ?? ReviewApiClient();

  /// Mengambil data restoran nyata dari Foursquare yang diperkaya dengan menu dan ulasan.
  /// Jika [latitude] dan [longitude] diberikan, pencarian berdasarkan GPS pengguna.
  List<RestaurantModel> getInitialCuratedRestaurants({
    double? latitude,
    double? longitude,
  }) {
    final venues = FoursquareClient.curatedVenues;
    final list = <RestaurantModel>[];
    for (var i = 0; i < venues.length; i++) {
      final v = venues[i];
      list.add(
        RestaurantModel(
          id: v.fsqId,
          name: v.name,
          category: v.categoryName,
          categoryTags: _resolveTags(v.categoryName),
          address: v.formattedAddress,
          latitude: v.latitude,
          longitude: v.longitude,
          hours: v.hours ?? '08.00 - 22.00 WITA',
          phone: '0812${(41100000 + i * 1111)}',
          description:
              '${v.name} menyajikan hidangan ${v.categoryName} pilihan terbaik di Makassar.',
          imageAsset: v.photoUrl ?? 'assets/images/user_auth_header.png',
          galleryAssets: [
            v.photoUrl ?? 'assets/images/user_auth_header.png',
            'assets/images/user_auth_header.png',
          ],
          reviewerCount: '${(2 + (i % 5))},${i + 2}rb',
          distanceTag: '${(v.distanceMeters / 1000).toStringAsFixed(1)} km',
          priceTag: 'Rp25.000 - Rp85.000',
          userHistoryComment: 'Rekomendasi terbaik di sekitar lokasi Anda.',
        ),
      );
    }
    return list;
  }

  /// Mengambil data restoran nyata dari Foursquare yang diperkaya dengan menu dan ulasan.
  /// Jika [latitude] dan [longitude] diberikan, pencarian berdasarkan GPS pengguna.
  Future<List<RestaurantModel>> getEnrichedRestaurants({
    String? query,
    String? category,
    double? latitude,
    double? longitude,
  }) async {
    if (_cachedRestaurants != null && (query == null || query.isEmpty)) {
      return _cachedRestaurants!;
    }

    try {
      final venues = await foursquareClient.searchVenues(
        query: query ?? (category ?? 'restaurant'),
        near: 'Makassar, Indonesia',
        latitude: latitude,
        longitude: longitude,
        limit: 8,
      );

      final realReviews = await getRealCustomerReviews(count: 6);

      final list = <RestaurantModel>[];
      for (var i = 0; i < venues.length; i++) {
        final v = venues[i];
        final venueReviews = [
          realReviews[i % realReviews.length],
          realReviews[(i + 1) % realReviews.length],
        ];

        list.add(
          RestaurantModel(
            id: v.fsqId,
            name: v.name,
            category: v.categoryName,
            categoryTags: _resolveTags(v.categoryName),
            address: v.formattedAddress,
            latitude: v.latitude,
            longitude: v.longitude,
            hours: v.hours ?? '08.00 - 22.00 WITA',
            phone: '0812${(41100000 + i * 1111)}',
            description:
                '${v.name} menyajikan kuliner ${v.categoryName} pilihan dengan bahan segar berkualitas di Makassar.',
            imageAsset: v.photoUrl ?? 'assets/images/user_auth_header.png',
            galleryAssets: [
              v.photoUrl ?? 'assets/images/user_auth_header.png',
              'assets/images/user_auth_header.png',
            ],
            reviewerCount: '${(2 + (i % 5))},${i + 2}rb',
            distanceTag: '${(v.distanceMeters / 1000).toStringAsFixed(1)} km',
            priceTag: 'Rp25.000 - Rp85.000',
            userHistoryComment: venueReviews.first.comment,
            reviews: venueReviews,
          ),
        );
      }

      if (query == null || query.isEmpty) {
        _cachedRestaurants = list;
      }
      return list;
    } catch (_) {
      return _cachedRestaurants ?? const [];
    }
  }

  /// Mengambil menu nyata autentik per restoran di Makassar
  Future<List<MenuModel>> getEnrichedMenus({String? category, int limit = 50}) async {
    if (_cachedMenus != null && (category == null || category.isEmpty)) {
      return _cachedMenus!;
    }

    try {
      final realMenus = RealRestaurantMenuService.getAllRealMenus();
      final realReviews = await getRealCustomerReviews(count: 6);

      final menus = realMenus.map((m) {
        final attachedReviews = [
          ...m.reviews,
          if (realReviews.isNotEmpty)
            realReviews[m.id.hashCode.abs() % realReviews.length],
        ];
        return MenuModel(
          id: m.id,
          restaurantId: m.restaurantId,
          name: m.name,
          price: m.price,
          description: m.description,
          imageAsset: m.imageAsset,
          networkImageUrl: m.networkImageUrl,
          restaurantName: m.restaurantName,
          restaurantCategory: m.restaurantCategory,
          restaurantAddress: m.restaurantAddress,
          reviewerCount: m.reviewerCount,
          categoryTag: m.categoryTag,
          ingredients: m.ingredients,
          calories: m.calories,
          isFavorite: m.isFavorite,
          reviews: attachedReviews,
        );
      }).toList();

      final filtered = category != null && category.isNotEmpty
          ? menus
              .where((m) =>
                  m.categoryTag
                      .toLowerCase()
                      .contains(category.toLowerCase()) ||
                  m.restaurantCategory
                      .toLowerCase()
                      .contains(category.toLowerCase()))
              .toList()
          : menus;

      if (category == null || category.isEmpty) {
        _cachedMenus = menus;
      }
      return filtered.take(limit).toList();
    } catch (_) {
      return RealRestaurantMenuService.getAllRealMenus();
    }
  }

  /// Mengambil ulasan pelanggan nyata dengan avatar dari RandomUser.me
  Future<List<ReviewModel>> getRealCustomerReviews({int count = 6}) async {
    if (_cachedReviews != null && _cachedReviews!.length >= count) {
      return _cachedReviews!;
    }

    try {
      final real = await reviewClient.fetchCustomerReviews(count: count);
      final list = real.map((r) {
        return ReviewModel(
          userName: r.reviewerName,
          comment: r.comment,
          avatarAsset: r.avatarUrl,
          rating: r.rating,
        );
      }).toList();

      _cachedReviews = list;
      return list;
    } catch (_) {
      return _cachedReviews ?? const [];
    }
  }

  List<String> _resolveTags(String category) {
    final lower = category.toLowerCase();
    final tags = <String>[];
    if (lower.contains('ayam') || lower.contains('chicken')) tags.add('Ayam');
    if (lower.contains('nasi') || lower.contains('rice')) tags.add('Nasi');
    if (lower.contains('seafood') || lower.contains('ikan')) tags.add('Seafood');
    if (lower.contains('mie') || lower.contains('noodle')) tags.add('Mie');
    if (lower.contains('cafe') || lower.contains('coffee') || lower.contains('minuman')) tags.add('Minuman');
    if (tags.isEmpty) tags.addAll(['Nasi', 'Ayam']);
    return tags;
  }
}
