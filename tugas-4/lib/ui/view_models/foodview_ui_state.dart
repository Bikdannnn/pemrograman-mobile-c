import 'package:flutter/material.dart';

enum AppActiveRole { user, pemilikRestoran }

class MenuModel {
  final String id;
  String name;
  String price;
  String description;
  String imageAsset;
  String fileName;
  final String restaurantName;
  final String restaurantCategory;
  final String restaurantAddress;
  final String reviewerCount;
  bool isFavorite;
  final List<ReviewModel> reviews;

  MenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageAsset,
    this.fileName = 'ayam-goreng-rica.jpg',
    this.restaurantName = 'Warung Bu Atik',
    this.restaurantCategory = 'Ayam, Aneka Nasi, Cepat Saji',
    this.restaurantAddress = 'Jl. Samata, Borong Indah, Makassar',
    this.reviewerCount = '4,1rb',
    this.isFavorite = false,
    List<ReviewModel>? reviews,
  }) : reviews = reviews ?? [];
}

class RestaurantModel {
  final String id;
  final String name;
  final String category;
  final String address;
  final String hours;
  final String phone;
  final String description;
  final String imageAsset;
  final List<String> galleryAssets;
  final String reviewerCount;
  final String distanceTag;
  final String priceTag;
  bool isFavorite;
  final List<ReviewModel> reviews;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    this.hours = '08.00 - 22.30 WITA',
    this.phone = '081231492034',
    required this.description,
    required this.imageAsset,
    required this.galleryAssets,
    this.reviewerCount = '3rb',
    this.distanceTag = '1-2 km',
    this.priceTag = 'Rp25.000 - Rp100.000',
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
  final String name;
  String lastMessage;
  String time;
  int unreadCount;
  final String avatarAsset;
  final List<ChatMessageModel> messages;

