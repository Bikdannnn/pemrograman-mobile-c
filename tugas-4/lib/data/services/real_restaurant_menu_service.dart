import '../../ui/view_models/foodview_ui_state.dart';

/// Layanan katalog menu nyata (authentic & real data) untuk setiap restoran di Makassar/Gowa.
/// Menyediakan hidangan asli yang memang disajikan oleh masing-masing restoran.
class RealRestaurantMenuService {
  static List<MenuModel> getAllRealMenus() {
    return [
      ..._buAtikMenus,
      ..._bebekGazeboMenus,
      ..._mieTitiMenus,
      ..._konroKarebosiMenus,
      ..._cotoNusantaraMenus,
      ..._nelayanSeafoodMenus,
      ..._blackCanyonMenus,
    ];
  }

  static List<MenuModel> getMenusForRestaurantId(String restaurantId) {
    switch (restaurantId) {
      case 'fsq_makassar_01':
      case 'r_buatik':
        return _buAtikMenus;
      case 'fsq_makassar_07':
      case 'r_bebek_gazebo':
        return _bebekGazeboMenus;
      case 'fsq_makassar_06':
      case 'r_mie_titi':
        return _mieTitiMenus;
      case 'fsq_makassar_04':
      case 'r_konro_karebosi':
        return _konroKarebosiMenus;
      case 'fsq_makassar_05':
      case 'r_coto_nusantara':
        return _cotoNusantaraMenus;
      case 'fsq_makassar_03':
      case 'r_nelayan_seafood':
        return _nelayanSeafoodMenus;
      case 'fsq_makassar_02':
      case 'r_black_canyon':
        return _blackCanyonMenus;
      default:
        return _buAtikMenus;
    }
  }

