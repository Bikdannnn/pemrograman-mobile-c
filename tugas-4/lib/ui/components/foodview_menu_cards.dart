import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'foodview_star_rating.dart';

/// Kartu Vertikal "Favoritku" pada Beranda User & `Components.svg` (contoh: `Mie Ayam` / `Ayam Goreng Rica`):
/// Foto persegi di atas dengan badge lingkaran `⭐ 5` di kanan atas, nama menu, nama toko, dan alamat.
class FoodViewFavoritkuMenuCard extends StatelessWidget {
  final String menuName;
  final String storeName;
  final String address;
  final String imageAsset;
  final int rating;
  final VoidCallback? onTap;

  const FoodViewFavoritkuMenuCard({
    super.key,
    required this.menuName,
    required this.storeName,
    required this.address,
    required this.imageAsset,
    this.rating = 5,
    this.onTap,
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
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.asset(
                    imageAsset,
                    width: 156,
                    height: 104,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: AppColors.starYellow,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$rating',
                          style: const TextStyle(
                            fontSize: 10.5,
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
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuName,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_rounded,
                        size: 11,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          storeName,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 11,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textDark,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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

/// Kartu Grid 2 Kolom pada tab `Menu` di Halaman Detail Restoran (`USER.svg`).
class FoodViewRestaurantMenuGridCard extends StatelessWidget {
  final String name;
  final String imageAsset;
  final double rating;
  final String reviewerCount;
  final VoidCallback onTap;

  const FoodViewRestaurantMenuGridCard({
    super.key,
    required this.name,
    required this.imageAsset,
    this.rating = 5.0,
    this.reviewerCount = '4,1rb',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageAsset,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FoodViewStarRow(
            rating: rating,
            size: 11.5,
            reviewerCountText: reviewerCount,
          ),
        ],
      ),
    );
  }
}

/// Kartu Detail Menu Favorit pada tab `Favoritku -> Menu` sesuai `Components.svg` & `USER.svg`:
/// Header: `❤️ Warung Bu Atik`, kategori, kanan `⭐ 5,0`.
/// Body: Judul menu (`Ayam Goreng Rica`), deskripsi, harga (`Rp.25.000`), dan foto persegi di kanan.
class FoodViewFavoriteMenuDetailCard extends StatelessWidget {
  final String restaurantName;
  final String restaurantCategory;
  final String ratingText;
  final String menuName;
  final String description;
  final String price;
  final String imageAsset;
  final VoidCallback? onTap;

  const FoodViewFavoriteMenuDetailCard({
    super.key,
    required this.restaurantName,
    required this.restaurantCategory,
    this.ratingText = '5,0',
    required this.menuName,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 13,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantName,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        restaurantCategory,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: AppColors.starYellow,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      ratingText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textGray,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageAsset,
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu Menu pada layar Pemilik Restoran (`Manajemen Menu` & `Rating & Review` di `PEMILIK RESTORAN.svg`):
/// - Pada `Manajemen Menu`: menampilkan tombol `⋮` di kanan atas yang membuka menu `Edit` / `Hapus`.
/// - Pada `Rating & Review`: menampilkan ikon buka-ulasan di kanan atas.
class FoodViewOwnerMenuCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageAsset;
  final bool isReviewMode;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FoodViewOwnerMenuCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    this.isReviewMode = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageAsset,
                width: 66,
                height: 66,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textGray,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            if (isReviewMode)
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.open_in_new_rounded,
                    size: 13,
                    color: AppColors.primaryOrange,
                  ),
                ),
              )
            else
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onSelected: (val) {
                  if (val == 'edit') onEdit?.call();
                  if (val == 'delete') onDelete?.call();
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    height: 32,
                    child: Center(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const PopupMenuDivider(height: 1),
                  const PopupMenuItem(
                    value: 'delete',
                    height: 32,
                    child: Center(
                      child: Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.more_vert_rounded,
                    size: 14,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
