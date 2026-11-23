import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/advanced_dart/api_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_auth_screen.dart';
import 'user_menu_detail_screen.dart';

/// Layar Detail Restoran Dinamis sesuai `USER.svg`:
/// - Menampilkan Peta OpenStreetMap Live sesuai koordinat asli restoran yang dipilih (`latitude`, `longitude`)
/// - Menampilkan Menu spesifik milik restoran yang dipilih (`state.getMenusForRestaurant(restaurant)`)
/// - Menampilkan Tentang & Ulasan spesifik restoran tersebut beserta rangkuman Record `calculateRatingSummary`
class UserRestaurantDetailScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const UserRestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<UserRestaurantDetailScreen> createState() =>
      _UserRestaurantDetailScreenState();
}

class _UserRestaurantDetailScreenState
    extends State<UserRestaurantDetailScreen> {
  int _selectedTab = 0; // 0 = Menu, 1 = Tentang, 2 = Ulasan
  final TextEditingController _menuSearchController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  int _selectedStars = 0;
  bool _showReviewValidationError = false;

  @override
  void dispose() {
    _menuSearchController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<bool> _ensureLoggedIn(FoodViewUiState state) async {
    if (state.isUserLoggedIn) return true;
    final goLogin = await FoodViewDialogs.showLoginRequiredDialog(context);
    if (goLogin && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const UserAuthScreen()),
      );
    }
    return false;
  }

  Future<void> _submitReview(
    FoodViewUiState state,
    RestaurantModel restaurant,
  ) async {
    if (!await _ensureLoggedIn(state)) return;

    final comment = _reviewController.text.trim();
    if (comment.isEmpty || _selectedStars == 0) {
      setState(() => _showReviewValidationError = true);
      return;
    }

    setState(() => _showReviewValidationError = false);
    state.addRestaurantReview(restaurant.id, _selectedStars, comment);
    _reviewController.clear();
    setState(() => _selectedStars = 0);

    if (mounted) {
      await FoodViewDialogs.showStatusPopup(
        context,
        message: 'Berhasil Terkirim!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();
    final restaurant = state.restaurants.firstWhere(
      (r) => r.id == widget.restaurant.id,
      orElse: () => widget.restaurant,
    );

    final restaurantMenus = state.getMenusForRestaurant(restaurant);
    final menuQuery = _menuSearchController.text.trim().toLowerCase();
    final filteredMenus = restaurantMenus.where((m) {
      if (menuQuery.isEmpty) return true;
      return m.name.toLowerCase().contains(menuQuery) ||
          m.description.toLowerCase().contains(menuQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Peta Lokasi Spesifik Restoran (OpenStreetMap Live + Peta Statis Figma)
              FoodViewMapCard(
                restaurantName: restaurant.name,
                address: restaurant.address,
                latitude: restaurant.latitude,
                longitude: restaurant.longitude,
                height: 195,
              ),

              // Baris Aksi (Back, Chat, Favorite)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 18, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primaryGreen,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Row(
                      children: [
                        FoodViewFavoriteButton(
                          isFavorite: restaurant.isFavorite,
                          onTap: () async {
                            if (!await _ensureLoggedIn(state)) return;
                            state.toggleRestaurantFavorite(restaurant.id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Informasi Restoran
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      restaurant.category,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _infoRow(Icons.location_on_rounded, restaurant.address),
                    const SizedBox(height: 3),
                    _infoRow(Icons.access_time_filled_rounded, restaurant.hours),
                    const SizedBox(height: 3),
                    _infoRow(Icons.phone_rounded, restaurant.phone),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Galeri Foto Horizontal Spesifik Restoran
              SizedBox(
                height: 145,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: restaurant.galleryAssets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        restaurant.galleryAssets[index],
                        width: 155,
                        height: 145,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // 3 Pill Tabs: Menu | Tentang | Ulasan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _PillTabButton(
                      label: 'Menu (${restaurantMenus.length})',
                      selected: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                    const SizedBox(width: 8),
                    _PillTabButton(
                      label: 'Tentang',
                      selected: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                    const SizedBox(width: 8),
                    _PillTabButton(
                      label: 'Ulasan (${restaurant.reviews.length})',
                      selected: _selectedTab == 2,
                      onTap: () => setState(() => _selectedTab = 2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Isi Tab
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: switch (_selectedTab) {
                  0 => _buildMenuTab(filteredMenus),
                  1 => _buildTentangTab(restaurant),
                  _ => _buildUlasanTab(state, restaurant),
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.primaryGreen),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTab(List<MenuModel> menus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FoodViewSearchBar(
          controller: _menuSearchController,
          hintText: 'Cari menu di ${widget.restaurant.name}...',
          showFilterIcon: false,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menus.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final m = menus[index];
            return FoodViewRestaurantMenuGridCard(
              name: m.name,
              imageAsset: m.imageAsset,
              reviewerCount: m.reviewerCount,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserMenuDetailScreen(menu: m),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTentangTab(RestaurantModel restaurant) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textDark,
              height: 1.48,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FoodViewFilterChip(
                label: 'Jarak: ${restaurant.distanceTag}',
                selected: true,
                onTap: () {},
              ),
              FoodViewFilterChip(
                label: 'Kisaran: ${restaurant.priceTag}',
                selected: false,
                onTap: () {},
              ),
              if (restaurant.is24Hours)
                FoodViewFilterChip(
                  label: 'Buka 24 Jam',
                  selected: true,
                  onTap: () {},
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUlasanTab(
    FoodViewUiState state,
    RestaurantModel restaurant,
  ) {
    // Advance Dart: Destructuring Record `RatingSummaryRecord`
    final (:average, :totalCount, starCounts: _) = calculateRatingSummary(
      restaurant.reviews.map((e) => e.rating),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Beri Penilaian',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'Rata-rata ⭐ ${average.toStringAsFixed(1)} ($totalCount ulasan)',
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FoodViewInteractiveStars(
          selectedStars: _selectedStars,
          onStarSelected: (s) => setState(() => _selectedStars = s),
        ),
        const SizedBox(height: 12),
        const Text(
          'Beri Ulasan',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 110,
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: _reviewController,
            maxLines: 4,
            onChanged: (_) {
              if (_showReviewValidationError) {
                setState(() => _showReviewValidationError = false);
              } else {
                setState(() {});
              }
            },
            style: const TextStyle(fontSize: 12, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: _showReviewValidationError
                  ? '*wajib diisi'
                  : 'Ketikkan sesuatu...',
              hintStyle: TextStyle(
                fontSize: 11.5,
                color: _showReviewValidationError
                    ? AppColors.errorRed
                    : AppColors.textGray,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FoodViewPrimaryButton(
          text: 'Kirim',
          enabled: true,
          height: 38,
          onPressed: () => _submitReview(state, restaurant),
        ),
        const SizedBox(height: 18),
        Text(
          '${restaurant.reviews.length} Komentar',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        for (final rev in restaurant.reviews)
          FoodViewReviewCommentTile(
            userName: rev.userName,
            comment: rev.comment,
            avatarAsset: rev.avatarAsset,
            rating: rev.rating,
          ),
      ],
    );
  }
}

class _PillTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightGreenPill : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
