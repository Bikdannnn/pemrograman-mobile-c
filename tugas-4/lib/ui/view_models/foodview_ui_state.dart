import 'package:flutter/material.dart';
import '../../core/advanced_dart/api_state.dart';
import '../../core/repositories/foodview_aggregator_repository.dart';
import '../../data/services/firebase_hybrid_service.dart';
import '../../data/services/location_service.dart';
import '../../data/services/open_culinary_api_service.dart';

enum AppActiveRole { user, pemilikRestoran }

class MenuModel {
  final String id;
  final String restaurantId;
  String name;
  String price;
  String description;
  String imageAsset;
  final String? networkImageUrl;
  String fileName;
  final String restaurantName;
  final String restaurantCategory;
  final String restaurantAddress;
  final String reviewerCount;
  final String categoryTag;
  final List<String> ingredients;
  final int calories;
  bool isFavorite;
  final List<ReviewModel> reviews;

  MenuModel({
    required this.id,
    this.restaurantId = 'r_buatik',
    required this.name,
    required this.price,
    required this.description,
    required this.imageAsset,
    this.networkImageUrl,
    this.fileName = 'ayam-goreng-rica.jpg',
    this.restaurantName = 'Warung Bu Atik',
    this.restaurantCategory = 'Ayam, Aneka Nasi, Cepat Saji',
    this.restaurantAddress = 'Jl. Samata, Borong Indah, Makassar',
    this.reviewerCount = '4,1rb',
    this.categoryTag = 'Nasi',
    this.ingredients = const [],
    this.calories = 420,
    this.isFavorite = false,
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];
}

class RestaurantModel {
  final String id;
  final String name;
  final String category;
  final List<String> categoryTags;
  final String address;
  final double latitude;
  final double longitude;
  final String hours;
  final String phone;
  final String description;
  final String imageAsset;
  final List<String> galleryAssets;
  final String reviewerCount;
  String distanceTag;
  final String priceTag;
  final bool is24Hours;
  final String userHistoryComment;
  bool isFavorite;
  final List<ReviewModel> reviews;
  double? distanceFromUser; // Jarak dari lokasi pengguna (meter)

  RestaurantModel({
    required this.id,
    required this.name,
    required this.category,
    this.categoryTags = const ['Nasi', 'Ayam'],
    required this.address,
    this.latitude = -5.1636,
    this.longitude = 119.4362,
    this.hours = '08.00 - 22.30 WITA',
    this.phone = '081231492034',
    required this.description,
    required this.imageAsset,
    required this.galleryAssets,
    this.reviewerCount = '3rb',
    this.distanceTag = '1-2 km',
    this.priceTag = 'Rp25.000 - Rp100.000',
    this.is24Hours = false,
    this.userHistoryComment =
        'Tempat makan paling nyaman, semua pelayan ramah dan makanannya enak-enak',
    this.isFavorite = false,
    this.distanceFromUser,
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];
}

/// Model review yang siap Firebase (field opsional untuk Firestore)
class ReviewModel {
  final String userName;
  final String comment;
  final String avatarAsset;
  final double rating;
  final String? firestoreId; // ID dokumen Firestore (diisi saat sync)
  final DateTime? createdAt; // Timestamp untuk Firestore

  const ReviewModel({
    required this.userName,
    required this.comment,
    required this.avatarAsset,
    this.rating = 5.0,
    this.firestoreId,
    this.createdAt,
  });
}

class OwnerNotificationModel {
  final String menuName;
  final String userName;
  final int stars;
  final String avatarAsset;

