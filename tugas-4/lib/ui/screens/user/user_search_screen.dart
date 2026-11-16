import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_menu_detail_screen.dart';
import 'user_restaurant_detail_screen.dart';

/// Layar Pencarian & Filter/Kategori Restoran + Pencarian Katalog Open API sesuai `USER.svg`:
/// - Filter berfungsi nyata berdasarkan Kategori (`Nasi`, `Minuman`, `Seafood`, `Ayam`, `Mie`),
///   Jarak (`<1 km`, `1-2 km`, `2-5 km`, `>5 km`), Harga, dan Jam Operasional!
/// - Setiap restoran yang diklik membuka halaman detail restoran tersebut (bukan hanya Warung Bu Atik!).
class UserSearchScreen extends StatefulWidget {
  final String? initialCategory;
  final FoodViewFilterSelection initialFilter;

  const UserSearchScreen({
    super.key,
    this.initialCategory,
    this.initialFilter = const FoodViewFilterSelection(),
  });

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late FoodViewFilterSelection _filter;
  String? _category;

  static const List<String> _allCategories = [
    'Semua',
    'Nasi',
    'Minuman',
    'Seafood',
    'Ayam',
    'Mie',
  ];

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: FoodViewFilterCard(
          initialSelection: _filter,
          onApply: (sel) {
            Navigator.of(ctx).pop();
            setState(() => _filter = sel);
            FoodViewDialogs.showStatusPopup(
              context,
              message: 'Filter diterapkan',
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();
    final query = _searchController.text.trim().toLowerCase();

    final results = state.restaurants.where((r) {
      if (_category != null && _category != 'Semua') {
        final matchCat = r.categoryTags.any(
              (t) => t.toLowerCase() == _category!.toLowerCase(),
            ) ||
            r.category.toLowerCase().contains(_category!.toLowerCase());
        if (!matchCat) return false;
      }
      if (_filter.distance != null && r.distanceTag != _filter.distance) {
        return false;
      }
      if (_filter.price != null && r.priceTag != _filter.price) {
        return false;
      }
      if (_filter.hours == '24 Jam' && !r.is24Hours) {
        return false;
      }
      if (query.isNotEmpty) {
        return r.name.toLowerCase().contains(query) ||
            r.category.toLowerCase().contains(query) ||
            r.address.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    final matchingMenus = state.menus.where((m) {
      if (_category != null && _category != 'Semua') {
        if (m.categoryTag.toLowerCase() != _category!.toLowerCase()) {
          return false;
        }
      }
      if (query.isNotEmpty) {
        return m.name.toLowerCase().contains(query) ||
            m.restaurantName.toLowerCase().contains(query);
      }
      return _category != null && _category != 'Semua';
    }).toList();

    final subtitleFilterText = _category != null && _category != 'Semua'
        ? 'Kategori : $_category'
        : (!_filter.isEmpty
            ? 'Filter: ${_filter.summaryLabel}'
            : 'Filter: Semua Restoran & Kuliner');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hijau Tua
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
                    autofocus: widget.initialCategory == null &&
                        widget.initialFilter.isEmpty,
                    onChanged: (val) {
                      setState(() {});
                      if (val.trim().length >= 3) {
                        state.loadOpenApiDishes(query: val.trim());
                      }
                    },
                    onFilterTap: _openFilterModal,
                  ),
                ],
              ),
            ),

            // Pilihan Cepat Kategori
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                itemCount: _allCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _allCategories[index];
                  final isSelected = (_category ?? 'Semua') == cat;
                  return FoodViewFilterChip(
                    label: cat,
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        _category = cat == 'Semua' ? null : cat;
                      });
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                subtitleFilterText,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGray,
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'Tidak ada restoran yang cocok dengan filter ini.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    ),
                  for (final r in results)
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
                              restaurant: r,
                            ),
                          ),
                        );
                      },
                    ),
                  if (matchingMenus.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Menu Sesuai Kategori / Pencarian',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final m in matchingMenus)
                      FoodViewFavoriteMenuDetailCard(
                        restaurantName: m.restaurantName,
                        restaurantCategory: m.restaurantCategory,
                        menuName: m.name,
                        description: m.description,
                        price: m.price,
                        imageAsset: m.imageAsset,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserMenuDetailScreen(menu: m),
                            ),
                          );
                        },
                      ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