  ChatThreadModel({
    required this.id,
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

/// ViewModel (Provider ChangeNotifier) untuk mengelola seluruh state UI
/// baik untuk Role USER maupun Role PEMILIK RESTORAN sesuai desain Figma.
class FoodViewUiState extends ChangeNotifier {
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
    notifyListeners();
  }

  void logoutUser() {
    _isUserLoggedIn = false;
    notifyListeners();
  }

  void loginOwner({String? restaurantName, String? address}) {
    _isOwnerLoggedIn = true;
    if (restaurantName != null && restaurantName.trim().isNotEmpty) {
      ownerRestaurantName = restaurantName.trim();
    }
    if (address != null && address.trim().isNotEmpty) {
      ownerRestaurantAddress = address.trim();
    }
    _activeRole = AppActiveRole.pemilikRestoran;
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

  // Komentar default pada Restoran Warung Bu Atik (persis dari USER.svg & PEMILIK RESTORAN.svg)
  static List<ReviewModel> _defaultRestaurantReviews() => [
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

  // Komentar default pada Menu Ayam Goreng Rica (persis dari USER.svg)
  static List<ReviewModel> _defaultDishReviews() => [
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

  // Daftar Menu Warung Bu Atik & Black Canyon (persis dari USER.svg & PEMILIK RESTORAN.svg)
  late final List<MenuModel> menus = [
    MenuModel(
      id: 'm1',
      name: 'Ayam Goreng Rica',
      price: 'Rp25.000',
      description:
          'Hidangan khas Indonesia berupa ayam yang digoreng lalu dibalut dengan sambal rica pedas khas Manado.',
      imageAsset: 'assets/images/u_pm_18.png',
      fileName: 'ayam-goreng-rica.jpg',
      reviewerCount: '4,1rb',
      isFavorite: true,
      reviews: _defaultDishReviews(),
    ),
    MenuModel(
      id: 'm2',
      name: 'Paket Beef',
      price: 'Rp300.000',
      description:
          'Daging sapi empuk, nasi hangat, sayur, dan sambal pedas.',
      imageAsset: 'assets/images/u_pm_13.png',
      fileName: 'paket-beef.jpg',
      reviewerCount: '4,1rb',
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm3',
      name: 'Bakso Goreng',
      price: 'Rp50.000',
      description:
          'Bakso goreng renyah luar, juicy dalam, cocok untuk camilan.',
      imageAsset: 'assets/images/u_pm_14.png',
      fileName: 'bakso-goreng.jpg',
      reviewerCount: '4,1rb',
      isFavorite: true,
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm4',
      name: 'Sphagetti',
      price: 'Rp75.000',
      description:
          'Spaghetti al dente dengan saus tomat segar dan keju parut.',
      imageAsset: 'assets/images/u_pm_16.png',
      fileName: 'sphagetti.jpg',
      reviewerCount: '3,5rb',
      isFavorite: true,
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm5',
      name: 'Dimsum Soup',
      price: 'Rp53.000',
      description:
          'Dimsum lembut disajikan hangat dalam kuah kaldu gurih.',
      imageAsset: 'assets/images/u_pm_15.png',
      fileName: 'dimsum-soup.jpg',
      reviewerCount: '3,5rb',
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm6',
      name: 'Steak',
      price: 'Rp180.000',
      description:
          'Steak daging sapi panggang medium well dengan kentang dan sayuran segar.',
      imageAsset: 'assets/images/u_us_17.png',
      fileName: 'steak.jpg',
      reviewerCount: '3,5rb',
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm7',
      name: 'Salmon',
      price: 'Rp192.000',
      description:
          'Salmon lembut dengan bumbu rempah khas, lezat menggoda.',
      imageAsset: 'assets/images/u_pm_17.png',
      fileName: 'salmon.jpg',
      reviewerCount: '3,5rb',
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm8',
      name: 'Udang Bakar',
      price: 'Rp110.000',
      description:
          'Udang bakar segar, manis pedas, bumbu meresap sampai dalam.',
      imageAsset: 'assets/images/u_pm_19.png',
      fileName: 'udang-bakar.jpg',
      reviewerCount: '3,1rb',
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm9',
      name: 'Shrimp Noodle',
      price: 'Rp65.000',
      description:
          'Mie goreng spesial dengan topping udang segar dan sayuran.',
      imageAsset: 'assets/images/u_us_18.png',
      fileName: 'shrimp-noodle.jpg',
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
    MenuModel(
      id: 'm10',
      name: 'Hokkie Rice',
      price: 'Rp58.000',
      description:
          'Nasi khas oriental dengan saus gurih, potongan ayam, dan sayuran.',
      imageAsset: 'assets/images/u_us_19.png',
      fileName: 'hokkie-rice.jpg',
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
  ];

  // Daftar Menu Favorit tambahan dari Black Canyon (untuk layar Favoritku -> Menu)
  final List<MenuModel> extraFavoriteMenus = [
    MenuModel(
      id: 'fav_bc_1',
      name: 'Pastrami Pizza',
      price: 'Rp.75.000',
      description:
          'Pastrami gurih dengan keju leleh dan saus tomat di atas roti tipis renyah.',
      imageAsset: 'assets/images/u_us_11.png',
      restaurantName: 'Black Canyon',
      restaurantCategory: 'Cepat Saji',
      isFavorite: true,
    ),
    MenuModel(
      id: 'fav_bc_2',
      name: 'Banana Pancake',
      price: 'Rp.75.000',
      description:
          'Pancake lembut isi pisang manis, cocok untuk sarapan lezat.',
      imageAsset: 'assets/images/u_us_12.png',
      restaurantName: 'Black Canyon',
      restaurantCategory: 'Cepat Saji',
      isFavorite: true,
    ),
    MenuModel(
      id: 'fav_bc_3',
      name: 'Salad',
      price: 'Rp.54.000',
      description:
          'Sayuran segar beraneka warna dengan dressing spesial nan menyegarkan.',
      imageAsset: 'assets/images/u_us_21.png',
      restaurantName: 'Black Canyon',
      restaurantCategory: 'Cepat Saji',
      isFavorite: true,
    ),
    MenuModel(
      id: 'fav_bc_4',
      name: 'Burger',
      price: 'Rp.24.000',
      description:
          'Daging juicy, sayuran segar, saus melimpah dalam roti empuk.',
      imageAsset: 'assets/images/u_us_22.png',
      restaurantName: 'Black Canyon',
      restaurantCategory: 'Cepat Saji',
      isFavorite: true,
    ),
  ];

  // Daftar Restoran (persis dari USER.svg)
  late final List<RestaurantModel> restaurants = [
    RestaurantModel(
      id: 'r_buatik',
      name: 'Warung Bu Atik',
      category: 'Ayam dan bebek, Aneka Nasi, Cepat Saji',
      address: 'Jl. Samata, Borong Indah, Makassar',
      hours: '08.00 - 22.30 WITA',
      phone: '081231492034',
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
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_fireflies',
      name: 'Fireflies',
      category: 'Cepat Saji',
      address: 'Jl. Tanjung Bayang',
      description:
          'Fireflies menghadirkan aneka sajian cepat saji modern dengan suasana tempat nongkrong yang nyaman.',
      imageAsset: 'assets/images/u_us_0.png',
      galleryAssets: const [
        'assets/images/u_us_0.png',
        'assets/images/u_us_11.png',
      ],
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_koko',
      name: 'Koko House',
      category: 'Dessert',
      address: 'Jl. Nusantara',
      description:
          'Koko House menyajikan hidangan penutup manis, pastry, dan minuman segar favorit keluarga.',
      imageAsset: 'assets/images/u_us_1.png',
      galleryAssets: const [
        'assets/images/u_us_1.png',
        'assets/images/u_us_12.png',
      ],
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_brood',
      name: 'Brood Bakery',
      category: 'Jl. Daeng Tata No 64',
      address: 'Jl. Samata, Borong Indah',
      description:
          'Brood Bakery menyediakan roti panggang segar setiap pagi dengan bahan premium.',
      imageAsset: 'assets/images/u_us_2.png',
      galleryAssets: const [
        'assets/images/u_us_2.png',
        'assets/images/u_us_12.png',
      ],
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_padanga',
      name: 'Padanga Beach',
      category: 'Dessert',
      address: 'Jl. Urip Sumoharjo',
      description:
          'Restoran tepi pantai dengan pemandangan matahari terbenam dan ragam kuliner Nusantara.',
      imageAsset: 'assets/images/u_us_3.png',
      galleryAssets: const [
        'assets/images/u_us_3.png',
        'assets/images/u_us_15.png',
      ],
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_alhamdulillah',
      name: 'Warung Alhamdulillah',
      category: 'Cepat Saji',
      address: 'Jl. Malino, Somba Opu',
      description:
          'Warung makan legendaris dengan porsi mengenyangkan dan harga ramah mahasiswa.',
      imageAsset: 'assets/images/u_us_4.png',
      galleryAssets: const [
        'assets/images/u_us_4.png',
        'assets/images/u_us_6.png',
      ],
      reviewerCount: '3rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_mba_atun',
      name: 'Rumah Makan Mba Atun',
      category: 'Seafood',
      address: 'Jl. Toddopuli Raya No 12',
      description:
          'Spesialis olahan laut segar dan masakan Jawa Timur di jantung kota Makassar.',
      imageAsset: 'assets/images/u_us_1.png',
      galleryAssets: const [
        'assets/images/u_us_1.png',
        'assets/images/u_pm_19.png',
      ],
      reviewerCount: '2rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_gedebuk',
      name: 'Ayam Sambal Gedebuk',
      category: 'Ayam',
      address: 'Jl. Pengayoman',
      description:
          'Ayam goreng krispi yang digeprek dengan sambal bawang ekstra pedas.',
      imageAsset: 'assets/images/u_us_2.png',
      galleryAssets: const [
        'assets/images/u_us_2.png',
        'assets/images/u_pm_18.png',
      ],
      reviewerCount: '3,5rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_pak_ijo',
      name: 'Pak Ijo',
      category: 'Mie',
      address: 'Jl. Hertasning Baru',
      description:
          'Aneka mie hijau sehat dan ayam cabe ijo khas.',
      imageAsset: 'assets/images/u_us_3.png',
      galleryAssets: const [
        'assets/images/u_us_3.png',
        'assets/images/u_us_18.png',
      ],
      reviewerCount: '1,8rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_geprek_mantul',
      name: 'Geprek Mantul',
      category: 'Ayam, Aneka Nasi, Cepat Saji',
      address: 'Jl. Antang Raya',
      description:
          'Ayam geprek sambal korek dengan pilihan keju mozzarella.',
      imageAsset: 'assets/images/u_us_4.png',
      galleryAssets: const [
        'assets/images/u_us_4.png',
        'assets/images/u_pm_18.png',
      ],
      reviewerCount: '2rb',
      reviews: _defaultRestaurantReviews(),
    ),
    RestaurantModel(
      id: 'r_black_canyon',
      name: 'Black Canyon',
      category: 'Cepat Saji',
      address: 'Jl. Toddopuli Raya No 12',
      description:
          'Restoran pemenang Top of the Week dengan sajian kopi, pasta, dan pizza terbaik.',
      imageAsset: 'assets/images/u_us_0.png',
      galleryAssets: const [
        'assets/images/u_us_11.png',
        'assets/images/u_us_12.png',
      ],
      reviewerCount: '4,2rb',
      isFavorite: true,
      reviews: _defaultRestaurantReviews(),
    ),
  ];

  // Percakapan default antara Pelanggan (Gibran) dan Warung Bu Atik (persis dari USER.svg & PEMILIK RESTORAN.svg)
  static List<ChatMessageModel> _defaultConversation() => const [
        ChatMessageModel(
          text:
              'Halo, selamat pagi. Saya baru saja memesan di warung bu Sri, dan saya ingin menyampaikan sedikit keluhan.',
          isCustomer: true,
        ),
        ChatMessageModel(
          text:
              'Saya memesan ayam gulai, tapi sayangnya makanan yang dapat adalah rendang. Hal ini cukup mengecewakan karena saya punya ekspektasi yang baik terhadap layanan/restoran ini. Kalau bisa, saya juga ingin tahu apakah ada solusi atau kompensasi untuk masalah ini.',
          isCustomer: true,
        ),
        ChatMessageModel(
          text:
              'Halo Kak, terima kasih sudah menghubungi kami dan menyampaikan keluhan ini.\nKami mohon maaf sebesar-besarnya atas ketidaknyamanan yang Kakak alami.',
          isCustomer: false,
        ),
        ChatMessageModel(
          text:
              'Kami sangat menghargai masukan dari pelanggan, karena itu sangat membantu kami untuk terus memperbaiki layanan.\nSebagai bentuk tanggung jawab dan permintaan maaf, kami akan mengirim ulang pesanan dan memberikan voucher.',
          isCustomer: false,
        ),
        ChatMessageModel(
          text:
              'Baik kak, terima kasih telah bertanggung jawab. lain kali hati-hati ya kak',
          isCustomer: true,
        ),
      ];

  // Daftar Chat Toko (Role USER)
  late final List<ChatThreadModel> userChats = [
    ChatThreadModel(
      id: 'uc1',
      name: 'Warung Bu Atik',
      lastMessage: 'Baik kak, terima kasih telah bertanggung...',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_12.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc2',
      name: 'Sari Laut Bang Mawa',
      lastMessage: 'Terima kasih mas',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_1.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc3',
      name: 'Bakso 99 Kubah',
      lastMessage: 'Next hati-hati lagi ya kak :(',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_2.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc4',
      name: 'Ayam Gedebuk 88',
      lastMessage: 'Next aku order lagi',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_3.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc5',
      name: 'Mie Ayam Kasih Sayang',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_4.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc6',
      name: 'Less Sugar Cafe',
      lastMessage: 'Maaf kak, kita sedang kehabisan stok Gula',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_5.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc7',
      name: 'Rumah Makan Rumit',
      lastMessage: 'Oke kak, diusahakan sesederhana mungkin',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_6.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc8',
      name: 'Pizzazitu',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_7.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc9',
      name: 'Burger Rakyat',
      lastMessage: 'Selamat menikmati...',
      time: '10.55',
      unreadCount: 1,
      avatarAsset: 'assets/images/u_pm_8.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc10',
      name: 'Bukan Bakso Boraks',
      lastMessage: 'Enak banget kaakk',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_9.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'uc11',
      name: 'Seafood Darat',
      lastMessage: 'Baik kak',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_10.png',
      messages: List.of(_defaultConversation()),
    ),
  ];

  // Daftar Chat Pelanggan (Role PEMILIK RESTORAN)
  late final List<ChatThreadModel> ownerChats = [
    ChatThreadModel(
      id: 'oc1',
      name: 'Gibran Nur Saleh',
      lastMessage: 'Baik kak, terima kasih',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_0.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc2',
      name: 'Firman Al Mana',
      lastMessage: 'Terima kasih mas',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_1.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc3',
      name: 'Kurniawan Jalil',
      lastMessage: 'Next hati-hati lagi ya kak :(',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_2.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc4',
      name: 'Ngoding123',
      lastMessage: 'Next aku order lagi',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_3.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc5',
      name: 'Jungkuk99Gamerzx',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_4.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc6',
      name: 'WibuXXpaperslove',
      lastMessage: 'Maaf kak, kita sedang kehabisan stok Gula',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_5.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc7',
      name: 'BlueBand1945',
      lastMessage: 'Oke kak, diusahakan sesederhana mungkin',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_6.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc8',
      name: 'R03L0v1s900D',
      lastMessage: 'Terima kasih sudah order jualan kita...',
      time: '10.55',
      unreadCount: 2,
      avatarAsset: 'assets/images/u_pm_7.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc9',
      name: 'Gymbro1234567',
      lastMessage: 'Selamat menikmati...',
      time: '10.55',
      unreadCount: 1,
      avatarAsset: 'assets/images/u_pm_8.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc10',
      name: 'Rapperzyz2006',
      lastMessage: 'Enak banget kaakk',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_9.png',
      messages: List.of(_defaultConversation()),
    ),
    ChatThreadModel(
      id: 'oc11',
      name: '@Qu14n76nG',
      lastMessage: 'Baik kak',
      time: '10.55',
      unreadCount: 0,
      avatarAsset: 'assets/images/u_pm_10.png',
      messages: List.of(_defaultConversation()),
    ),
  ];

  // Daftar Notifikasi Pemilik Restoran (persis dari PEMILIK RESTORAN.svg)
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
      notifyListeners();
    }
  }

  void addOwnerMenu({
    required String name,
    required String price,
    required String description,
    String imageAsset = 'assets/images/u_pm_18.png',
    String fileName = 'ayam-goreng-rica.jpg',
  }) {
    final formattedPrice =
        price.startsWith('Rp') ? price : 'Rp${price.trim()}';
    menus.insert(
      0,
      MenuModel(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        price: formattedPrice,
        description: description,
        imageAsset: imageAsset,
        fileName: fileName,
        reviews: _defaultDishReviews(),
      ),
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
    notifyListeners();
  }
}