  const OwnerNotificationModel({
    required this.menuName,
    required this.userName,
    this.stars = 5,
    required this.avatarAsset,
  });
}

/// ViewModel utama (Provider State Management) yang menghubungkan:
/// - Seluruh tampilan & interaksi `USER` dan `PEMILIK RESTORAN`
/// - Integrasi 3 Open-Source REST API (`OpenCulinaryApiService`) dengan `sealed class ApiState<T>`
/// - Integrasi Firebase & Push Notifications (`FirebaseHybridService`)
/// - GPS Lokasi untuk menampilkan restoran terdekat
class FoodViewUiState extends ChangeNotifier {
  final OpenCulinaryApiService _openApiService = OpenCulinaryApiService();
  final FirebaseHybridService _firebaseService = FirebaseHybridService.instance;
  final FoodViewAggregatorRepository _aggregatorRepo = FoodViewAggregatorRepository();
  final LocationService _locationService = LocationService.instance;

  FoodViewAggregatorRepository get aggregatorRepository => _aggregatorRepo;

  bool _isLoadingAggregator = false;
  bool get isLoadingAggregator => _isLoadingAggregator;

  String? _aggregatorError;
  String? get aggregatorError => _aggregatorError;

  // Lokasi pengguna saat ini
  double? _userLatitude;
  double? _userLongitude;
  double? get userLatitude => _userLatitude;
  double? get userLongitude => _userLongitude;

  FoodViewUiState() {
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _firebaseService.initialize();

    // Dapatkan lokasi pengguna terlebih dahulu
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      _userLatitude = position.latitude;
      _userLongitude = position.longitude;
    }

    await Future.wait([
      loadOpenApiDishes(),
      loadWeatherRecommendation(),
      fetchAggregatedMultiApiData(),
    ]);
  }

  /// Multi-API Orchestration: Menarik data riil gabungan dari Foursquare, TheMealDB, dan RandomUser
  Future<void> fetchAggregatedMultiApiData() async {
    _isLoadingAggregator = true;
    _aggregatorError = null;
    notifyListeners();
    try {
      final enrichedVenues = await _aggregatorRepo.getEnrichedRestaurants(
        latitude: _userLatitude,
        longitude: _userLongitude,
      );
      if (enrichedVenues.isNotEmpty) {
        // Hitung jarak dan sort berdasarkan kedekatan
        for (final venue in enrichedVenues) {
          if (_userLatitude != null && _userLongitude != null) {
            venue.distanceFromUser = LocationService.calculateDistanceMeters(
              _userLatitude!,
              _userLongitude!,
              venue.latitude,
              venue.longitude,
            );
            venue.distanceTag = LocationService.distanceTag(
              venue.distanceFromUser!,
            );
          }
          final idx = restaurants.indexWhere((r) => r.id == venue.id);
          if (idx >= 0) {
            restaurants[idx] = venue;
          } else {
            restaurants.add(venue);
          }
        }
        // Sort restoran berdasarkan jarak terdekat
        restaurants.sort((a, b) {
          final da = a.distanceFromUser ?? double.infinity;
          final db = b.distanceFromUser ?? double.infinity;
          return da.compareTo(db);
        });
      }
      final enrichedMenus = await _aggregatorRepo.getEnrichedMenus();
      if (enrichedMenus.isNotEmpty) {
        for (final m in enrichedMenus) {
          final idx = menus.indexWhere((existing) => existing.id == m.id);
          if (idx >= 0) {
            menus[idx] = m;
          } else {
            menus.add(m);
          }
        }
      }
    } catch (e) {
      _aggregatorError = e.toString();
    } finally {
      _isLoadingAggregator = false;
      notifyListeners();
    }
  }

  AppActiveRole _activeRole = AppActiveRole.user;
  AppActiveRole get activeRole => _activeRole;

  bool _isUserLoggedIn = true;
  bool get isUserLoggedIn => _isUserLoggedIn;

  bool _isOwnerLoggedIn = true;
  bool get isOwnerLoggedIn => _isOwnerLoggedIn;

  String userDisplayName = 'Gibran Nur Saleh';
  String userHandle = '@gibnurshl';
  String ownerRestaurantName = 'Warung Bu Atik';
  String ownerRestaurantAddress = 'Jl. Samata, Borong Indah, Makassar';
  String ownerRestaurantBio =
      'Warung Bu Atik adalah tempat makan khas rumahan yang menyajikan cita rasa autentik Nusantara, '
      'dengan spesialisasi masakan ayam. Didirikan dengan semangat menjaga warisan kuliner Indonesia...';

