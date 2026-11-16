import 'package:flutter/material.dart';

/// Komponen Peta Lokasi Restoran sesuai `Components.svg` & `USER.svg`:
/// Menampilkan peta `CLARO HOTEL MAKASSAR` (`Jl. Yusuf Daeng Ngawing`).
/// Ketika diketuk, menampilkan overlay gelap `"Lihat di Maps\nhttps://maps.app.goo.gl/p73Vp7LFqNvBqV4X7"`.
class FoodViewMapCard extends StatefulWidget {
  final String mapsUrl;
  final double height;

  const FoodViewMapCard({
    super.key,
    this.mapsUrl = 'https://maps.app.goo.gl/p73Vp7LFqNvBqV4X7',
    this.height = 195,
  });

  @override
  State<FoodViewMapCard> createState() => _FoodViewMapCardState();
}

class _FoodViewMapCardState extends State<FoodViewMapCard> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showOverlay = !_showOverlay),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/map_claro_makassar.png',
              fit: BoxFit.cover,
            ),
            if (_showOverlay)
              Container(
                color: Colors.black.withAlpha(120),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lihat di Maps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.mapsUrl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
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

/// Kartu Kategori Foto Persegi dengan Overlay Judul (`Ayam Semur`) sesuai `Components.svg`.
class FoodViewCategoryOverlayCard extends StatefulWidget {
  final String title;
  final String imageAsset;
  final VoidCallback? onTap;

  const FoodViewCategoryOverlayCard({
    super.key,
    required this.title,
    required this.imageAsset,
    this.onTap,
  });

  @override
  State<FoodViewCategoryOverlayCard> createState() =>
      _FoodViewCategoryOverlayCardState();
}

class _FoodViewCategoryOverlayCardState
    extends State<FoodViewCategoryOverlayCard> {
  bool _showOverlay = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showOverlay = !_showOverlay);
        widget.onTap?.call();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(widget.imageAsset, fit: BoxFit.cover),
              if (_showOverlay)
                Container(
                  color: Colors.black.withAlpha(110),
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