  // 1. Warung Bu Atik (Samata, Somba Opu)
  static final List<MenuModel> _buAtikMenus = [
    MenuModel(
      id: 'm_atik_01',
      restaurantId: 'fsq_makassar_01',
      name: 'Ayam Geprek Sambal Bawang',
      price: 'Rp18.000',
      description:
          'Ayam goreng krispi renyah diulek langsung dengan cabai rawit merah dan bawang putih segar khas Bu Atik, disajikan hangat dengan lalapan.',
      imageAsset: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Somba Opu, Gowa/Makassar',
      reviewerCount: '4,8rb',
      categoryTag: 'Ayam',
      ingredients: ['Daging Ayam Segar', 'Tepung Bumbu Krispi', 'Cabai Rawit Merah', 'Bawang Putih', 'Minyak Nabati'],
      calories: 480,
      reviews: [
        const ReviewModel(
          userName: 'Rian Pratama',
          comment: 'Sambal bawangnya nendang banget dan ayamnya gurih krispi sampai dalam!',
          avatarAsset: 'https://randomuser.me/api/portraits/men/32.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_atik_02',
      restaurantId: 'fsq_makassar_01',
      name: 'Ayam Bakar Madu Samata',
      price: 'Rp20.000',
      description:
          'Ayam bakar bumbu kecap madu gurih manis meresap sampai ke tulang, dibakar arang dan disajikan dengan sambal terasi serta lalapan.',
      imageAsset: 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Somba Opu, Gowa/Makassar',
      reviewerCount: '3,9rb',
      categoryTag: 'Ayam',
      ingredients: ['Ayam Potong', 'Madu Hutan Asli', 'Kecap Manis', 'Bawang Merah', 'Ketumbar', 'Jeruk Limau'],
      calories: 440,
    ),
    MenuModel(
      id: 'm_atik_03',
      restaurantId: 'fsq_makassar_01',
      name: 'Nasi Campur Bu Atik',
      price: 'Rp22.000',
      description:
          'Nasi putih pulen dengan lauk lengkap: ayam suwir balado, telur pindang, orek tempe gurih, serundeng kelapa, dan sambal terasi.',
      imageAsset: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Somba Opu, Gowa/Makassar',
      reviewerCount: '2,7rb',
      categoryTag: 'Nasi',
      ingredients: ['Beras Pandan Wangi', 'Ayam Suwir', 'Telur Balado', 'Tempe Orek', 'Serundeng', 'Sambal Terasi'],
      calories: 520,
    ),
    MenuModel(
      id: 'm_atik_04',
      restaurantId: 'fsq_makassar_01',
      name: 'Ayam Goreng Lengkuas',
      price: 'Rp19.000',
      description:
          'Ayam goreng rempah tradisional dengan taburan parutan lengkuas garing yang melimpah, wangi, dan renyah di setiap gigitan.',
      imageAsset: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Somba Opu, Gowa/Makassar',
      reviewerCount: '3,1rb',
      categoryTag: 'Ayam',
      ingredients: ['Ayam Segar', 'Lengkuas Parut', 'Kunyit', 'Bawang Putih', 'Ketumbar', 'Minyak Kelapa'],
      calories: 460,
    ),
    MenuModel(
      id: 'm_atik_05',
      restaurantId: 'fsq_makassar_01',
      name: 'Tahu & Tempe Penyet Cobek',
      price: 'Rp10.000',
      description:
          'Tahu putih sutra dan tempe kedelai murni digoreng gurih dipenyet di atas cobek batu dengan sambal terasi pedas manis.',
      imageAsset: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Somba Opu, Gowa/Makassar',
      reviewerCount: '1,5rb',
      categoryTag: 'Lauk',
      ingredients: ['Tahu Putih Segar', 'Tempe Kedelai', 'Cabai Rawit', 'Terasi Bakar', 'Tomat', 'Gula Merah'],
      calories: 220,
    ),
    MenuModel(
      id: 'm_atik_06',
      restaurantId: 'fsq_makassar_01',
      name: 'Es Jeruk Peras Segar',
      price: 'Rp8.000',
      description:
          'Perasan jeruk pontianak manis alami berpadu es batu jernih, manis asam segar menyegarkan tenggorokan.',
      imageAsset: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Warung Bu Atik',
      restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
      restaurantAddress: 'Jl. Samata, Borong Indah, Somba Opu, Gowa/Makassar',
      reviewerCount: '2,2rb',
      categoryTag: 'Minuman',
      ingredients: ['Jeruk Peras Manis', 'Gula Pasir Asli', 'Air Es', 'Es Batu Kristal'],
      calories: 90,
    ),
  ];

  // 2. Bebek Gazebo Samata (Jl. H. M. Yasin Limpo, Gowa)
  static final List<MenuModel> _bebekGazeboMenus = [
    MenuModel(
      id: 'm_gazebo_01',
      restaurantId: 'fsq_makassar_07',
      name: 'Bebek Goreng Sambal Korek',
      price: 'Rp35.000',
      description:
          'Bebek empuk bumbu rempah kuning digoreng renyah garing di luar, disiram sambal korek rawit pedas nendang khas Gazebo.',
      imageAsset: 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Bebek Gazebo Samata',
      restaurantCategory: 'Bebek Goreng Sambal Korek & Lalapan',
      restaurantAddress: 'Jl. H. M. Yasin Limpo No. 8, Samata, Gowa',
      reviewerCount: '3,8rb',
      categoryTag: 'Bebek',
      ingredients: ['Daging Bebek Muda', 'Kunyit', 'Jahe', 'Cabai Rawit Merah', 'Minyak Panas', 'Garam Laut'],
      calories: 550,
      reviews: [
        const ReviewModel(
          userName: 'Fajar Nugraha',
          comment: 'Bebeknya bener-bener empuk gak amis sama sekali, sambal koreknya juara!',
          avatarAsset: 'https://randomuser.me/api/portraits/men/45.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_gazebo_02',
      restaurantId: 'fsq_makassar_07',
      name: 'Bebek Bakar Bumbu Rujak',
      price: 'Rp37.000',
      description:
          'Bebek bakar arang dengan baluran bumbu rujak manis pedas gurih yang meresap sempurna ke dalam serat daging bebek.',
      imageAsset: 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Bebek Gazebo Samata',
      restaurantCategory: 'Bebek Goreng Sambal Korek & Lalapan',
      restaurantAddress: 'Jl. H. M. Yasin Limpo No. 8, Samata, Gowa',
      reviewerCount: '2,9rb',
      categoryTag: 'Bebek',
      ingredients: ['Daging Bebek', 'Gula Aren', 'Cabai Merah', 'Asam Jawa', 'Bawang Merah', 'Santan'],
      calories: 510,
    ),
    MenuModel(
      id: 'm_gazebo_03',
      restaurantId: 'fsq_makassar_07',
      name: 'Bebek Cabe Ijo Samata',
      price: 'Rp36.000',
      description:
          'Potongan bebek ungkep gurih dilumuri sambal cabai hijau ulek kasar beraroma daun jeruk yang segar dan tidak bikin eneg.',
      imageAsset: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Bebek Gazebo Samata',
      restaurantCategory: 'Bebek Goreng Sambal Korek & Lalapan',
      restaurantAddress: 'Jl. H. M. Yasin Limpo No. 8, Samata, Gowa',
      reviewerCount: '2,1rb',
      categoryTag: 'Bebek',
      ingredients: ['Bebek Segar', 'Cabai Hijau Besar', 'Cabai Rawit Hijau', 'Tomat Hijau', 'Bawang Merah'],
      calories: 530,
    ),
    MenuModel(
      id: 'm_gazebo_04',
      restaurantId: 'fsq_makassar_07',
      name: 'Cah Kangkung Terasi',
      price: 'Rp14.000',
      description:
          'Kangkung segar ditumis dengan api besar, terasi bakar khas pesisir, dan irisan cabai merah gurih pedas.',
      imageAsset: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Bebek Gazebo Samata',
      restaurantCategory: 'Bebek Goreng Sambal Korek & Lalapan',
      restaurantAddress: 'Jl. H. M. Yasin Limpo No. 8, Samata, Gowa',
      reviewerCount: '1,8rb',
      categoryTag: 'Sayuran',
      ingredients: ['Kangkung Segar', 'Terasi Bakar', 'Bawang Putih', 'Cabai Merah', 'Saus Tiram'],
      calories: 140,
    ),
    MenuModel(
      id: 'm_gazebo_05',
      restaurantId: 'fsq_makassar_07',
      name: 'Es Kelapa Muda Gula Merah',
      price: 'Rp12.000',
      description:
          'Air kelapa muda murni beserta kerokan kelapa segar disajikan dengan sirup gula aren asli dan es batu kristal.',
      imageAsset: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Bebek Gazebo Samata',
      restaurantCategory: 'Bebek Goreng Sambal Korek & Lalapan',
      restaurantAddress: 'Jl. H. M. Yasin Limpo No. 8, Samata, Gowa',
      reviewerCount: '2,6rb',
      categoryTag: 'Minuman',
      ingredients: ['Kelapa Muda Murni', 'Daging Kelapa', 'Gula Aren Cair', 'Es Batu'],
      calories: 120,
    ),
  ];

  // 3. Mie Titi Panakkukang (Jl. Boulevard, Panakkukang, Makassar)
  static final List<MenuModel> _mieTitiMenus = [
    MenuModel(
      id: 'm_titi_01',
      restaurantId: 'fsq_makassar_06',
      name: 'Mie Titi Ayam Spesial',
      price: 'Rp34.000',
      description:
          'Mie kuning kering garing renyah khas Makassar disiram kuah telur kental gurih berisikan suwiran ayam, hati ayam, dan sawi hijau segar.',
      imageAsset: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Mie Titi Panakkukang',
      restaurantCategory: 'Mie Kering Tradisional Khas Makassar',
      restaurantAddress: 'Jl. Boulevard No. 25, Panakkukang, Makassar',
      reviewerCount: '5,2rb',
      categoryTag: 'Mie',
      ingredients: ['Mie Kuning Kering', 'Daging Ayam', 'Telur Ayam', 'Tepung Kanji', 'Sawi Hijau', 'Kaldu Gurih'],
      calories: 490,
      reviews: [
        const ReviewModel(
          userName: 'Nurul Hidayah',
          comment: 'Rasa mie titinya autentik banget! Kuah kentalnya pas dimakan selagi panas dengan perasan jeruk nipis dan lombok kuning.',
          avatarAsset: 'https://randomuser.me/api/portraits/women/44.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_titi_02',
      restaurantId: 'fsq_makassar_06',
      name: 'Mie Titi Seafood Komplit',
      price: 'Rp42.000',
      description:
          'Mie kering legendaris disiram kuah kental panas dengan limpahan udang segar, potongan cumi kenyal, bakso ikan, dan sayuran hijau.',
      imageAsset: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Mie Titi Panakkukang',
      restaurantCategory: 'Mie Kering Tradisional Khas Makassar',
      restaurantAddress: 'Jl. Boulevard No. 25, Panakkukang, Makassar',
      reviewerCount: '4,4rb',
      categoryTag: 'Mie',
      ingredients: ['Mie Kering', 'Udang Segar', 'Cumi Laut', 'Bakso Ikan', 'Sawi Hijau', 'Kuah Telur Kental'],
      calories: 520,
    ),
    MenuModel(
      id: 'm_titi_03',
      restaurantId: 'fsq_makassar_06',
      name: 'Nasi Goreng Merah Makassar',
      price: 'Rp32.000',
      description:
          'Nasi goreng berwarna merah alami dengan saus tomat khas Makassar, berisikan potongan bakso sapi, telur, dan suwiran ayam gurih.',
      imageAsset: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Mie Titi Panakkukang',
      restaurantCategory: 'Mie Kering Tradisional Khas Makassar',
      restaurantAddress: 'Jl. Boulevard No. 25, Panakkukang, Makassar',
      reviewerCount: '3,3rb',
      categoryTag: 'Nasi',
      ingredients: ['Beras Putih', 'Saus Merah Makassar', 'Bakso Sapi', 'Telur', 'Bawang Goreng', 'Acar Timun'],
      calories: 560,
    ),
    MenuModel(
      id: 'm_titi_04',
      restaurantId: 'fsq_makassar_06',
      name: 'Pangsit Goreng Crispy',
      price: 'Rp25.000',
      description:
          'Kulit pangsit renyah keemasan isi olahan daging ayam dan udang cincang, disajikan bersama saus asam manis cocolan spesial.',
      imageAsset: 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Mie Titi Panakkukang',
      restaurantCategory: 'Mie Kering Tradisional Khas Makassar',
      restaurantAddress: 'Jl. Boulevard No. 25, Panakkukang, Makassar',
      reviewerCount: '2,9rb',
      categoryTag: 'Camilan',
      ingredients: ['Kulit Pangsit', 'Daging Ayam Cincang', 'Udang', 'Minyak Wijen', 'Saus Asam Manis'],
      calories: 340,
    ),
    MenuModel(
      id: 'm_titi_05',
      restaurantId: 'fsq_makassar_06',
      name: 'Es Markisa Asli Makassar',
      price: 'Rp15.000',
      description:
          'Minuman sari buah markisa asli dari dataran tinggi Malino yang berasa manis asam segar beraroma khas buah tropis.',
      imageAsset: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Mie Titi Panakkukang',
      restaurantCategory: 'Mie Kering Tradisional Khas Makassar',
      restaurantAddress: 'Jl. Boulevard No. 25, Panakkukang, Makassar',
      reviewerCount: '3,7rb',
      categoryTag: 'Minuman',
      ingredients: ['Sari Markisa Asli', 'Gula Tebu Alami', 'Air Mineral', 'Es Batu'],
      calories: 110,
    ),
  ];

  // 4. Konro Karebosi (Jl. Gunung Lompobattang, Makassar)
  static final List<MenuModel> _konroKarebosiMenus = [
    MenuModel(
      id: 'm_konro_01',
      restaurantId: 'fsq_makassar_04',
      name: 'Konro Bakar Saus Kacang Karebosi',
      price: 'Rp68.000',
      description:
          'Iga sapi jumbo empuk yang dibakar di atas arang dengan aroma *smoky*, dilumuri saus kacang gurih pekat legendaris dan kuah sup konro terpisah.',
      imageAsset: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Konro Karebosi',
      restaurantCategory: 'Sup Konro & Konro Bakar Khas Makassar',
      restaurantAddress: 'Jl. Gunung Lompobattang No. 41, Pisang Utara, Makassar',
      reviewerCount: '6,1rb',
      categoryTag: 'Daging',
      ingredients: ['Iga Sapi Pilihan', 'Bumbu Kacang Tanah Gurih', 'Kecap Manis', 'Bawang Goreng', 'Jeruk Nipis'],
      calories: 680,
      reviews: [
        const ReviewModel(
          userName: 'Bambang Soediro',
          comment: 'Konro bakar terbaik di Indonesia! Dagingnya lepas dari tulang dengan mudah, saus kacangnya tiada duanya.',
          avatarAsset: 'https://randomuser.me/api/portraits/men/52.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_konro_02',
      restaurantId: 'fsq_makassar_04',
      name: 'Sup Konro Iga Sapi Tradisional',
      price: 'Rp65.000',
      description:
          'Sup iga sapi khas Makassar dengan kuah rempah keluwak hitam pekat kaya bumbu seperti cengkeh, ketumbar, dan kayu manis berpadu gurih.',
      imageAsset: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Konro Karebosi',
      restaurantCategory: 'Sup Konro & Konro Bakar Khas Makassar',
      restaurantAddress: 'Jl. Gunung Lompobattang No. 41, Pisang Utara, Makassar',
      reviewerCount: '4,9rb',
      categoryTag: 'Daging',
      ingredients: ['Iga Sapi Lokal', 'Kluwek', 'Kayu Manis', 'Cengkeh', 'Bawang Merah', 'Daun Bawang'],
      calories: 620,
    ),
    MenuModel(
      id: 'm_konro_03',
      restaurantId: 'fsq_makassar_04',
      name: 'Es Pisang Ijo Asli Karebosi',
      price: 'Rp18.000',
      description:
          'Pisang raja matang dibalut adonan tepung hijau pandan lembut, disajikan dengan bubur sumsum wangi, es serut, dan siraman sirup DHT merah.',
      imageAsset: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Konro Karebosi',
      restaurantCategory: 'Sup Konro & Konro Bakar Khas Makassar',
      restaurantAddress: 'Jl. Gunung Lompobattang No. 41, Pisang Utara, Makassar',
      reviewerCount: '5,5rb',
      categoryTag: 'Dessert',
      ingredients: ['Pisang Raja', 'Tepung Beras', 'Daun Suji & Pandan', 'Santan Kental', 'Sirup DHT Merah', 'Susu Kental Manis'],
      calories: 320,
    ),
    MenuModel(
      id: 'm_konro_04',
      restaurantId: 'fsq_makassar_04',
      name: 'Ketupat Daun Pandan',
      price: 'Rp5.000',
      description:
          'Ketupat beras pulen yang dimasak berjam-jam dalam balutan anyaman daun kelapa wangi pandan, pasangan sejati menyantap konro.',
      imageAsset: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Konro Karebosi',
      restaurantCategory: 'Sup Konro & Konro Bakar Khas Makassar',
      restaurantAddress: 'Jl. Gunung Lompobattang No. 41, Pisang Utara, Makassar',
      reviewerCount: '2,8rb',
      categoryTag: 'Nasi',
      ingredients: ['Beras Pilihan', 'Daun Pandan', 'Air Bersih'],
      calories: 160,
    ),
  ];

  // 5. Coto Nusantara Makassar (Jl. Nusantara, Wajo, Makassar)
  static final List<MenuModel> _cotoNusantaraMenus = [
    MenuModel(
      id: 'm_coto_01',
      restaurantId: 'fsq_makassar_05',
      name: 'Coto Makassar Daging Sapi Murni',
      price: 'Rp32.000',
      description:
          'Semangkuk coto legendaris dengan potongan daging sapi lokal empuk dalam kuah kaldu rempah 40 macam bumbu dan kacang tanah sangrai halus.',
      imageAsset: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Coto Nusantara Makassar',
      restaurantCategory: 'Coto Makassar & Ketupat Tradisional',
      restaurantAddress: 'Jl. Nusantara No. 32, Wajo, Makassar',
      reviewerCount: '6,4rb',
      categoryTag: 'Daging',
      ingredients: ['Daging Sapi Lokal', 'Kacang Tanah Sangrai', 'Serai', 'Lengkuas', 'Ketumbar', 'Bawang Goreng'],
      calories: 520,
      reviews: [
        const ReviewModel(
          userName: 'Andi Mallarangeng',
          comment: 'Coto paling gurih dan autentik di Makassar. Kuah kacangnya pekat dan daging sapinya melimpah!',
          avatarAsset: 'https://randomuser.me/api/portraits/men/68.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_coto_02',
      restaurantId: 'fsq_makassar_05',
      name: 'Coto Makassar Campur Spesial',
      price: 'Rp30.000',
      description:
          'Coto kuah pekat gurih berisikan kombinasi daging sapi empuk, babat lembut, paru goreng renyah, dan hati sapi segar.',
      imageAsset: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Coto Nusantara Makassar',
      restaurantCategory: 'Coto Makassar & Ketupat Tradisional',
      restaurantAddress: 'Jl. Nusantara No. 32, Wajo, Makassar',
      reviewerCount: '5,1rb',
      categoryTag: 'Daging',
      ingredients: ['Daging Sapi', 'Babat Sapi', 'Paru Goreng', 'Hati Sapi', 'Kaldu Rempah Nusantara'],
      calories: 560,
    ),
    MenuModel(
      id: 'm_coto_03',
      restaurantId: 'fsq_makassar_05',
      name: 'Ketupat Mini & Buras',
      price: 'Rp3.000',
      description:
          'Ketupat mini pulen dan buras santan gurih berbalut daun pisang, pendamping wajib menikmati setiap seruputan kuah coto.',
      imageAsset: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Coto Nusantara Makassar',
      restaurantCategory: 'Coto Makassar & Ketupat Tradisional',
      restaurantAddress: 'Jl. Nusantara No. 32, Wajo, Makassar',
      reviewerCount: '4,0rb',
      categoryTag: 'Nasi',
      ingredients: ['Beras Ketan & Beras Putih', 'Santan Gurih', 'Garam', 'Daun Pisang'],
      calories: 140,
    ),
    MenuModel(
      id: 'm_coto_04',
      restaurantId: 'fsq_makassar_05',
      name: 'Es Sirup DHT Susu',
      price: 'Rp10.000',
      description:
          'Minuman legendaris Makassar bercita rasa sirup pisang ambon merah dipadukan dengan krimer kental manis dan es batu segar.',
      imageAsset: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Coto Nusantara Makassar',
      restaurantCategory: 'Coto Makassar & Ketupat Tradisional',
      restaurantAddress: 'Jl. Nusantara No. 32, Wajo, Makassar',
      reviewerCount: '3,5rb',
      categoryTag: 'Minuman',
      ingredients: ['Sirup DHT Merah Asli', 'Susu Kental Manis', 'Air Matang', 'Es Batu'],
      calories: 160,
    ),
  ];

  // 6. Rumah Makan Nelayan Seafood (Jl. Ali Malaka, Losari, Makassar)
  static final List<MenuModel> _nelayanSeafoodMenus = [
    MenuModel(
      id: 'm_nelayan_01',
      restaurantId: 'fsq_makassar_03',
      name: 'Ikan Baronang Bakar Parape',
      price: 'Rp55.000',
      description:
          'Ikan baronang laut segar dibakar di atas arang batok kelapa dilumuri bumbu parape manis asam gurih khas Bugis-Makassar dari karamelisasi bawang merah dan asam jawa.',
      imageAsset: 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Rumah Makan Nelayan Seafood',
      restaurantCategory: 'Seafood, Aneka Ikan Bakar, Nusantara',
      restaurantAddress: 'Jl. Ali Malaka No. 25, Losari, Makassar',
      reviewerCount: '4,6rb',
      categoryTag: 'Seafood',
      ingredients: ['Ikan Baronang Laut Segar', 'Bumbu Parape', 'Bawang Merah', 'Gula Merah', 'Asam Jawa'],
      calories: 410,
      reviews: [
        const ReviewModel(
          userName: 'Dewi Lestari',
          comment: 'Bumbu parape-nya kental dan legit! Ikannya bener-bener segar langsung dari tangkapan nelayan.',
          avatarAsset: 'https://randomuser.me/api/portraits/women/65.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_nelayan_02',
      restaurantId: 'fsq_makassar_03',
      name: 'Udang Windu Bakar Madu',
      price: 'Rp58.000',
      description:
          'Udang windu berukuran besar dibakar dengan sapuan madu alami dan mentega wangi, daging udangnya manis kenyal dan gurih.',
      imageAsset: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Rumah Makan Nelayan Seafood',
      restaurantCategory: 'Seafood, Aneka Ikan Bakar, Nusantara',
      restaurantAddress: 'Jl. Ali Malaka No. 25, Losari, Makassar',
      reviewerCount: '3,9rb',
      categoryTag: 'Seafood',
      ingredients: ['Udang Windu Laut', 'Madu Murni', 'Mentega Gurih', 'Bawang Putih', 'Jeruk Nipis'],
      calories: 360,
    ),
    MenuModel(
      id: 'm_nelayan_03',
      restaurantId: 'fsq_makassar_03',
      name: 'Cumi Goreng Tepung Crispy',
      price: 'Rp42.000',
      description:
          'Cincin cumi segar digoreng tepung garing renyah keemasan, kenyal empuk di dalam disajikan bersama saus cocolan asam manis.',
      imageAsset: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Rumah Makan Nelayan Seafood',
      restaurantCategory: 'Seafood, Aneka Ikan Bakar, Nusantara',
      restaurantAddress: 'Jl. Ali Malaka No. 25, Losari, Makassar',
      reviewerCount: '3,1rb',
      categoryTag: 'Seafood',
      ingredients: ['Cumi Segar', 'Tepung Bumbu Renyah', 'Telur', 'Merica', 'Saus Asam Manis'],
      calories: 390,
    ),
    MenuModel(
      id: 'm_nelayan_04',
      restaurantId: 'fsq_makassar_03',
      name: 'Es Kelapa Jeruk Losari',
      price: 'Rp15.000',
      description:
          'Perpaduan daging kelapa muda lembut, air kelapa segar, dan perasan jeruk manis alami pelepas dahaga di pinggir pantai Losari.',
      imageAsset: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Rumah Makan Nelayan Seafood',
      restaurantCategory: 'Seafood, Aneka Ikan Bakar, Nusantara',
      restaurantAddress: 'Jl. Ali Malaka No. 25, Losari, Makassar',
      reviewerCount: '2,8rb',
      categoryTag: 'Minuman',
      ingredients: ['Kelapa Muda', 'Jeruk Peras Manis', 'Air Kelapa', 'Es Batu'],
      calories: 110,
    ),
  ];

  // 7. Black Canyon Coffee & Resto (Jl. Pattimura, Ujung Pandang, Makassar)
  static final List<MenuModel> _blackCanyonMenus = [
    MenuModel(
      id: 'm_canyon_01',
      restaurantId: 'fsq_makassar_02',
      name: 'Black Canyon Iced Coffee Signature',
      price: 'Rp36.000',
      description:
          'Kopi racikan khas Black Canyon dengan cita rasa pekat seimbang berpadu susu kental manis dan lapisan busa lembut di atasnya.',
      imageAsset: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Black Canyon Coffee & Resto',
      restaurantCategory: 'Western, Coffee, Cafe',
      restaurantAddress: 'Jl. Pattimura No. 34, Ujung Pandang, Makassar',
      reviewerCount: '4,5rb',
      categoryTag: 'Kopi',
      ingredients: ['Espresso Blend Spesial', 'Susu Segar', 'Krimer Lembut', 'Es Batu Kristal'],
      calories: 190,
      reviews: [
        const ReviewModel(
          userName: 'Kevin Anggara',
          comment: 'Kopinya mantap dan aromanya wangi banget, tempat paling asyik buat nongkrong dan kerja.',
          avatarAsset: 'https://randomuser.me/api/portraits/men/28.jpg',
          rating: 5.0,
        ),
      ],
    ),
    MenuModel(
      id: 'm_canyon_02',
      restaurantId: 'fsq_makassar_02',
      name: 'Grilled Sirloin Steak with BBQ Mushroom',
      price: 'Rp78.000',
      description:
          'Daging sapi sirloin impor panggang empuk *juicy* disajikan dengan kentang goreng renyah, sayuran rebus, dan saus jamur BBQ kental.',
      imageAsset: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Black Canyon Coffee & Resto',
      restaurantCategory: 'Western, Coffee, Cafe',
      restaurantAddress: 'Jl. Pattimura No. 34, Ujung Pandang, Makassar',
      reviewerCount: '3,7rb',
      categoryTag: 'Western',
      ingredients: ['Daging Sapi Sirloin', 'Saus Jamur BBQ', 'Kentang Goreng', 'Buncis & Wortel', 'Mentega Herbal'],
      calories: 670,
    ),
    MenuModel(
      id: 'm_canyon_03',
      restaurantId: 'fsq_makassar_02',
      name: 'Spaghetti Carbonara Smoked Beef',
      price: 'Rp48.000',
      description:
          'Pasta spaghetti al dente diselimuti saus krim keju gurih creamy dengan irisan daging sapi asap melimpah dan taburan keju parmesan.',
      imageAsset: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Black Canyon Coffee & Resto',
      restaurantCategory: 'Western, Coffee, Cafe',
      restaurantAddress: 'Jl. Pattimura No. 34, Ujung Pandang, Makassar',
      reviewerCount: '3,2rb',
      categoryTag: 'Pasta',
      ingredients: ['Pasta Spaghetti', 'Saus Krim Keju', 'Daging Sapi Asap', 'Kuning Telur', 'Keju Parmesan'],
      calories: 580,
    ),
    MenuModel(
      id: 'm_canyon_04',
      restaurantId: 'fsq_makassar_02',
      name: 'Pad Thai Chicken & Shrimp',
      price: 'Rp45.000',
      description:
          'Kwetiau pipih khas Thailand ditumis dengan saus asam manis gurih, suwiran ayam, udang segar, tauge, dan taburan kacang tanah sangrai.',
      imageAsset: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Black Canyon Coffee & Resto',
      restaurantCategory: 'Western, Coffee, Cafe',
      restaurantAddress: 'Jl. Pattimura No. 34, Ujung Pandang, Makassar',
      reviewerCount: '2,9rb',
      categoryTag: 'Asian',
      ingredients: ['Kwetiau Beras', 'Udang', 'Ayam', 'Tauge', 'Telur', 'Saus Pad Thai', 'Kacang Sangrai'],
      calories: 510,
    ),
    MenuModel(
      id: 'm_canyon_05',
      restaurantId: 'fsq_makassar_02',
      name: 'Green Tea Matcha Frappe',
      price: 'Rp38.000',
      description:
          'Matcha Jepang murni dingin diblender halus dengan susu segar dan es batu, disajikan dengan topping *whipped cream* lembut.',
      imageAsset: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      networkImageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600&auto=format&fit=crop&q=80',
      restaurantName: 'Black Canyon Coffee & Resto',
      restaurantCategory: 'Western, Coffee, Cafe',
      restaurantAddress: 'Jl. Pattimura No. 34, Ujung Pandang, Makassar',
      reviewerCount: '3,4rb',
      categoryTag: 'Minuman',
      ingredients: ['Bubuk Matcha Uji', 'Susu Segar Full Cream', 'Whipped Cream', 'Gula Tebu Cair'],
      calories: 260,
    ),
  ];
}
