import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';

/// Komponen Peta Lokasi Restoran sesuai `Components.svg` & `USER.svg`:
/// - Mendukung koordinat spesifik tiap restoran di Makassar menggunakan **OpenStreetMap Tile API** (`flutter_map`)
///   maupun tampilan peta statis Figma (`CLARO HOTEL MAKASSAR`).
/// - Ketika diketuk, menampilkan overlay gelap `"Lihat di Maps\nhttps://maps.app.goo.gl/..."`
///   dan tombol switch Peta Interaktif OpenStreetMap.
class FoodViewMapCard extends StatefulWidget {
  final String restaurantName;
  final String address;
  final double latitude;
  final double longitude;
  final String mapsUrl;
  final double height;

  const FoodViewMapCard({
    super.key,
    this.restaurantName = 'Warung Bu Atik',
    this.address = 'Jl. Samata, Borong Indah, Makassar',
    this.latitude = -5.1636,
    this.longitude = 119.4362,
    this.mapsUrl = 'https://maps.app.goo.gl/p73Vp7LFqNvBqV4X7',
    this.height = 195,
  });

  @override
  State<FoodViewMapCard> createState() => _FoodViewMapCardState();
}

class _FoodViewMapCardState extends State<FoodViewMapCard> {
  bool _showOverlay = false;
  bool _useInteractiveOsm = true;

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.latitude, widget.longitude);

    return GestureDetector(
      onTap: () => setState(() => _showOverlay = !_showOverlay),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_useInteractiveOsm)
              FlutterMap(
                key: ValueKey('${widget.latitude}_${widget.longitude}'),
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 15.2,
                  onTap: (_, __) =>
                      setState(() => _showOverlay = !_showOverlay),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.mobilec.tugas4.kuliner_kita',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: center,
                        width: 200,
                        height: 64,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(45),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.restaurantName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFC62828),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.location_on_rounded,
                              size: 34,
                              color: Color(0xFFD32F2F),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Image.asset(
                'assets/images/map_claro_makassar.png',
                fit: BoxFit.cover,
              ),

            // Tombol kecil di pojok kanan bawah peta untuk beralih antara OSM Live & Peta Figma
            Positioned(
              right: 8,
              bottom: 8,
              child: GestureDetector(
                onTap: () =>
                    setState(() => _useInteractiveOsm = !_useInteractiveOsm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(235),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.primaryOrange.withAlpha(150),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.map_rounded,
                        size: 12,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _useInteractiveOsm ? 'OpenStreetMap Live' : 'Peta Statis',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_showOverlay)
              Container(
                color: Colors.black.withAlpha(125),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat ${widget.restaurantName} di Maps',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
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
