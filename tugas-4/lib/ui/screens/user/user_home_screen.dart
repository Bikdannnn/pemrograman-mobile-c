import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/open_culinary_api_service.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_menu_detail_screen.dart';
import 'user_restaurant_detail_screen.dart';
import 'user_search_screen.dart';

/// Layar Beranda USER:
/// - Header Hijau Tua (`#183A1D`) bersih: `"Selamat Datang!"`, Search Bar + Filter
/// - Carousel Banner 3 Slide
/// - Kategori (5 ikon)
/// - Banner Info Cuaca Kuliner Makassar real-time (`Open-Meteo REST API`)
/// - Top of the Week (restoran pertama / terpopuler)
/// - Favoritku (menu favorit dinamis dari API)
/// - Inspirasi Kuliner Open API (`DummyJSON Recipes` & `TheMealDB Open API`)
/// - Rekomendasi (restoran terdekat berdasarkan GPS)
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
    final rekomendasiList = state.restaurants.take(6).toList();
    // Menu favorit dinamis dari API (menggantikan hardcoded IDs)
    final favoritHomeMenus = state.menus
        .where((m) => m.isFavorite)
        .take(5)
        .toList();
    // Jika belum ada favorit, tampilkan 5 menu pertama
    final displayFavoritMenus = favoritHomeMenus.isNotEmpty
        ? favoritHomeMenus
        : state.menus.take(5).toList();

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      onRefresh: () async {
        await Future.wait([
          state.loadOpenApiDishes(),
          state.loadWeatherRecommendation(),
          state.fetchAggregatedMultiApiData(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hijau Tua (#183A1D) persis Figma
            Container(
              width: double.infinity,
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 11.5,
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
                  // Info lokasi pengguna
                  if (state.userLatitude != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 11,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Lokasi: ${state.userLatitude!.toStringAsFixed(4)}, ${state.userLongitude!.toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
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

            // Banner Carousel
            if (state.restaurants.isNotEmpty)
              SizedBox(
                height: 158,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _bannerController,
                      itemCount: state.homeBannerAssets.length,
                      onPageChanged: (idx) =>
                          setState(() => _currentBanner = idx),
                      itemBuilder: (context, index) {
                        final targetRestaurant =
                            state.restaurants[index % state.restaurants.length];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserRestaurantDetailScreen(
                                  restaurant: targetRestaurant,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                state.homeBannerAssets[index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
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
              )
            else
              const SizedBox(height: 158),

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

            // Widget Konteks Cuaca & Rekomendasi Kuliner (Open-Meteo Open API)
            if (state.weatherContext != null) ...[
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _openSearch(
                    category: state.weatherContext!.recommendedCategory,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreenPill,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_rounded,
                          size: 18,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cuaca Kuliner • ${state.weatherContext!.conditionLabel}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              Text(
                                state.weatherContext!.culinaryTip,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.primaryGreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Top of the Week (restoran pertama yang tersedia)
            if (state.restaurants.isNotEmpty)
              FoodViewTopOfTheWeekCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserRestaurantDetailScreen(
                        restaurant: state.restaurants.first,
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),

            // Favoritku (menu dinamis dari API)
            if (displayFavoritMenus.isNotEmpty) ...[
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
                height: 188,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: displayFavoritMenus.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final menu = displayFavoritMenus[index];
                    return FoodViewFavoritkuMenuCard(
                      menuName: menu.name,
                      storeName: menu.restaurantName,
                      address: menu.restaurantAddress,
                      imageAsset: menu.imageAsset,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UserMenuDetailScreen(menu: menu),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Eksplorasi Kuliner Dunia (Open-Source API: DummyJSON Recipes & TheMealDB)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Inspirasi Kuliner (Open API)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => state.loadOpenApiDishes(),
                    child: const Text(
                      'Muat Ulang API',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            state.openDishesState.match(
              onInitial: () => const SizedBox.shrink(),
              onLoading: (_) => const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              onError: (err, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  err,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGray),
                ),
              ),
              onSuccess: (List<OpenApiDishModel> dishes) {
                return SizedBox(
                  height: 186,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: dishes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final dish = dishes[index];
                      return _OpenApiDishCard(
                        dish: dish,
                        onTap: () {
                          final menuModel =
                              state.convertOpenApiDishToMenuModel(dish);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  UserMenuDetailScreen(menu: menuModel),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // Rekomendasi (restoran terdekat berdasarkan GPS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Rekomendasi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (state.userLatitude != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreenPill,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.near_me_rounded,
                            size: 10,
                            color: AppColors.primaryGreen,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Terdekat',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (state.isLoadingAggregator && rekomendasiList.isEmpty)
              const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            else if (rekomendasiList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Belum ada restoran. Tarik ke bawah untuk memuat ulang.',
                  style: TextStyle(fontSize: 11, color: AppColors.textGray),
                ),
              )
            else
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
                        reviewerCount: r.distanceFromUser != null
                            ? LocationService.formatDistance(
                                r.distanceFromUser!)
                            : r.reviewerCount,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserRestaurantDetailScreen(
                                restaurant: r,
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
      ),
    );
  }
}

class _OpenApiDishCard extends StatelessWidget {
  final OpenApiDishModel dish;
  final VoidCallback onTap;

  const _OpenApiDishCard({
    required this.dish,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: dish.imageUrl.isNotEmpty
                      ? Image.network(
                          dish.imageUrl,
                          width: 156,
                          height: 102,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/u_pm_18.png',
                            width: 156,
                            height: 102,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/u_pm_18.png',
                          width: 156,
                          height: 102,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 11,
                          color: AppColors.starYellow,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          dish.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${dish.areaOrCuisine} • ${dish.caloriesPerServing} kkal',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppColors.textGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dish.estimatedPrice,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
