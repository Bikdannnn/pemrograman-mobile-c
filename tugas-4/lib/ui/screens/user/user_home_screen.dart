import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_menu_detail_screen.dart';
import 'user_restaurant_detail_screen.dart';
import 'user_search_screen.dart';

/// Layar Beranda USER sesuai `USER.svg`:
/// - Header Hijau Tua (`#183A1D`): `"Selamat Datang!"`, `"Tentukan restoran terbaik-mu dengan FoodView"`, Search Bar + Filter
/// - Carousel Banner 3 Slide dengan tombol panah kiri/kanan
/// - Kategori (5 ikon di atas kotak krem `#FEFBE9`: `Nasi`, `Minuman`, `Seafood`, `Ayam`, `Mie`)
/// - Kartu `Top of the Week` (`Black Canyon - Pastrami Pizza Rp75.000`)
/// - Bagian `Favoritku` (kartu vertikal `Ayam Goreng Rica` & `Bakso Goreng`) + `Lihat Lainnya`
/// - Bagian `Rekomendasi` (`Fireflies`, `Koko House`, `Brood Bakery`, `Padanga Beach`, `Warung Alhamdulillah`) + tombol `Lihat Lainnya`
class UserHomeScreen extends StatefulWidget {
  final VoidCallback onOpenFavoritku;

  const UserHomeScreen({
    super.key,
    required this.onOpenFavoritku,
  });

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  FoodViewFilterSelection _activeFilter = const FoodViewFilterSelection();

  static const List<({String label, IconData icon})> _categories = [
    (label: 'Nasi', icon: Icons.rice_bowl_rounded),
    (label: 'Minuman', icon: Icons.local_cafe_rounded),
    (label: 'Seafood', icon: Icons.set_meal_rounded),
    (label: 'Ayam', icon: Icons.kebab_dining_rounded),
    (label: 'Mie', icon: Icons.ramen_dining_rounded),
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: FoodViewFilterCard(
          initialSelection: _activeFilter,
          onApply: (selection) {
            Navigator.of(ctx).pop();
            setState(() => _activeFilter = selection);
            FoodViewDialogs.showStatusPopup(
              context,
              message: 'Filter diterapkan',
            );
            Future.delayed(const Duration(milliseconds: 1350), () {
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserSearchScreen(
                    initialFilter: selection,
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  void _openSearch({String? category}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserSearchScreen(
          initialCategory: category,
          initialFilter: _activeFilter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();
    final warungBuAtik = state.restaurants.first;
    final rekomendasiList = state.restaurants.skip(1).take(5).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Hijau Tua (#183A1D)
          Container(
            width: double.infinity,
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: 'Tentukan restoran terbaik-mu dengan '),
                      TextSpan(
                        text: 'FoodView',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FoodViewSearchBar(
                  readOnly: true,
                  onTap: () => _openSearch(),
                  onFilterTap: _openFilterDialog,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Banner Carousel dengan Tombol Chevron Kiri/Kanan (persis USER.svg)
          SizedBox(
            height: 156,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _bannerController,
                  itemCount: state.homeBannerAssets.length,
                  onPageChanged: (idx) => setState(() => _currentBanner = idx),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          state.homeBannerAssets[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                if (_currentBanner > 0)
                  Positioned(
                    left: 26,
                    child: _BannerArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () {
                        _bannerController.previousPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                if (_currentBanner < state.homeBannerAssets.length - 1)
                  Positioned(
                    right: 26,
                    child: _BannerArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () {
                        _bannerController.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Kategori (5 ikon di dalam kotak krem #FEFBE9)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Kategori',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _categories.map((cat) {
                return GestureDetector(
                  onTap: () => _openSearch(category: cat.label),
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: AppColors.splashCream,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          cat.icon,
                          size: 28,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cat.label,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Top of the Week (Black Canyon)
          FoodViewTopOfTheWeekCard(
            onTap: () {
              final bc = state.restaurants.firstWhere(
                (r) => r.name == 'Black Canyon',
                orElse: () => warungBuAtik,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => UserRestaurantDetailScreen(restaurant: bc),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Favoritku
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favoritku',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onOpenFavoritku,
                  child: const Text(
                    'Lihat Lainnya',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 186,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                FoodViewFavoritkuMenuCard(
                  menuName: state.menus[0].name,
                  storeName: 'Warung Bu Atik',
                  address: 'Jl. Samata, Borong Indah, Makassar',
                  imageAsset: state.menus[0].imageAsset,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            UserMenuDetailScreen(menu: state.menus[0]),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                FoodViewFavoritkuMenuCard(
                  menuName: state.menus[2].name,
                  storeName: 'Warung Bu Atik',
                  address: 'Jl. Samata, Borong Indah, Makassar',
                  imageAsset: state.menus[2].imageAsset,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            UserMenuDetailScreen(menu: state.menus[2]),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                FoodViewFavoritkuMenuCard(
                  menuName: 'Mie Ayam',
                  storeName: 'Toko Pak Ais',
                  address: 'Jl. Samata, Borong Indah, Makassar',
                  imageAsset: 'assets/images/u_us_8.png',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            UserMenuDetailScreen(menu: state.menus[0]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Rekomendasi
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Rekomendasi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (final r in rekomendasiList)
                  FoodViewRestaurantCard(
                    name: r.name,
                    category: r.category,
                    address: r.address,
                    imageAsset: r.imageAsset,
                    reviewerCount: r.reviewerCount,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserRestaurantDetailScreen(
                            restaurant: warungBuAtik,
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 8),
                FoodViewPrimaryButton(
                  text: 'Lihat Lainnya',
                  onPressed: () => _openSearch(),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _BannerArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(220),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}
