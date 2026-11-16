import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../components/components.dart';

/// Layar Katalog Komponen (`Components.svg`) di atas kanvas `#DEDEDE`:
/// Menampilkan seluruh modular component secara interaktif sesuai file `Components.svg`.
class ComponentsPreviewScreen extends StatefulWidget {
  const ComponentsPreviewScreen({super.key});

  @override
  State<ComponentsPreviewScreen> createState() =>
      _ComponentsPreviewScreenState();
}

class _ComponentsPreviewScreenState extends State<ComponentsPreviewScreen> {
  bool _favActive = true;
  bool _chipSelected = true;
  int _selectedStars = 5;
  int _bottomNavDemoIndex = 0;
  FoodViewFilterSelection _filterSelection = const FoodViewFilterSelection(
    distance: '<1 km',
    price: 'Rp25.000 - Rp100.000',
    hours: 'Buka Sekarang',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.componentCanvasGray,
      appBar: AppBar(
        title: const Text(
          'Design System - Components.svg',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('1. Search Bar & Filter Card'),
            FoodViewSearchBar(
              onFilterTap: () {},
            ),
            const SizedBox(height: 12),
            Center(
              child: FoodViewFilterCard(
                initialSelection: _filterSelection,
                onApply: (sel) {
                  setState(() => _filterSelection = sel);
                  FoodViewDialogs.showStatusPopup(
                    context,
                    message: 'Filter diterapkan',
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            _sectionLabel('2. Favorite Heart, Chips & Interactive Star Rating'),
            Row(
              children: [
                FoodViewFavoriteButton(
                  isFavorite: _favActive,
                  onTap: () => setState(() => _favActive = !_favActive),
                ),
                const SizedBox(width: 12),
                FoodViewFavoriteButton(
                  isFavorite: !_favActive,
                  onTap: () => setState(() => _favActive = !_favActive),
                ),
                const SizedBox(width: 20),
                FoodViewFilterChip(
                  label: '<1 km',
                  selected: false,
                  onTap: () => setState(() => _chipSelected = !_chipSelected),
                ),
                const SizedBox(width: 8),
                FoodViewFilterChip(
                  label: '<1 km',
                  selected: _chipSelected,
                  onTap: () => setState(() => _chipSelected = !_chipSelected),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(140),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FoodViewInteractiveStars(
                selectedStars: _selectedStars,
                onStarSelected: (v) => setState(() => _selectedStars = v),
              ),
            ),
            const SizedBox(height: 18),
            _sectionLabel('3. Category Photo & Interactive Map Preview'),
            Row(
              children: [
                const FoodViewCategoryOverlayCard(
                  title: 'Ayam Semur',
                  imageAsset: 'assets/images/u_us_6.png',
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const FoodViewMapCard(height: 140),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _sectionLabel('4. Restaurant & Menu Card Variants'),
            FoodViewRiwayatRestaurantCard(
              name: 'Nasi Padang Aminah',
              category: 'Rumah makan',
              address: 'Jl. Samata, Borong Indah',
              imageAsset: 'assets/images/u_us_7.png',
              onViewTap: () {},
            ),
            const FoodViewRestaurantCard(
              name: 'Warung Pak Joko',
              category: 'Ayam dan bebek, Aneka Nasi, Cepat Saji',
              address: 'Jl. Samata, Borong Indah, Makassar',
              imageAsset: 'assets/images/u_us_7.png',
              starsOnTop: true,
            ),
            const FoodViewRestaurantCard(
              name: 'Warung Pak Joko',
              category: 'Ayam, Aneka Nasi, Cepat Saji',
              address: 'Jl. Samata, Borong Indah',
              imageAsset: 'assets/images/u_us_7.png',
              reviewerCount: '3rb',
            ),
            const FoodViewFavoriteRestaurantCard(
              name: 'Warung Pak Joko',
              category: 'Ayam, Aneka Nasi, Cepat Saji',
              address: 'Jl. Samata, Borong Indah',
              imageAsset: 'assets/images/u_us_7.png',
            ),
            const FoodViewFavoriteMenuDetailCard(
              restaurantName: 'Warung Pak Joko',
              restaurantCategory: 'Ayam, Aneka Nasi, Cepat Saji',
              menuName: 'Ayam Goreng Rica',
              description:
                  'Hidangan khas Indonesia berupa ayam yang digoreng lalu dibalut dengan sambal rica pedas khas Manado.',
              price: 'Rp.10.000',
              imageAsset: 'assets/images/u_us_6.png',
            ),
            const FoodViewFavoritkuMenuCard(
              menuName: 'Mie Ayam',
              storeName: 'Toko Pak Ais',
              address: 'Jl. Samata, Borong Indah, Makassar',
              imageAsset: 'assets/images/u_us_8.png',
            ),
            const SizedBox(height: 18),
            _sectionLabel('5. Buttons & Bottom Navigation Variants'),
            FoodViewPrimaryButton(
              text: 'Lihat Selengkapnya',
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            FoodViewUserBottomNav(
              currentIndex: _bottomNavDemoIndex,
              onTap: (i) => setState(() => _bottomNavDemoIndex = i),
            ),
            const SizedBox(height: 18),
            _sectionLabel('6. Chat, Review & Notification Tiles'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FoodViewChatListTile(
                name: 'Warung Bu Atik',
                lastMessage: 'Terima kasih sudah order jualan kita...',
                time: '10.55',
                unreadCount: 2,
                avatarAsset: 'assets/images/u_us_20.png',
                onTap: () {},
              ),
            ),
            const SizedBox(height: 10),
            const FoodViewReviewCommentTile(
              userName: 'Unknown',
              comment:
                  'Pegawai toko semua ramah... suasana warungnya enak banget lagi',
              avatarAsset: 'assets/images/u_us_20.png',
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const FoodViewNotificationTile(
                menuName: 'Ayam Goreng Sambal Matah',
                userName: 'asfg123',
                stars: 5,
                avatarAsset: 'assets/images/u_pm_0.png',
              ),
            ),
            const SizedBox(height: 18),
            _sectionLabel('7. Popup & Modal Dialogs (Ketuk untuk Preview)'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: const Text('Filter diterapkan'),
                  onPressed: () => FoodViewDialogs.showStatusPopup(
                    context,
                    message: 'Filter diterapkan',
                  ),
                ),
                ActionChip(
                  label: const Text('Berhasil Terkirim!'),
                  onPressed: () => FoodViewDialogs.showStatusPopup(
                    context,
                    message: 'Berhasil Terkirim!',
                  ),
                ),
                ActionChip(
                  label: const Text('Berhasil Ditambah!'),
                  onPressed: () => FoodViewDialogs.showStatusPopup(
                    context,
                    message: 'Berhasil Ditambah!',
                  ),
                ),
                ActionChip(
                  label: const Text('Akun berhasil dibuat!'),
                  onPressed: () => FoodViewDialogs.showStatusPopup(
                    context,
                    message: 'Akun anda\nberhasil dibuat!',
                  ),
                ),
                ActionChip(
                  label: const Text('Dialog Keluar Akun'),
                  onPressed: () =>
                      FoodViewDialogs.showLogoutConfirmDialog(context),
                ),
                ActionChip(
                  label: const Text('Dialog Masuk Akun'),
                  onPressed: () =>
                      FoodViewDialogs.showLoginRequiredDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
