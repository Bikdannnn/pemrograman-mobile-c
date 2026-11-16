import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_auth_screen.dart';
import 'user_menu_detail_screen.dart';
import 'user_restaurant_detail_screen.dart';

/// Layar Profil USER sesuai `USER.svg`:
/// - Jika belum login (Guest): Menampilkan ikon placeholder abu-abu, `"Masuk ke Akun Anda"`, dan tombol oranye `"Masuk"`.
/// - Jika sudah login (`Gibran Nur Saleh`): Menampilkan avatar bulat, `"@gibnurshl ✏️"`, `"Telah Mereview Sebanyak 100 Rumah Makan"`,
///   dan 3 menu navigasi:
///   1. `Favoritku` -> membuka `UserFavoritkuScreen` (tab `Menu` & `Restoran`)
///   2. `Riwayat Review` -> membuka `UserRiwayatReviewScreen` + `UserRiwayatDetailScreen`
///   3. `Pengaturan` -> membuka `FoodViewSettingsScreen` (`Privasi Akun`, `Bahasa`, `Tema`, `Aksesibilitas`, `Ganti Akun`, `Keluar`)
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    if (!state.isUserLoggedIn) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.person_rounded,
            size: 74,
            color: Color(0xFFD9D9D9),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masuk ke Akun Anda',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 125,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UserAuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Column(
        children: [
          Text(
            state.userDisplayName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          const CircleAvatar(
            radius: 46,
            backgroundImage: AssetImage('assets/images/u_pm_0.png'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.userHandle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.edit_rounded,
                size: 13,
                color: AppColors.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Telah Mereview Sebanyak 100 Rumah Makan',
            style: TextStyle(
              fontSize: 10.5,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 30),
          _ProfileMenuRow(
            icon: Icons.favorite_rounded,
            label: 'Favoritku',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserFavoritkuScreen()),
              );
            },
          ),
          _ProfileMenuRow(
            icon: Icons.history_rounded,
            label: 'Riwayat Review',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UserRiwayatReviewScreen(),
                ),
              );
            },
          ),
          _ProfileMenuRow(
            icon: Icons.settings_outlined,
            label: 'Pengaturan',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FoodViewSettingsScreen(isOwner: false),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryGreen),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textDark,
            ),
          ],
        ),
      ),
    );
  }
}

/// Layar `Favoritku` dengan Tab `Menu` & `Restoran` sesuai `USER.svg`.
class UserFavoritkuScreen extends StatefulWidget {
  const UserFavoritkuScreen({super.key});

  @override
  State<UserFavoritkuScreen> createState() => _UserFavoritkuScreenState();
}

class _UserFavoritkuScreenState extends State<UserFavoritkuScreen> {
  int _selectedTab = 0; // 0 = Menu, 1 = Restoran
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();
    final query = _searchController.text.trim().toLowerCase();

    final favMenus = [
      ...state.menus.where((m) => m.isFavorite),
      ...state.extraFavoriteMenus,
    ].where((m) {
      if (query.isEmpty) return true;
      return m.name.toLowerCase().contains(query) ||
          m.restaurantName.toLowerCase().contains(query);
    }).toList();

