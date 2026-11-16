import 'package:flutter/material.dart';
import '../../core/advanced_dart/api_state.dart';
import '../../data/services/firebase_hybrid_service.dart';
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
  final String distanceTag;
  final String priceTag;
  final bool is24Hours;
  final String userHistoryComment;
  bool isFavorite;
  final List<ReviewModel> reviews;

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
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];
}

class ReviewModel {
  final String userName;
  final String comment;
  final String avatarAsset;
  final double rating;

  const ReviewModel({
    required this.userName,
    required this.comment,
    required this.avatarAsset,
    this.rating = 5.0,
  });
}

class ChatThreadModel {
  final String id;
  final String restaurantId;
  final String name;
  String lastMessage;
  String time;
  int unreadCount;
  final String avatarAsset;
  final List<ChatMessageModel> messages;

  ChatThreadModel({
    required this.id,
    this.restaurantId = 'r_buatik',
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    required this.avatarAsset,
    required this.messages,
  });
}

class ChatMessageModel {
  final String text;
  final bool isCustomer;

  const ChatMessageModel({
    required this.text,
    required this.isCustomer,
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
class FoodViewUiState extends ChangeNotifier {
  final OpenCulinaryApiService _openApiService = OpenCulinaryApiService();
  final FirebaseHybridService _firebaseService = FirebaseHybridService.instance;

  FoodViewUiState() {
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _firebaseService.initialize();
    await Future.wait([
      loadOpenApiDishes(),
      loadWeatherRecommendation(),
    ]);
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

  // Komentar per restoran & menu yang bervariasi
  static List<ReviewModel> _buAtikReviews() => [
        const ReviewModel(
          userName: 'Gunawan Santoso',
          comment: 'Udah 3 kali ke sini, rasanya gk pernah berubah',
          avatarAsset: 'assets/images/u_pm_20.png',
        ),
        const ReviewModel(
          userName: 'Viktor El Firman',
          comment:
              'Pegawai toko semua ramah... suasana warungnya enak banget lagi',
          avatarAsset: 'assets/images/u_pm_1.png',
        ),
        const ReviewModel(
          userName: 'Nur Erik',
          comment: 'Buka Cabang lain di Palu dong, enak banget!',
          avatarAsset: 'assets/images/u_pm_21.png',
        ),
        const ReviewModel(
          userName: 'Jong Kok',
          comment: 'MAANNTAAAAAAAAAAAAAAAAAAAAAPPPPPPPPPPPPPPP!!!!!',
          avatarAsset: 'assets/images/u_pm_4.png',
        ),
      ];

  static List<ReviewModel> _ayamRicaReviews() => [
        const ReviewModel(
          userName: 'Gunawan Santoso',
          comment: 'Kalian wajib coba ayam goreng rica-rica bu Atik!!',
          avatarAsset: 'assets/images/u_pm_20.png',
        ),
        const ReviewModel(
          userName: 'Viktor El Firman',
          comment: 'Bumbunyaa mantullll!!\nMantap betul',
          avatarAsset: 'assets/images/u_pm_1.png',
        ),
        const ReviewModel(
          userName: 'Nur Erik',
          comment:
              'Ayam goreng ini enak banget, gurih nya pas, asinnnya pas, wuenak poll',
          avatarAsset: 'assets/images/u_pm_21.png',
        ),
        const ReviewModel(
          userName: 'Jong Kok',
          comment: 'Besok mau order lagii! masak yang banyak buu hehe...',
          avatarAsset: 'assets/images/u_pm_4.png',
        ),
      ];

  static List<ReviewModel> _westernReviews() => [
        const ReviewModel(
          userName: 'Firman Al Mana',
          comment:
              'Tempat nongkrong paling cozy di Makassar! Pastrami Pizza dan Burger-nya juara.',
          avatarAsset: 'assets/images/u_pm_1.png',
        ),
        const ReviewModel(
          userName: 'Kurniawan Jalil',
          comment:
              'Pelayanan cepat, tempat bersih ber-AC, cocok buat kerja sambil ngopi.',
          avatarAsset: 'assets/images/u_pm_2.png',
        ),
        const ReviewModel(
          userName: 'Ngoding123',
          comment: 'Wi-Fi kencang dan makanannya worth it banget!',
          avatarAsset: 'assets/images/u_pm_3.png',
        ),
      ];

  static List<ReviewModel> _dessertReviews() => [
        const ReviewModel(
          userName: 'WibuXXpaperslove',
          comment:
              'Dessert dan rotinya lembut banget, manisnya pas gak bikin eneg!',
          avatarAsset: 'assets/images/u_pm_5.png',
        ),
        const ReviewModel(
          userName: 'BlueBand1945',
          comment: 'Banana Pancake & minuman dinginnya segar poll siang-siang.',
          avatarAsset: 'assets/images/u_pm_6.png',
        ),
      ];

  static List<ReviewModel> _seafoodReviews() => [
        const ReviewModel(
          userName: 'R03L0v1s900D',
          comment:
              'Udang bakar dan salmonnya fresh banget, sambalnya mantap!',
          avatarAsset: 'assets/images/u_pm_7.png',
        ),
        const ReviewModel(
          userName: 'Gymbro1234567',
          comment: 'Sumber protein terbaik habis gym, porsinya besar!',
          avatarAsset: 'assets/images/u_pm_8.png',
        ),
      ];

  // Seluruh Menu Lengkap Lintas Restoran (agar setiap menu & restoran yang diklik menampilkan halaman berbeda!)
  late final List<MenuModel> menus = [
    // --- Menu Warung Bu Atik (r_buatik) ---
    MenuModel(
      id: 'm1',
      restaurantId: 'r_buatik',
      name: 'Ayam Goreng Rica',
      price: 'Rp25.000',
      description:
          'Hidangan khas Indonesia berupa ayam yang digoreng lalu dibalut dengan sambal rica pedas khas Manado.',
      imageAsset: 'assets/images/u_pm_18.png',
      fileName: 'ayam-goreng-rica.jpg',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Makassar',
      reviewerCount: '4,1rb',
      categoryTag: 'Ayam',
      ingredients: const ['Ayam Kampung', 'Cabai Merah', 'Serai', 'Daun Jeruk', 'Kemangi'],
      calories: 430,
      isFavorite: true,
      reviews: _ayamRicaReviews(),
    ),
    MenuModel(
      id: 'm2',
      restaurantId: 'r_buatik',
      name: 'Paket Beef',
      price: 'Rp300.000',
      description:
          'Daging sapi empuk panggang arang, disajikan dengan nasi hangat, sayur panggang, dan tiga macam sambal.',
      imageAsset: 'assets/images/u_pm_13.png',
      fileName: 'paket-beef.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '4,1rb',
      categoryTag: 'Nasi',
      ingredients: const ['Sapi Pilihan', 'Nasi Hangat', 'Paprika', 'Sambal Korek'],
      calories: 680,
      reviews: [
        const ReviewModel(
          userName: 'Gymbro1234567',
          comment: 'Daging sapinya super empuk dan porsinya bisa buat berdua!',
          avatarAsset: 'assets/images/u_pm_8.png',
        ),
        ..._buAtikReviews().take(2),
      ],
    ),
    MenuModel(
      id: 'm3',
      restaurantId: 'r_buatik',
      name: 'Bakso Goreng',
      price: 'Rp50.000',
      description:
          'Bakso goreng renyah di luar dan juicy di dalam, disajikan bersama saus asam manis pedas.',
      imageAsset: 'assets/images/u_pm_14.png',
      fileName: 'bakso-goreng.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '4,1rb',
      categoryTag: 'Ayam',
      ingredients: const ['Daging Ayam & Udang', 'Tepung Tapioka', 'Bawang Putih', 'Saus Sambal'],
      calories: 360,
      isFavorite: true,
      reviews: [
        const ReviewModel(
          userName: 'Rapperzyz2006',
          comment: 'Bakso gorengnya kriuk banget, dicocol sambal makin mantap!',
          avatarAsset: 'assets/images/u_pm_9.png',
        ),
        ..._buAtikReviews().take(2),
      ],
    ),
    MenuModel(
      id: 'm4',
      restaurantId: 'r_buatik',
      name: 'Sphagetti',
      price: 'Rp75.000',
      description:
          'Spaghetti al dente dengan saus bolognese daging cincang segar dan taburan keju parmesan.',
      imageAsset: 'assets/images/u_pm_16.png',
      fileName: 'sphagetti.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3,5rb',
      categoryTag: 'Mie',
      ingredients: const ['Pasta Spaghetti', 'Saus Tomat Segar', 'Daging Sapi Cincang', 'Keju Parmesan'],
      calories: 510,
      isFavorite: true,
      reviews: _westernReviews(),
    ),
    MenuModel(
      id: 'm5',
      restaurantId: 'r_buatik',
      name: 'Dimsum Soup',
      price: 'Rp53.000',
      description:
          'Dimsum udang & ayam lembut disajikan hangat dalam kuah kaldu gurih dengan taburan daun bawang.',
      imageAsset: 'assets/images/u_pm_15.png',
      fileName: 'dimsum-soup.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3,5rb',
      categoryTag: 'Seafood',
      ingredients: const ['Udang Kupas', 'Kulit Dimsum', 'Kaldu Ayam', 'Minyak Wijen'],
      calories: 320,
      reviews: _seafoodReviews(),
    ),
    MenuModel(
      id: 'm6',
      restaurantId: 'r_buatik',
      name: 'Steak',
      price: 'Rp180.000',
      description:
          'Tenderloin steak panggang medium-well dengan saus lada hitam, asparagus, dan mashed potato.',
      imageAsset: 'assets/images/u_us_17.png',
      fileName: 'steak.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3,5rb',
      categoryTag: 'Ayam',
      ingredients: const ['Tenderloin Sapi', 'Saus Lada Hitam', 'Asparagus', 'Kentang Tumbuk'],
      calories: 620,
      reviews: _westernReviews(),
    ),
    MenuModel(
      id: 'm7',
      restaurantId: 'r_buatik',
      name: 'Salmon',
      price: 'Rp192.000',
      description:
          'Fillet ikan salmon Norwegia lembut dengan kuah kari rempah khas yang kaya rasa dan sehat.',
      imageAsset: 'assets/images/u_pm_17.png',
      fileName: 'salmon.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3,5rb',
      categoryTag: 'Seafood',
      ingredients: const ['Fillet Salmon', 'Santan Segar', 'Rempah Kuning', 'Daun Kemangi'],
      calories: 490,
      reviews: _seafoodReviews(),
    ),
    MenuModel(
      id: 'm8',
      restaurantId: 'r_buatik',
      name: 'Udang Bakar',
      price: 'Rp110.000',
      description:
          'Udang windu bakar madu pedas manis, bumbunya meresap sempurna hingga ke dalam daging.',
      imageAsset: 'assets/images/u_pm_19.png',
      fileName: 'udang-bakar.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3,1rb',
      categoryTag: 'Seafood',
      ingredients: const ['Udang Windu Segar', 'Madu Hutan', 'Kecap Manis', 'Jeruk Nipis'],
      calories: 380,
      reviews: _seafoodReviews(),
    ),
    MenuModel(
      id: 'm9',
      restaurantId: 'r_buatik',
      name: 'Shrimp Noodle',
      price: 'Rp65.000',
      description:
          'Mie goreng oriental spesial dengan udang segar, jamur kuping, dan sayuran organik.',
      imageAsset: 'assets/images/u_us_18.png',
      fileName: 'shrimp-noodle.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3rb',
      categoryTag: 'Mie',
      ingredients: const ['Mie Telur', 'Udang Segar', 'Saus Tiram', 'Sayur Pakcoy'],
      calories: 470,
      reviews: _seafoodReviews(),
    ),
    MenuModel(
      id: 'm10',
      restaurantId: 'r_buatik',
      name: 'Hokkie Rice',
      price: 'Rp58.000',
      description:
          'Nasi siram saus hokkie gurih dengan potongan ayam panggang dan sayuran segar.',
      imageAsset: 'assets/images/u_us_19.png',
      fileName: 'hokkie-rice.jpg',
      restaurantName: 'Warung Bu Atik',
      reviewerCount: '3rb',
      categoryTag: 'Nasi',
      ingredients: const ['Nasi Pulen', 'Ayam Panggang', 'Wortel & Kacang Polong', 'Saus Hokkie'],
      calories: 495,
      reviews: _buAtikReviews(),
    ),

    // --- Menu Black Canyon & Fireflies (Western / Cepat Saji) ---
    MenuModel(
      id: 'm_bc_pizza',
      restaurantId: 'r_black_canyon',
      name: 'Pastrami Pizza',
      price: 'Rp75.000',
      description:
          'Pastrami sapi asap gurih dengan keju mozzarella leleh dan saus tomat Italia di atas roti tipis renyah.',
      imageAsset: 'assets/images/u_us_11.png',
      restaurantName: 'Black Canyon',
      restaurantCategory: 'Cepat Saji',
      restaurantAddress: 'Jl. Toddopuli Raya No 12, Makassar',
      reviewerCount: '4,2rb',
      categoryTag: 'Ayam',
      ingredients: const ['Daging Pastrami', 'Keju Mozzarella', 'Saus Marinara', 'Oregano'],
      calories: 590,
      isFavorite: true,
      reviews: _westernReviews(),
    ),
    MenuModel(
      id: 'm_bc_pancake',
      restaurantId: 'r_koko',
      name: 'Banana Pancake',
      price: 'Rp75.000',
      description:
          'Tumpukan pancake lembut isi pisang karamel manis dengan siraman maple syrup, cocok untuk pencuci mulut.',
      imageAsset: 'assets/images/u_us_12.png',
      restaurantName: 'Koko House',
      restaurantCategory: 'Dessert & Minuman',
      restaurantAddress: 'Jl. Nusantara, Makassar',
      reviewerCount: '3,4rb',
      categoryTag: 'Minuman',
      ingredients: const ['Pisang Raja', 'Tepung Pancake', 'Maple Syrup', 'Butter'],
      calories: 410,
      isFavorite: true,
      reviews: _dessertReviews(),
    ),
    MenuModel(
      id: 'm_bc_salad',
      restaurantId: 'r_padanga',
      name: 'Salad Segar Tropis',
      price: 'Rp54.000',
      description:
          'Sayuran organik segar beraneka warna dengan potongan ayam panggang dan sesame dressing spesial.',
      imageAsset: 'assets/images/u_us_21.png',
      restaurantName: 'Padanga Beach',
      restaurantCategory: 'Dessert & Healthy Food',
      restaurantAddress: 'Jl. Urip Sumoharjo, Makassar',
      reviewerCount: '2,9rb',
      categoryTag: 'Minuman',
      ingredients: const ['Selada Romaine', 'Tomat Ceri', 'Jagung Manis', 'Wijen Sangrai'],
      calories: 240,
      isFavorite: true,
      reviews: _dessertReviews(),
    ),
    MenuModel(
      id: 'm_bc_burger',
      restaurantId: 'r_fireflies',
      name: 'Double Cheese Burger',
      price: 'Rp24.000',
      description:
          'Patty daging sapi juicy panggang arang, keju cheddar leleh, selada segar, dan saus spesial dalam bun brioche.',
      imageAsset: 'assets/images/u_us_22.png',
      restaurantName: 'Fireflies',
      restaurantCategory: 'Cepat Saji',
      restaurantAddress: 'Jl. Tanjung Bayang, Makassar',
      reviewerCount: '3,8rb',
      categoryTag: 'Ayam',
      ingredients: const ['Roti Brioche', 'Beef Patty 150g', 'Keju Cheddar', 'Saus Tartar'],
      calories: 540,
      isFavorite: true,
      reviews: _westernReviews(),
    ),
    MenuModel(
      id: 'm_mie_ayam_ais',
      restaurantId: 'r_pak_ijo',
      name: 'Mie Ayam Spesial',
      price: 'Rp22.000',
      description:
          'Mie kenyal buatan sendiri dengan topping ayam kecap jamur melimpah, pangsit rebus, dan kuah kaldu gurih.',
      imageAsset: 'assets/images/u_us_8.png',
      restaurantName: 'Toko Pak Ais / Pak Ijo',
      restaurantCategory: 'Mie & Bakso',
      restaurantAddress: 'Jl. Samata, Borong Indah, Makassar',
      reviewerCount: '5,0rb',
      categoryTag: 'Mie',
      ingredients: const ['Mie Telur Segar', 'Ayam Kecap Jamur', 'Pangsit Ayam', 'Sawi Hijau'],
      calories: 440,
      isFavorite: true,
      reviews: [
        const ReviewModel(
          userName: 'Gibran Nur Saleh',
          comment: 'Mie ayam terenak di area Samata! Kuah kaldunya gurih banget.',
          avatarAsset: 'assets/images/u_pm_0.png',
        ),
        ..._buAtikReviews().take(2),
      ],
    ),
    MenuModel(
      id: 'm_nasi_liwet',
      restaurantId: 'r_alhamdulillah',
      name: 'Nasi Liwet Pete Ayam',
      price: 'Rp24.000',
      description:
          'Nasi gurih dimasak dengan santan dan rempah daun salam, disajikan dengan suwiran ayam, telur, dan pete bakar.',
      imageAsset: 'assets/images/u_us_7.png',
      restaurantName: 'Warung Pak Joko',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Makassar',
      reviewerCount: '3,2rb',
      categoryTag: 'Nasi',
      ingredients: const ['Beras Wangi', 'Ayam Suwir', 'Pete Segar', 'Telur Rebus', 'Sambal Terasi'],
      calories: 480,
      reviews: _buAtikReviews(),
    ),
    MenuModel(
      id: 'm_ayam_semur',
      restaurantId: 'r_gedebuk',
      name: 'Ayam Semur Rempah',
      price: 'Rp28.000',
      description:
          'Potongan ayam empuk dimasak perlahan dalam kuah kecap manis berbumbu pala, cengkeh, dan bawang goreng.',
      imageAsset: 'assets/images/u_us_6.png',
      restaurantName: 'Ayam Sambal Gedebuk',
      restaurantCategory: 'Ayam & Nasi',
      restaurantAddress: 'Jl. Pengayoman, Makassar',
      reviewerCount: '3,5rb',
      categoryTag: 'Ayam',
      ingredients: const ['Ayam Potong', 'Kecap Manis', 'Biji Pala', 'Kayu Manis'],
      calories: 450,
      reviews: _ayamRicaReviews(),
    ),
  ];

  /// Mengambil daftar menu spesifik untuk masing-masing restoran agar setiap restoran yang diklik
  /// menampilkan variasi menu yang sesuai dengan profil restorannya!
  List<MenuModel> getMenusForRestaurant(RestaurantModel restaurant) {
    return switch (restaurant.id) {
      'r_buatik' => menus.where((m) => m.restaurantId == 'r_buatik').toList(),
      'r_black_canyon' || 'r_fireflies' => [
          menus.firstWhere((m) => m.id == 'm_bc_pizza'),
          menus.firstWhere((m) => m.id == 'm_bc_burger'),
          menus.firstWhere((m) => m.id == 'm6'), // Steak
          menus.firstWhere((m) => m.id == 'm4'), // Sphagetti
          menus.firstWhere((m) => m.id == 'm_bc_pancake'),
          menus.firstWhere((m) => m.id == 'm_bc_salad'),
        ],
      'r_koko' || 'r_brood' || 'r_padanga' => [
          menus.firstWhere((m) => m.id == 'm_bc_pancake'),
          menus.firstWhere((m) => m.id == 'm_bc_salad'),
          menus.firstWhere((m) => m.id == 'm_bc_pizza'),
          menus.firstWhere((m) => m.id == 'm4'), // Sphagetti
          menus.firstWhere((m) => m.id == 'm5'), // Dimsum Soup
        ],
      'r_mba_atun' => [
          menus.firstWhere((m) => m.id == 'm8'), // Udang Bakar
          menus.firstWhere((m) => m.id == 'm7'), // Salmon
          menus.firstWhere((m) => m.id == 'm9'), // Shrimp Noodle
          menus.firstWhere((m) => m.id == 'm5'), // Dimsum Soup
          menus.firstWhere((m) => m.id == 'm10'), // Hokkie Rice
        ],
      'r_pak_ijo' => [
          menus.firstWhere((m) => m.id == 'm_mie_ayam_ais'),
          menus.firstWhere((m) => m.id == 'm9'), // Shrimp Noodle
          menus.firstWhere((m) => m.id == 'm3'), // Bakso Goreng
          menus.firstWhere((m) => m.id == 'm5'), // Dimsum Soup
        ],
      _ => [
          menus.firstWhere((m) => m.id == 'm_ayam_semur'),
          menus.firstWhere((m) => m.id == 'm_nasi_liwet'),
          menus.firstWhere((m) => m.id == 'm1'), // Ayam Goreng Rica
          menus.firstWhere((m) => m.id == 'm3'), // Bakso Goreng
          menus.firstWhere((m) => m.id == 'm2'), // Paket Beef
        ],
    };
  }

  // Daftar Restoran Lengkap dengan Koordinat Makassar, Kategori, Harga & Jam Operasional Berbeda
  late final List<RestaurantModel> restaurants = [
    RestaurantModel(
      id: 'r_buatik',
      name: 'Warung Bu Atik',
      category: 'Ayam dan bebek, Aneka Nasi, Cepat Saji',
      categoryTags: const ['Nasi', 'Ayam', 'Seafood'],
      address: 'Jl. Samata, Borong Indah, Makassar',
      latitude: -5.2035,
      longitude: 119.4932,
      hours: '08.00 - 22.30 WITA',
      phone: '081231492034',
      distanceTag: '1-2 km',
      priceTag: 'Rp25.000 - Rp100.000',
      description:
          'Warung Bu Atik adalah tempat makan khas rumahan yang menyajikan cita rasa autentik Nusantara, '
          'dengan suasana hangat dan nyaman seperti di rumah sendiri. Setiap hidangan diolah dengan resep '
          'turun-temurun dan bahan-bahan pilihan yang segar, menjadikan setiap suapan penuh rasa dan kelezatan. '
          'Salah satu menu andalan yang menjadi favorit pelanggan adalah Ayam Goreng Rica, masakan khas '
          'yang menggugah selera dengan rasa pedas yang menggigit namun tetap nikmat.',
      imageAsset: 'assets/images/u_us_5.png',
      galleryAssets: const [
        'assets/images/u_us_15.png',
        'assets/images/u_us_6.png',
        'assets/images/u_us_16.png',
      ],
      reviewerCount: '3rb',
      isFavorite: true,
      reviews: _buAtikReviews(),
    ),
    RestaurantModel(
      id: 'r_fireflies',
      name: 'Fireflies',
      category: 'Cepat Saji',
      categoryTags: const ['Ayam', 'Minuman'],
      address: 'Jl. Tanjung Bayang, Makassar',
      latitude: -5.1842,
      longitude: 119.3918,
      hours: '10.00 - 23.30 WITA',
      phone: '081144556677',
      distanceTag: '2-5 km',
      priceTag: 'Rp25.000 - Rp100.000',
      is24Hours: true,
      userHistoryComment:
          'Tempat nongkrong sore paling asik di Tanjung Bayang, burger dan kentang gorengnya juara!',
      description:
          'Fireflies menghadirkan aneka sajian cepat saji modern seperti Double Cheese Burger, Pizza, dan Steak '
          'dengan suasana semi-outdoor yang hijau dan instagramable di kawasan Tanjung Bayang Makassar.',
      imageAsset: 'assets/images/u_us_0.png',
      galleryAssets: const [
        'assets/images/u_us_0.png',
        'assets/images/u_us_11.png',
        'assets/images/u_us_22.png',
      ],
      reviewerCount: '3rb',
      reviews: _westernReviews(),
    ),
    RestaurantModel(
      id: 'r_koko',
      name: 'Koko House',
      category: 'Dessert & Minuman',
      categoryTags: const ['Minuman'],
      address: 'Jl. Nusantara, Makassar',
      latitude: -5.1345,
      longitude: 119.4052,
      hours: '09.00 - 22.00 WITA',
      phone: '081355667788',
      distanceTag: '2-5 km',
      priceTag: 'Rp25.000 - Rp100.000',
      description:
          'Koko House menyajikan hidangan penutup manis, Banana Pancake, artisan gelato, dan minuman kopi/teh '
          'segar favorit anak muda dan keluarga di Makassar.',
      imageAsset: 'assets/images/u_us_1.png',
      galleryAssets: const [
        'assets/images/u_us_1.png',
        'assets/images/u_us_12.png',
        'assets/images/u_us_21.png',
      ],
      reviewerCount: '3rb',
      reviews: _dessertReviews(),
    ),
    RestaurantModel(
      id: 'r_brood',
      name: 'Brood Bakery',
      category: 'Bakery, Dessert & Minuman',
      categoryTags: const ['Minuman'],
      address: 'Jl. Daeng Tata No 64, Makassar',
      latitude: -5.1785,
      longitude: 119.4258,
      hours: '07.00 - 21.30 WITA',
      phone: '081299887766',
      distanceTag: '<1 km',
      priceTag: '<Rp25.000',
      description:
          'Brood Bakery menyediakan roti sourdough, croissant hangat yang dipanggang segar setiap pagi, '
          'serta aneka kopi susu gula aren.',
      imageAsset: 'assets/images/u_us_2.png',
      galleryAssets: const [
        'assets/images/u_us_2.png',
        'assets/images/u_us_12.png',
      ],
      reviewerCount: '3rb',
      reviews: _dessertReviews(),
    ),
    RestaurantModel(
      id: 'r_padanga',
      name: 'Padanga Beach',
      category: 'Dessert & Seafood Sunset',
      categoryTags: const ['Minuman', 'Seafood'],
      address: 'Jl. Urip Sumoharjo, Makassar',
      latitude: -5.1412,
      longitude: 119.4421,
      hours: '11.00 - 23.00 WITA',
      phone: '081277665544',
      distanceTag: '2-5 km',
      priceTag: '>Rp100.000',
      description:
          'Restoran bernuansa pantai tropis dengan pemandangan indah, menyajikan hidangan sehat, salad segar, '
          'minuman tropis, dan olahan laut.',
      imageAsset: 'assets/images/u_us_3.png',
      galleryAssets: const [
        'assets/images/u_us_3.png',
        'assets/images/u_us_15.png',
        'assets/images/u_us_16.png',
      ],
      reviewerCount: '3rb',
      reviews: _dessertReviews(),
    ),
    RestaurantModel(
      id: 'r_alhamdulillah',
      name: 'Warung Alhamdulillah',
      category: 'Cepat Saji & Aneka Nasi',
      categoryTags: const ['Nasi', 'Ayam'],
      address: 'Jl. Malino, Somba Opu',
      latitude: -5.2110,
      longitude: 119.4850,
      hours: '06.30 - 24.00 WITA',
      phone: '085233445566',
      distanceTag: '<1 km',
      priceTag: '<Rp25.000',
      is24Hours: true,
      description:
          'Warung makan legendaris buka 24 jam di jalur Jl. Malino Somba Opu dengan porsi mengenyangkan, '
          'Nasi Liwet Pete, dan harga sangat ramah mahasiswa.',
      imageAsset: 'assets/images/u_us_4.png',
      galleryAssets: const [
        'assets/images/u_us_4.png',
        'assets/images/u_us_7.png',
        'assets/images/u_us_6.png',
      ],
      reviewerCount: '3rb',
      reviews: _buAtikReviews(),
    ),
    RestaurantModel(
      id: 'r_mba_atun',
      name: 'Rumah Makan Mba Atun',
      category: 'Seafood & Nusantara',
      categoryTags: const ['Seafood', 'Nasi'],
      address: 'Jl. Toddopuli Raya No 12, Makassar',
      latitude: -5.1580,
      longitude: 119.4480,
      hours: '09.00 - 22.00 WITA',
      phone: '081344558899',
      distanceTag: '1-2 km',
      priceTag: 'Rp25.000 - Rp100.000',
      userHistoryComment:
          'Udang bakar madunya juara banget, sambal mangganya segar dan pelayanannya cepat!',
      description:
          'Spesialis olahan laut segar (Udang Bakar, Ikan Bakar, Cumi Saus Padang, dan Dimsum Soup) '
          'di kawasan ramai Jl. Toddopuli Raya Makassar.',
      imageAsset: 'assets/images/u_us_1.png',
      galleryAssets: const [
        'assets/images/u_pm_19.png',
        'assets/images/u_pm_17.png',
        'assets/images/u_us_1.png',
      ],
      reviewerCount: '2rb',
      reviews: _seafoodReviews(),
    ),
    RestaurantModel(
      id: 'r_gedebuk',
      name: 'Ayam Sambal Gedebuk',
      category: 'Ayam & Aneka Sambal',
      categoryTags: const ['Ayam', 'Nasi'],
      address: 'Jl. Pengayoman, Makassar',
      latitude: -5.1545,
      longitude: 119.4452,
      hours: '10.00 - 22.30 WITA',
      phone: '081266778899',
      distanceTag: '1-2 km',
      priceTag: '<Rp25.000',
      description:
          'Ayam goreng rempah dan Ayam Semur yang disajikan dengan sambal bawang ulek dadakan ekstra pedas.',
      imageAsset: 'assets/images/u_us_2.png',
      galleryAssets: const [
        'assets/images/u_pm_18.png',
        'assets/images/u_us_6.png',
      ],
      reviewerCount: '3,5rb',
      reviews: _ayamRicaReviews(),
    ),
    RestaurantModel(
      id: 'r_pak_ijo',
      name: 'Pak Ijo',
      category: 'Mie & Bakso',
      categoryTags: const ['Mie'],
      address: 'Jl. Hertasning Baru, Makassar',
      latitude: -5.1712,
      longitude: 119.4578,
      hours: '09.30 - 22.00 WITA',
      phone: '081388990011',
      distanceTag: '1-2 km',
      priceTag: '<Rp25.000',
      description:
          'Pelopor Mie Ayam Hijau sehat dan Shrimp Noodle dengan kuah kaldu ayam kampung asli tanpa pengawet.',
      imageAsset: 'assets/images/u_us_3.png',
      galleryAssets: const [
        'assets/images/u_us_8.png',
        'assets/images/u_us_18.png',
      ],
      reviewerCount: '1,8rb',
      reviews: _buAtikReviews(),
    ),
    RestaurantModel(
      id: 'r_geprek_mantul',
      name: 'Geprek Mantul',
      category: 'Ayam, Aneka Nasi, Cepat Saji',
      categoryTags: const ['Ayam', 'Nasi'],
      address: 'Jl. Antang Raya, Makassar',
      latitude: -5.1620,
      longitude: 119.4820,
      hours: '09.00 - 23.00 WITA',
      phone: '085311223344',
      distanceTag: '>5 km',
      priceTag: '<Rp25.000',
      description:
          'Ayam geprek krispi dengan level kepedasan 1 hingga 10 dan lelehan keju mozzarella.',
      imageAsset: 'assets/images/u_us_4.png',
      galleryAssets: const [
        'assets/images/u_pm_18.png',
        'assets/images/u_us_4.png',
      ],
      reviewerCount: '2rb',
      reviews: _ayamRicaReviews(),
    ),
    RestaurantModel(
      id: 'r_black_canyon',
      name: 'Black Canyon',
      category: 'Cepat Saji, Kopi & Western',
      categoryTags: const ['Ayam', 'Minuman', 'Mie'],
      address: 'Jl. Toddopuli Raya No 12, Makassar',
      latitude: -5.1562,
      longitude: 119.4445,
      hours: '08.00 - 23.00 WITA',
      phone: '0411-456789',
      distanceTag: '2-5 km',
      priceTag: 'Rp25.000 - Rp100.000',
      description:
          'Restoran pemenang penghargaan Top of the Week di FoodView! Menyajikan Pastrami Pizza, '
          'Tenderloin Steak, Pasta, Banana Pancake, dan kopi spesialti pilihan.',
      imageAsset: 'assets/images/u_us_0.png',
      galleryAssets: const [
        'assets/images/u_us_11.png',
        'assets/images/u_us_12.png',
        'assets/images/u_us_17.png',
      ],
      reviewerCount: '4,2rb',
      isFavorite: true,
      reviews: _westernReviews(),
    ),
  ];

  // Percakapan default
  static List<ChatMessageModel> _defaultConversation(String restoName) => [
        ChatMessageModel(
          text:
              'Halo, selamat pagi $restoName. Saya baru saja memesan dan ingin menanyakan ketersediaan menu hari ini.',
          isCustomer: true,
        ),
        const ChatMessageModel(
          text:
              'Saya memesan paket menu utama, apakah bisa dikirim hangat dengan tambahan sambal terpisah?',
          isCustomer: true,
        ),
        ChatMessageModel(
          text:
              'Halo Kak, terima kasih sudah menghubungi $restoName!\nSemua menu utama kami tersedia hari ini dan siap disajikan hangat.',
          isCustomer: false,
        ),
        const ChatMessageModel(
          text:
              'Kami sangat menghargai masukan dari pelanggan. Sambal tambahan dan voucher diskon sudah kami sertakan di pesanan Kakak ya!',
          isCustomer: false,
        ),
        const ChatMessageModel(
          text:
              'Baik kak, terima kasih banyak atas respons cepatnya!',
          isCustomer: true,
        ),
      ];

  // Daftar Chat Toko (Role USER)
  late final List<ChatThreadModel> userChats = [
    ChatThreadModel(
      id: 'uc1',
      restaurantId: 'r_buatik',
      name: 'Warung Bu Atik',
      lastMessage: 'Baik kak, terima kasih telah bertanggung...',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_12.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'uc2',
      restaurantId: 'r_mba_atun',
      name: 'Sari Laut Bang Mawa',
      lastMessage: 'Terima kasih mas',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_1.png',
      messages: _defaultConversation('Sari Laut Bang Mawa'),
    ),
    ChatThreadModel(
      id: 'uc3',
      restaurantId: 'r_pak_ijo',
      name: 'Bakso 99 Kubah',
      lastMessage: 'Next hati-hati lagi ya kak :(',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_2.png',
      messages: _defaultConversation('Bakso 99 Kubah'),
    ),
    ChatThreadModel(
      id: 'uc4',
      restaurantId: 'r_gedebuk',
      name: 'Ayam Gedebuk 88',
      lastMessage: 'Next aku order lagi',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_3.png',
      messages: _defaultConversation('Ayam Gedebuk 88'),
    ),
    ChatThreadModel(
      id: 'uc5',
      restaurantId: 'r_pak_ijo',
      name: 'Mie Ayam Kasih Sayang',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_4.png',
      messages: _defaultConversation('Mie Ayam Kasih Sayang'),
    ),
    ChatThreadModel(
      id: 'uc6',
      restaurantId: 'r_koko',
      name: 'Less Sugar Cafe',
      lastMessage: 'Maaf kak, kita sedang kehabisan stok Gula',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_5.png',
      messages: _defaultConversation('Less Sugar Cafe'),
    ),
    ChatThreadModel(
      id: 'uc7',
      restaurantId: 'r_alhamdulillah',
      name: 'Rumah Makan Rumit',
      lastMessage: 'Oke kak, diusahakan sesederhana mungkin',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_6.png',
      messages: _defaultConversation('Rumah Makan Rumit'),
    ),
    ChatThreadModel(
      id: 'uc8',
      restaurantId: 'r_black_canyon',
      name: 'Pizzazitu / Black Canyon',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_7.png',
      messages: _defaultConversation('Black Canyon'),
    ),
    ChatThreadModel(
      id: 'uc9',
      restaurantId: 'r_fireflies',
      name: 'Burger Rakyat / Fireflies',
      lastMessage: 'Selamat menikmati...',
      time: '10.55',
      unreadCount: 1,
      avatarAsset: 'assets/images/u_pm_8.png',
      messages: _defaultConversation('Fireflies'),
    ),
    ChatThreadModel(
      id: 'uc10',
      restaurantId: 'r_brood',
      name: 'Bukan Bakso Boraks',
      lastMessage: 'Enak banget kaakk',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_9.png',
      messages: _defaultConversation('Brood Bakery'),
    ),
    ChatThreadModel(
      id: 'uc11',
      restaurantId: 'r_padanga',
      name: 'Seafood Darat',
      lastMessage: 'Baik kak',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_10.png',
      messages: _defaultConversation('Padanga Beach'),
    ),
  ];

  /// Mengambil atau membuat thread chat yang sesuai dengan restoran yang sedang dibuka!
  ChatThreadModel getChatThreadForRestaurant(RestaurantModel restaurant) {
    final existing = userChats.where((c) => c.restaurantId == restaurant.id);
    if (existing.isNotEmpty) return existing.first;
    final created = ChatThreadModel(
      id: 'uc_${restaurant.id}',
      restaurantId: restaurant.id,
      name: restaurant.name,
      lastMessage: 'Halo kak, ada yang bisa kami bantu?',
      time: 'Baru saja',
      avatarAsset: restaurant.imageAsset,
      messages: _defaultConversation(restaurant.name),
    );
    userChats.insert(0, created);
    return created;
  }

  // Daftar Chat Pelanggan (Role PEMILIK RESTORAN)
  late final List<ChatThreadModel> ownerChats = [
    ChatThreadModel(
      id: 'oc1',
      name: 'Gibran Nur Saleh',
      lastMessage: 'Baik kak, terima kasih',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_0.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc2',
      name: 'Firman Al Mana',
      lastMessage: 'Terima kasih mas',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_1.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc3',
      name: 'Kurniawan Jalil',
      lastMessage: 'Next hati-hati lagi ya kak :(',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_2.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc4',
      name: 'Ngoding123',
      lastMessage: 'Next aku order lagi',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_3.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc5',
      name: 'Jungkuk99Gamerzx',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_4.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc6',
      name: 'WibuXXpaperslove',
      lastMessage: 'Maaf kak, kita sedang kehabisan stok Gula',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_5.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc7',
      name: 'BlueBand1945',
      lastMessage: 'Oke kak, diusahakan sesederhana mungkin',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_6.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc8',
      name: 'R03L0v1s900D',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_7.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc9',
      name: 'Gymbro1234567',
      lastMessage: 'Selamat menikmati...',
      time: '10.55',
      unreadCount: 1,
      avatarAsset: 'assets/images/u_pm_8.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc10',
      name: 'Rapperzyz2006',
      lastMessage: 'Enak banget kaakk',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_9.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
    ChatThreadModel(
      id: 'oc11',
      name: '@Qu14n76nG',
      lastMessage: 'Baik kak',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_10.png',
      messages: _defaultConversation('Warung Bu Atik'),
    ),
  ];

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
        reviews: _ayamRicaReviews(),
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

  void sendChatMessage({
    required ChatThreadModel thread,
    required String text,
    required bool isCustomer,
  }) {
    thread.messages.add(
      ChatMessageModel(text: text, isCustomer: isCustomer),
    );
    thread.lastMessage = text;
    thread.time = 'Baru saja';
    thread.unreadCount = 0;
    _firebaseService.triggerPushNotification(
      title: isCustomer ? 'Pesan Terkirim ke ${thread.name}' : 'Balasan Terkirim',
      body: text,
    );
    notifyListeners();
  }
}
