import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Komponen Universal untuk menangani gambar network (CDN/API) maupun gambar aset lokal
class FoodViewUniversalImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const FoodViewUniversalImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cleanPath = imagePath.trim();
    final isNetwork = cleanPath.startsWith('http://') || cleanPath.startsWith('https://');

    Widget imageWidget;

    if (isNetwork) {
      imageWidget = Image.network(
        cleanPath,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F1F1),
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      imageWidget = Image.asset(
        cleanPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFEEEEEE),
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: Colors.black26,
          size: 24,
        ),
      ),
    );
  }
}
