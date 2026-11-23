import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'foodview_network_image.dart';
import 'foodview_star_rating.dart';

/// Kartu Restoran Horizontal sesuai `Components.svg` & `USER.svg` (Rekomendasi & Pencarian):
/// Menampilkan foto persegi di kiri, judul restoran, kategori, alamat dengan ikon pin,
/// serta baris bintang 5 + jumlah periview (`• 👤 3rb`).
class FoodViewRestaurantCard extends StatelessWidget {
  final String name;
  final String category;
  final String address;
  final String imageAsset;
  final double rating;
  final String reviewerCount;
  final bool starsOnTop;
  final VoidCallback? onTap;

  const FoodViewRestaurantCard({
    super.key,
    required this.name,
    required this.category,
    required this.address,
    required this.imageAsset,
    this.rating = 5.0,
    this.reviewerCount = '3rb',
    this.starsOnTop = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(14),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            FoodViewUniversalImage(
              imagePath: imageAsset,
              width: 68,
              height: 68,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (starsOnTop) ...[
                    FoodViewStarRow(rating: rating, size: 12),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (!starsOnTop) ...[
                    const SizedBox(height: 3),
                    FoodViewStarRow(
                      rating: rating,
                      size: 12,
                      reviewerCountText: reviewerCount,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu "Top of the Week" berlatar krem `#FEFBE9` pada Beranda User (`Black Canyon - Pastrami Pizza`).
class FoodViewTopOfTheWeekCard extends StatelessWidget {
  final String restaurantName;
  final String dishName;
  final String price;
  final String dishImageAsset;
  final String sideImageAsset;
  final VoidCallback? onTap;

  const FoodViewTopOfTheWeekCard({
    super.key,
    this.restaurantName = 'Black Canyon',
    this.dishName = 'Pastrami Pizza',
    this.price = 'Rp75.000',
    this.dishImageAsset = 'assets/images/u_us_11.png',
    this.sideImageAsset = 'assets/images/u_us_12.png',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.splashCream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 14,
                  color: AppColors.starYellow,
                ),
                SizedBox(width: 4),
                Text(
                  'Top of the Week',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        FoodViewUniversalImage(
                          imagePath: dishImageAsset,
                          width: 60,
                          height: 60,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FoodViewStarRow(rating: 5.0, size: 11),
                              const SizedBox(height: 2),
                              Text(
                                restaurantName,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                dishName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textGray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 11,
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
                ),
                const SizedBox(width: 10),
                FoodViewUniversalImage(
                  imagePath: sideImageAsset,
                  width: 68,
                  height: 68,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu Restoran dengan tombol "Lihat" penuh di bawah (digunakan pada `Components.svg` & `Riwayat Review`).
class FoodViewRiwayatRestaurantCard extends StatelessWidget {
  final String name;
  final String category;
  final String address;
  final String imageAsset;
  final double rating;
  final VoidCallback onViewTap;

  const FoodViewRiwayatRestaurantCard({
    super.key,
    required this.name,
    required this.category,
    required this.address,
    required this.imageAsset,
    this.rating = 5.0,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              FoodViewUniversalImage(
                imagePath: imageAsset,
                width: 68,
                height: 68,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    FoodViewStarRow(rating: rating, size: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: onViewTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu Restoran Favorit pada tab `Favoritku -> Restoran` sesuai `Components.svg` & `USER.svg`:
/// Memiliki badge `⭐ 5,0` di pojok kiri bawah foto dan ikon hati oranye di kanan atas.
class FoodViewFavoriteRestaurantCard extends StatelessWidget {
  final String name;
  final String category;
  final String address;
  final String imageAsset;
  final String ratingText;
  final VoidCallback? onTap;
  final VoidCallback? onRemoveFavorite;

  const FoodViewFavoriteRestaurantCard({
    super.key,
    required this.name,
    required this.category,
    required this.address,
    required this.imageAsset,
    this.ratingText = '5,0',
    this.onTap,
    this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(8),
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
        child: Row(
          children: [
            Stack(
              children: [
                FoodViewUniversalImage(
                  imagePath: imageAsset,
                  width: 70,
                  height: 70,
                  borderRadius: BorderRadius.circular(8),
                ),
                Positioned(
                  left: 6,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                          ratingText,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemoveFavorite,
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 16,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
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
