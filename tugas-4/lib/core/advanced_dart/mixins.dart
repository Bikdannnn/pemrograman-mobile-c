/// Implementasi Advance Dart:
/// Mixins (`ValidationMixin` & `SearchFilterMixin`) untuk enkapsulasi logika lintas class.
library;

mixin ValidationMixin {
  String? validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email wajib diisi';
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(text)) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Kata sandi wajib diisi';
    if (text.length < 6) return 'Kata sandi minimal 6 karakter';
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'Harga wajib diisi';
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
    final parsed = double.tryParse(clean);
    if (parsed == null || parsed <= 0) return 'Masukkan nominal harga yang valid';
    return null;
  }
}

mixin SearchFilterMixin {
  /// Mencocokkan kueri pencarian terhadap beberapa field teks sekaligus.
  bool matchesQuery(String query, List<String> fields) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return fields.any((f) => f.toLowerCase().contains(normalized));
  }
}
