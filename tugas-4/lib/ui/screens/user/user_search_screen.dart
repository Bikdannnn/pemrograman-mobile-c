import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_restaurant_detail_screen.dart';

/// Layar Pencarian & Filter/Kategori Restoran sesuai `USER.svg`:
/// - Header hijau tua dengan tombol kembali dan `FoodViewSearchBar`
/// - Menampilkan keterangan `Filter: 1-2 km, Rp25.000-100.000` atau `Kategori : Nasi`
/// - Daftar restoran yang sesuai (`Warung Bu Atik`, `RM. Bu Ati`, `Rumah Makan Mba Atun`, dsb.)
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
      if (query.isNotEmpty) {
        return r.name.toLowerCase().contains(query) ||
            r.category.toLowerCase().contains(query) ||
            r.address.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    final subtitleFilterText = _category != null
        ? 'Kategori : $_category'
        : (!_filter.isEmpty
            ? 'Filter: ${_filter.summaryLabel}'
            : 'Filter: 1-2 km, Rp25.000-100.000');

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
                    onChanged: (_) => setState(() {}),
                    onFilterTap: _openFilterModal,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                subtitleFilterText,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGray,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final r = results[index];
                  return FoodViewRestaurantCard(
                    name: r.name,
                    category: r.category,
                    address: r.address,
                    imageAsset: r.imageAsset,
                    reviewerCount: r.reviewerCount,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserRestaurantDetailScreen(
                            restaurant: state.restaurants.first,
                          ),
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