    final favRestaurants = state.restaurants.where((r) => r.isFavorite).where((r) {
      if (query.isEmpty) return true;
      return r.name.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hijau Tua dengan Search Bar "Favoritku..."
            Container(
              width: double.infinity,
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.fromLTRB(14, 10, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 10),
                  FoodViewSearchBar(
                    controller: _searchController,
                    hintText: 'Favoritku...',
                    showFilterIcon: false,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),

            // Tab Pill: Menu | Restoran
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? AppColors.lightGreenPill
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1
                            ? AppColors.lightGreenPill
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Restoran',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _selectedTab == 0
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: favMenus.length,
                      itemBuilder: (context, index) {
                        final m = favMenus[index];
                        return FoodViewFavoriteMenuDetailCard(
                          restaurantName: m.restaurantName,
                          restaurantCategory: m.restaurantCategory,
                          menuName: m.name,
                          description: m.description,
                          price: m.price,
                          imageAsset: m.imageAsset,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserMenuDetailScreen(
                                  menu: state.menus.first,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: favRestaurants.length,
                      itemBuilder: (context, index) {
                        final r = favRestaurants[index];
                        return FoodViewFavoriteRestaurantCard(
                          name: r.name,
                          category: r.category,
                          address: r.address,
                          imageAsset: r.imageAsset,
                          onRemoveFavorite: () =>
                              state.toggleRestaurantFavorite(r.id),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserRestaurantDetailScreen(restaurant: r),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Layar `Riwayat Review` sesuai `USER.svg`:
/// Menampilkan bagian `"Hari Ini"` (`Warung Pak Joko`) & `"Kemarin"` (`Rumah Makan Mba Atun`, `Fireflies`)
/// dengan tombol oranye `"Lihat"` yang membuka `UserRiwayatDetailScreen`.
class UserRiwayatReviewScreen extends StatefulWidget {
  const UserRiwayatReviewScreen({super.key});

  @override
  State<UserRiwayatReviewScreen> createState() =>
      _UserRiwayatReviewScreenState();
}

class _UserRiwayatReviewScreenState extends State<UserRiwayatReviewScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.fromLTRB(14, 10, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 10),
                  FoodViewSearchBar(
                    controller: _searchController,
                    hintText: 'Cari...',
                    showFilterIcon: false,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                children: [
                  const Text(
                    'Riwayat',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hari Ini',
                    style: TextStyle(fontSize: 10.5, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 8),
                  FoodViewRiwayatRestaurantCard(
                    name: 'Warung Pak Joko',
                    category: 'Rumah makan',
                    address: 'Jl. Samata, Borong Indah',
                    imageAsset: 'assets/images/u_us_5.png',
                    onViewTap: () => _openDetail(context),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kemarin',
                    style: TextStyle(fontSize: 10.5, color: AppColors.textGray),
                  ),
                  const SizedBox(height: 8),
                  FoodViewRiwayatRestaurantCard(
                    name: 'Rumah Makan Mba Atun',
                    category: 'Seafood',
                    address: 'Jl. Toddopuli Raya No 12',
                    imageAsset: 'assets/images/u_us_1.png',
                    onViewTap: () => _openDetail(context),
                  ),
                  FoodViewRiwayatRestaurantCard(
                    name: 'Fireflies',
                    category: 'Cepat Saji',
                    address: 'Jl. Tanjung Bayang',
                    imageAsset: 'assets/images/u_us_0.png',
                    onViewTap: () => _openDetail(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UserRiwayatDetailScreen()),
    );
  }
}

/// Layar Detail Riwayat Review (frame paling kanan bawah di `USER.svg`):
/// Menampilkan foto restoran, info `Warung Bu Atik`, 5 bintang `Penilaian`, dan kotak `Ulasan`.
class UserRiwayatDetailScreen extends StatelessWidget {
  const UserRiwayatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.fromLTRB(14, 12, 18, 12),
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/u_us_5.png',
                        width: double.infinity,
                        height: 195,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Warung Bu Atik',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Ayam dan bebek, Aneka Nasi, Cepat Saji',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: AppColors.primaryGreen,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Jl. Samata, Borong Indah, Makassar',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          size: 13,
                          color: AppColors.primaryGreen,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '08.00 - 22.30 WITA',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(
                          Icons.phone_rounded,
                          size: 13,
                          color: AppColors.primaryGreen,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '081231492034',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Penilaian',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: FoodViewStarRow(rating: 5.0, size: 36),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ulasan',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 120,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Tempat makan paling nyaman, semua pelayan ramah dan makanannya enak-enak',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textGray,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Layar `Pengaturan` bersama untuk Role USER maupun PEMILIK RESTORAN sesuai `USER.svg` & `PEMILIK RESTORAN.svg`:
/// Menampilkan `Privasi Akun`, `Bahasa`, `Tema`, `Aksesibilitas`, `Ganti Akun` (berpindah Role!), dan `Keluar`.
class FoodViewSettingsScreen extends StatelessWidget {
  final bool isOwner;

  const FoodViewSettingsScreen({
    super.key,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        children: [
          _SettingTile(
            icon: Icons.lock_rounded,
            label: 'Privasi Akun',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.language_rounded,
            label: 'Bahasa',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.palette_outlined,
            label: 'Tema',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.accessibility_new_rounded,
            label: 'Aksesibilitas',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.swap_horiz_rounded,
            label: 'Ganti Akun (${isOwner ? "Ke Mode User" : "Ke Mode Pemilik Restoran"})',
            onTap: () {
              state.setRole(
                isOwner ? AppActiveRole.user : AppActiveRole.pemilikRestoran,
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          _SettingTile(
            icon: Icons.logout_rounded,
            label: 'Keluar',
            onTap: () async {
              final confirmed =
                  await FoodViewDialogs.showLogoutConfirmDialog(context);
              if (confirmed && context.mounted) {
                if (isOwner) {
                  state.logoutOwner();
                } else {
                  state.logoutUser();
                }
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryGreen),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textDark,
            ),
          ],
        ),
      ),
    );
  }
}
