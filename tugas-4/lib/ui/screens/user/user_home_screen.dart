import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/location_service.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_restaurant_detail_screen.dart';
import 'user_search_screen.dart';

/// Layar Beranda USER:
/// - Header Hijau Tua (`#183A1D`): "Selamat Datang!", Info Lokasi Terdekat, Search Bar + Filter
/// - Langsung menampilkan Rekomendasi Restoran Terdekat berdasarkan lokasi pengguna
class UserHomeScreen extends StatefulWidget {
  final VoidCallback? onOpenFavoritku;

  const UserHomeScreen({
    super.key,
    this.onOpenFavoritku,
  });

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  FoodViewFilterSelection _activeFilter = const FoodViewFilterSelection();

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
    final rekomendasiList = state.restaurants;

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      onRefresh: () async {
        await state.fetchAggregatedMultiApiData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hijau Tua (#183A1D)
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
                  const SizedBox(height: 6),

                  // Info deteksi lokasi pengguna (Kecamatan / Kelurahan)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Lokasi Anda: ${state.currentAreaName}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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

            const SizedBox(height: 18),

            // Header Section: Rekomendasi Restoran Terdekat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Rekomendasi Restoran Terdekat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
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
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Diurutkan otomatis dari restoran paling dekat dengan ${state.currentAreaName}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textGray,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Daftar Restoran Terdekat
            if (state.isLoadingAggregator && rekomendasiList.isEmpty)
              const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            else if (rekomendasiList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Center(
                  child: Text(
                    'Belum ada restoran terdekat yang terdeteksi.\nTarik ke bawah untuk memuat ulang.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.textGray),
                  ),
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
                            ? LocationService.formatDistance(r.distanceFromUser!)
                            : r.distanceTag,
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
                      text: 'Lihat Semua Restoran',
                      onPressed: () => _openSearch(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