  // State Open-Source API menggunakan Sealed Class `ApiState<T>` (Advance Dart)
  ApiState<List<OpenApiDishModel>> _openDishesState = const ApiInitial();
  ApiState<List<OpenApiDishModel>> get openDishesState => _openDishesState;

  CulinaryWeatherContext? _weatherContext;
  CulinaryWeatherContext? get weatherContext => _weatherContext;

  Future<void> loadOpenApiDishes({String query = ''}) async {
    _openDishesState = const ApiLoading('Memuat inspirasi kuliner Open API...');
    notifyListeners();
    try {
      final list = await _openApiService.fetchOpenApiDishes(query: query);
      _openDishesState = ApiSuccess(list);
    } catch (e) {
      _openDishesState = ApiError('Gagal memuat data Open API: $e');
    }
    notifyListeners();
  }

  Future<void> loadWeatherRecommendation() async {
    _weatherContext = await _openApiService.fetchMakassarCulinaryWeather();
    notifyListeners();
  }

  Future<List<OsmPlaceResult>> searchAddressOnOsm(String query) {
    return _openApiService.searchAddressOnOsm(query);
  }

  void setRole(AppActiveRole role) {
    _activeRole = role;
    notifyListeners();
  }

  void loginUser({String? email, String? name, String? username}) {
    _isUserLoggedIn = true;
    if (name != null && name.trim().isNotEmpty) {
      userDisplayName = name.trim();
    }
    if (username != null && username.trim().isNotEmpty) {
      userHandle = username.startsWith('@') ? username : '@$username';
    }
    _activeRole = AppActiveRole.user;
    if (email != null) {
      _firebaseService.signInWithEmail(email, '12345678');
    }
    _firebaseService.triggerPushNotification(
      title: 'Selamat Datang, $userDisplayName!',
      body: 'Berhasil masuk sebagai Pengguna FoodView.',
    );
    notifyListeners();
  }

  void logoutUser() {
    _isUserLoggedIn = false;
    notifyListeners();
  }

  void loginOwner({String? restaurantName, String? address, String? email}) {
    _isOwnerLoggedIn = true;
    if (restaurantName != null && restaurantName.trim().isNotEmpty) {
      ownerRestaurantName = restaurantName.trim();
    }
    if (address != null && address.trim().isNotEmpty) {
      ownerRestaurantAddress = address.trim();
    }
    _activeRole = AppActiveRole.pemilikRestoran;
    if (email != null) {
      _firebaseService.signInWithEmail(email, '12345678');
    }
    _firebaseService.triggerPushNotification(
      title: 'Dashboard $ownerRestaurantName Aktif',
      body: 'Selamat datang di panel manajemen Pemilik Restoran.',
    );
    notifyListeners();
  }

  void logoutOwner() {
    _isOwnerLoggedIn = false;
    notifyListeners();
  }

  // Banner Carousel di Beranda User (3 foto persis dari USER.svg)
  final List<String> homeBannerAssets = const [
    'assets/images/u_us_9.png',
    'assets/images/u_us_10.png',
    'assets/images/u_us_13.png',
  ];

  // Data restoran dan menu dimuat secara dinamis dari API (tidak ada dummy lagi)
  List<MenuModel> menus = [];
  List<RestaurantModel> restaurants = [];

  /// Mengambil daftar menu spesifik untuk masing-masing restoran.
  /// Menu dicocokkan berdasarkan restaurantId, atau generate menu dari API
  /// berdasarkan kategori restoran.
  List<MenuModel> getMenusForRestaurant(RestaurantModel restaurant) {
    final matched = menus.where((m) => m.restaurantId == restaurant.id).toList();
    if (matched.isNotEmpty) return matched;

    // Fallback: tampilkan menu dari API yang cocok kategorinya
    final tags = restaurant.categoryTags;
    final fallback = menus.where((m) {
      return tags.any(
        (tag) =>
            m.categoryTag.toLowerCase().contains(tag.toLowerCase()) ||
            m.restaurantCategory.toLowerCase().contains(tag.toLowerCase()),
      );
    }).take(6).toList();
    if (fallback.isNotEmpty) return fallback;

    // Jika masih kosong, tampilkan 6 menu pertama yang tersedia
    return menus.take(6).toList();
  }

