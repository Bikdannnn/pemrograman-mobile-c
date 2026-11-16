import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Baris bintang rating statis (`#FFBF00`) beserta opsional jumlah periview (`• 👤 3rb`).
class FoodViewStarRow extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final String? reviewerCountText;

  const FoodViewStarRow({
    super.key,
    this.rating = 5.0,
    this.maxStars = 5,
    this.size = 13,
    this.reviewerCountText,
  });

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.round().clamp(0, maxStars);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < maxStars; i++)
          Icon(
            Icons.star_rounded,
            size: size,
            color: i < fullStars
                ? AppColors.starYellow
                : const Color(0xFFD9D9D9),
          ),
        if (reviewerCountText != null) ...[
          const SizedBox(width: 4),
          Text(
            '• ',
            style: TextStyle(
              fontSize: size * 0.75,
              color: AppColors.textGray,
            ),
          ),
          Icon(
            Icons.person_rounded,
            size: size * 0.85,
            color: AppColors.textGray,
          ),
          const SizedBox(width: 2),
          Text(
            reviewerCountText!,
            style: TextStyle(
              fontSize: size * 0.75,
              color: AppColors.textGray,
            ),
          ),
        ],
      ],
    );
  }
}

/// Komponen Pemilih Bintang Interaktif (1 s/d 5 bintang) sesuai `Components.svg`
/// untuk bagian "Beri Penilaian" pada halaman Detail Restoran & Detail Menu.
class FoodViewInteractiveStars extends StatelessWidget {
  final int selectedStars;
  final ValueChanged<int> onStarSelected;
  final double size;

  const FoodViewInteractiveStars({
    super.key,
    required this.selectedStars,
    required this.onStarSelected,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isSelected = starNumber <= selectedStars;
        return GestureDetector(
          onTap: () => onStarSelected(starNumber),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: isSelected
                  ? AppColors.starYellow
                  : const Color(0xFFD9D9D9),
            ),
          ),
        );
      }),
    );
  }
}
