import 'dart:math' show sin, cos, atan2, sqrt, pi;
import 'package:geolocator/geolocator.dart';

/// Service untuk mendapatkan lokasi GPS pengguna dan menghitung jarak
class LocationService {
  static final LocationService instance = LocationService._();
  LocationService._();

  Position? _lastPosition;
  Position? get lastPosition => _lastPosition;

  /// Meminta izin lokasi dan mendapatkan posisi saat ini
  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return _fallbackMakassar();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _fallbackMakassar();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return _fallbackMakassar();
      }

      _lastPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return _lastPosition;
    } catch (_) {
      return _fallbackMakassar();
    }
  }

  /// Fallback ke pusat Makassar jika GPS tidak tersedia
  Position _fallbackMakassar() {
    _lastPosition = Position(
      latitude: -5.1477,
      longitude: 119.4327,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
    return _lastPosition!;
  }

  /// Menghitung jarak antara 2 titik koordinat (Haversine formula) dalam meter
  static double calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0; // meter
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degToRad(double deg) => deg * (pi / 180);

  /// Mendeteksi nama wilayah / kecamatan berdasarkan koordinat
  static String detectAreaName(double lat, double lon) {
    // Area Samata / Somba Opu (Gowa)
    if (lat <= -5.18 && lon >= 119.46) {
      return 'Samata, Somba Opu';
    }
    // Area Panakkukang (Makassar)
    if (lat >= -5.17 && lat <= -5.14 && lon >= 119.43) {
      return 'Panakkukang, Makassar';
    }
    // Area Losari / Ujung Pandang (Makassar)
    if (lon < 119.43) {
      return 'Losari / Ujung Pandang';
    }
    return 'Makassar & Sekitarnya';
  }

  /// Menentukan area/kecamatan dari teks alamat
  static String extractDistrict(String address) {
    final lower = address.toLowerCase();
    if (lower.contains('somba opu') || lower.contains('samata')) {
      return 'Kec. Somba Opu, Gowa';
    }
    if (lower.contains('panakkukang')) {
      return 'Kec. Panakkukang, Makassar';
    }
    if (lower.contains('losari')) {
      return 'Losari, Makassar';
    }
    if (lower.contains('ujung pandang')) {
      return 'Kec. Ujung Pandang, Makassar';
    }
    if (lower.contains('wajo')) {
      return 'Kec. Wajo, Makassar';
    }
    return 'Makassar';
  }

  /// Format jarak ke string yang user-friendly
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// Menentukan tag jarak untuk filter
  static String distanceTag(double meters) {
    if (meters < 1000) return '<1 km';
    if (meters < 2000) return '1-2 km';
    if (meters < 5000) return '2-5 km';
    return '>5 km';
  }
}