  // Daftar Notifikasi Pemilik Restoran
  final List<OwnerNotificationModel> ownerNotifications = [
    const OwnerNotificationModel(
      menuName: 'Ayam Goreng Sambal Matah',
      userName: 'Gibran Nur Saleh',
      stars: 5,
      avatarAsset: 'assets/images/u_pm_0.png',
    ),
    const OwnerNotificationModel(
      menuName: 'Nasi Goreng Jakarta',
      userName: 'R03L0v1s900D',
      stars: 5,
      avatarAsset: 'assets/images/u_pm_7.png',
    ),
    const OwnerNotificationModel(
      menuName: 'Kwetiau Goreng',
      userName: 'Jungkuk99Gamerzx',
      stars: 5,
      avatarAsset: 'assets/images/u_pm_4.png',
    ),
    const OwnerNotificationModel(
      menuName: 'Capcay Kuah',
      userName: 'Gymbro1234567',
      stars: 5,
      avatarAsset: 'assets/images/u_pm_8.png',
    ),
  ];

  void toggleRestaurantFavorite(String restaurantId) {
    final idx = restaurants.indexWhere((r) => r.id == restaurantId);
    if (idx != -1) {
      restaurants[idx].isFavorite = !restaurants[idx].isFavorite;
      notifyListeners();
    }
  }

  void toggleMenuFavorite(String menuId) {
    final idx = menus.indexWhere((m) => m.id == menuId);
    if (idx != -1) {
      menus[idx].isFavorite = !menus[idx].isFavorite;
      notifyListeners();
    }
  }

  /// Menambahkan review ke restoran (siap Firebase — data disimpan lokal + sync ke Firestore)
  void addRestaurantReview(String restaurantId, int stars, String comment) {
    final idx = restaurants.indexWhere((r) => r.id == restaurantId);
    if (idx != -1) {
      restaurants[idx].reviews.insert(
            0,
            ReviewModel(
              userName: userDisplayName,
              comment: comment,
              avatarAsset: 'assets/images/u_pm_0.png',
              rating: stars.toDouble(),
              createdAt: DateTime.now(),
            ),
          );
      ownerNotifications.insert(
        0,
        OwnerNotificationModel(
          menuName: restaurants[idx].name,
          userName: userDisplayName,
          stars: stars,
          avatarAsset: 'assets/images/u_pm_0.png',
        ),
      );
      _firebaseService.syncReviewToFirestore(
        targetId: restaurantId,
        userName: userDisplayName,
        comment: comment,
        stars: stars,
      );
      _firebaseService.triggerPushNotification(
        title: 'Ulasan Baru untuk ${restaurants[idx].name}',
        body: '$userDisplayName memberi $stars bintang: "$comment"',
      );
      notifyListeners();
    }
  }

  /// Menambahkan review ke menu (siap Firebase)
  void addMenuReview(String menuId, int stars, String comment) {
    final idx = menus.indexWhere((m) => m.id == menuId);
    if (idx != -1) {
      menus[idx].reviews.insert(
            0,
            ReviewModel(
              userName: userDisplayName,
              comment: comment,
              avatarAsset: 'assets/images/u_pm_0.png',
              rating: stars.toDouble(),
              createdAt: DateTime.now(),
            ),
          );
      ownerNotifications.insert(
        0,
        OwnerNotificationModel(
          menuName: menus[idx].name,
          userName: userDisplayName,
          stars: stars,
          avatarAsset: 'assets/images/u_pm_0.png',
        ),
      );
      _firebaseService.syncReviewToFirestore(
        targetId: menuId,
        userName: userDisplayName,
        comment: comment,
        stars: stars,
      );
      _firebaseService.triggerPushNotification(
        title: 'Ulasan Menu: ${menus[idx].name}',
        body: '$userDisplayName memberi $stars bintang!',
      );
      notifyListeners();
    }
  }

