import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Komponen Search Bar sesuai `Components.svg`:
/// Kotak putih ber-outline oranye tipis dengan ikon kaca pembesar di kiri,
/// teks "Cari restoran...", dan ikon filter sliders (`Icons.tune_rounded`) oranye di kanan.
class FoodViewSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool readOnly;
  final bool showFilterIcon;
  final bool autofocus;

  const FoodViewSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Cari restoran...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onFilterTap,
    this.readOnly = false,
    this.showFilterIcon = true,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryOrange.withAlpha(180),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 18,
            color: AppColors.textGray,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              autofocus: autofocus,
              onTap: onTap,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textGray,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (showFilterIcon)
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.tune_rounded,
                  size: 19,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
