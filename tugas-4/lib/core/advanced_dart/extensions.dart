/// Implementasi Advance Dart:
/// Extension Methods pada tipe bawaan (`num`, `String`, `DateTime`, `Iterable`)
library;

extension CurrencyFormatExtension on num {
  /// Mengubah angka menjadi format Rupiah (contoh: `Rp 25.000`).
  String toRupiah() {
    final intValue = round();
    final digits = intValue.abs().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    final prefix = intValue < 0 ? '-Rp ' : 'Rp ';
    return '$prefix$buffer';
  }

  /// Format rating 1 desimal (contoh: `4.8`).
  String toRatingString() => toStringAsFixed(1);
}

extension StringFormattingExtension on String {
  /// Mengubah huruf awal tiap kata menjadi kapital (Title Case).
  String toTitleCase() {
    if (trim().isEmpty) return this;
    return trim()
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty
            ? w
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// Mengambil inisial nama (maksimal 2 huruf) untuk Avatar.
  String get initials {
    final parts = trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    return switch (parts) {
      [] => 'U',
      [final single] => single[0].toUpperCase(),
      [final first, ..., final last] =>
        '${first[0]}${last[0]}'.toUpperCase(),
    };
  }
}

extension DateTimeRelativeExtension on DateTime {
  /// Menghasilkan keterangan waktu relatif dalam Bahasa Indonesia.
  String toRelativeTime() {
    final diff = DateTime.now().difference(this);
    return switch (diff) {
      Duration(inSeconds: < 60) => 'Baru saja',
      Duration(inMinutes: final m) when m < 60 => '$m menit lalu',
      Duration(inHours: final h) when h < 24 => '$h jam lalu',
      Duration(inDays: final d) when d < 7 => '$d hari lalu',
      _ =>
        '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year',
    };
  }
}

extension IterableHigherOrderExtension<T> on Iterable<T> {
  /// Higher-order function generic untuk mengelompokkan koleksi berdasarkan key.
  Map<K, List<T>> groupBy<K>(K Function(T item) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      (map[key] ??= <T>[]).add(element);
    }
    return map;
  }
}