  /// Konversi hidangan dari Open-Source API menjadi `MenuModel` agar dapat dibuka
  /// di halaman Detail Menu maupun diimport ke daftar menu Pemilik Restoran!
  MenuModel convertOpenApiDishToMenuModel(OpenApiDishModel apiDish) {
    final existing = menus.where((m) => m.id == 'api_${apiDish.id}');
    if (existing.isNotEmpty) return existing.first;

    final fallbackAsset = switch (apiDish.category.toLowerCase()) {
      final c when c.contains('dessert') || c.contains('snack') =>
        'assets/images/u_us_12.png',
      final c when c.contains('seafood') => 'assets/images/u_pm_19.png',
      final c when c.contains('pasta') || c.contains('noodle') =>
        'assets/images/u_pm_16.png',
      _ => 'assets/images/u_pm_18.png',
    };

    final created = MenuModel(
      id: 'api_${apiDish.id}',
      restaurantId: 'r_buatik',
      name: apiDish.name,
      price: apiDish.estimatedPrice,
      description: apiDish.instructions.isNotEmpty
          ? apiDish.instructions
          : 'Hidangan populer ${apiDish.areaOrCuisine} (${apiDish.caloriesPerServing} kkal • ${apiDish.prepTimeMinutes} menit).',
      imageAsset: fallbackAsset,
      networkImageUrl: apiDish.imageUrl.isNotEmpty ? apiDish.imageUrl : null,
      restaurantName: 'Katalog Kuliner Open API (${apiDish.areaOrCuisine})',
      restaurantCategory: '${apiDish.category} • ${apiDish.caloriesPerServing} kkal',
      ingredients: apiDish.ingredients,
      calories: apiDish.caloriesPerServing,
      reviewerCount: '${apiDish.reviewCount}',
      reviews: [
        ReviewModel(
          userName: 'FoodView OpenAPI Explorer',
          comment:
              'Hidangan khas ${apiDish.areaOrCuisine} dengan bahan utama: ${apiDish.ingredients.take(4).join(", ")}.',
          avatarAsset: 'assets/images/u_pm_0.png',
          rating: apiDish.rating,
        ),
      ],
    );
    menus.add(created);
    return created;
  }

  void addOwnerMenu({
    required String name,
    required String price,
    required String description,
    String imageAsset = 'assets/images/u_pm_18.png',
    String? networkImageUrl,
    String fileName = 'ayam-goreng-rica.jpg',
    List<String> ingredients = const [],
    int calories = 420,
  }) {
    final formattedPrice =
        price.startsWith('Rp') ? price : 'Rp${price.trim()}';
    menus.insert(
      0,
      MenuModel(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        restaurantId: 'r_buatik',
        name: name,
        price: formattedPrice,
        description: description,
        imageAsset: imageAsset,
        networkImageUrl: networkImageUrl,
        fileName: fileName,
        ingredients: ingredients,
        calories: calories,
      ),
    );
    _firebaseService.syncMenuToFirestore(
      name: name,
      price: formattedPrice,
      description: description,
    );
    _firebaseService.triggerPushNotification(
      title: 'Menu Baru Ditambahkan!',
      body: '$name ($formattedPrice) kini tersedia di $ownerRestaurantName.',
    );
    notifyListeners();
  }

  void updateOwnerMenu({
    required String id,
    required String name,
    required String price,
    required String description,
    String? fileName,
  }) {
    final idx = menus.indexWhere((m) => m.id == id);
    if (idx != -1) {
      menus[idx].name = name;
      menus[idx].price = price.startsWith('Rp') ? price : 'Rp${price.trim()}';
      menus[idx].description = description;
      if (fileName != null) {
        menus[idx].fileName = fileName;
      }
      notifyListeners();
    }
  }

  void deleteOwnerMenu(String id) {
    menus.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
