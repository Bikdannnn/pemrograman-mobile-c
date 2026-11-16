import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Tombol utama oranye sesuai `Components.svg` (memiliki state default `#F0A04B`,
/// ditekan `#D9750B`, dan nonaktif `#E0E0E0`).
class FoodViewPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final double height;
  final double borderRadius;

  const FoodViewPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.height = 42,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (!enabled || states.contains(WidgetState.disabled)) {
              return AppColors.disabledButtonGray;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.darkOrange;
            }
            return AppColors.primaryOrange;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (!enabled || states.contains(WidgetState.disabled)) {
              return AppColors.textDark;
            }
            return Colors.white;
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Tombol sekunder abu-abu (`#E0E0E0`) untuk aksi kedua di layar Masuk/Buat Akun.
class FoodViewSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;

  const FoodViewSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 42,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.disabledButtonGray,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Tombol bulat Favorit (Heart) sesuai `Components.svg`:
/// - Aktif: lingkaran oranye `#F0A04B` dengan ikon hati putih
/// - Nonaktif: lingkaran putih/abu terang dengan ikon hati oranye `#F0A04B`
class FoodViewFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  const FoodViewFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isFavorite ? AppColors.primaryOrange : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryOrange,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.favorite_rounded,
          size: size * 0.56,
          color: isFavorite ? Colors.white : AppColors.primaryOrange,
        ),
      ),
    );
  }
}

/// Tombol bulat Chat Toko berwarna oranye `#F0A04B` di samping tombol Favorit.
class FoodViewChatCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const FoodViewChatCircleButton({
    super.key,
    required this.onTap,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.chat_bubble_outline_rounded,
          size: size * 0.52,
          color: Colors.white,
        ),
      ),
    );
  }
}
