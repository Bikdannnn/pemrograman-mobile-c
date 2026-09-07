double tentukanDiskon(double totalBelanja) {
  if (totalBelanja >= 500000) {
    return 0.20; // Diskon 20% jika total >= 500.000
  } else if (totalBelanja >= 250000) {
    return 0.15; // Diskon 15% jika total >= 250.000
  } else if (totalBelanja >= 100000) {
    return 0.10; // Diskon 10% jika total >= 100.000
  } else if (totalBelanja >= 50000) {
    return 0.05; // Diskon 5% jika total >= 50.000
  } else {
    return 0.0;  // Tidak ada diskon jika total < 50.000
  }
}

void tampilkanRingkasanBelanja({
  required Map<String, int> keranjang,
  required Map<String, double> katalogHarga,
}) {
  print('               STRUK PEMBELIAN                 ');

  double subtotal = 0.0;

  for (var entry in keranjang.entries) {
    String namaBarang = entry.key;
    int jumlah = entry.value;

    if (katalogHarga.containsKey(namaBarang)) {
      double hargaSatuan = katalogHarga[namaBarang]!;
      double totalItem = hargaSatuan * jumlah;
      subtotal += totalItem;

      print('${namaBarang.padRight(16)} (x$jumlah) : Rp ${totalItem.toStringAsFixed(0)}');
    } else {
      print('${namaBarang.padRight(16)} (x$jumlah) : [Barang tidak tersedia]');
    }
  }

  // Menghitung diskon dan total akhir
  double diskonPersen = tentukanDiskon(subtotal);
  double nominalDiskon = subtotal * diskonPersen;
  double totalAkhir = subtotal - nominalDiskon;

  print('Subtotal Belanja        : Rp ${subtotal.toStringAsFixed(0)}');
  print('Diskon (${(diskonPersen * 100).toInt()}%)            : -Rp ${nominalDiskon.toStringAsFixed(0)}');
  print('TOTAL AKHIR             : Rp ${totalAkhir.toStringAsFixed(0)}');
}

void main() {
  // 1. Menyimpan daftar harga menggunakan Map (built-in type)
  Map<String, double> daftarHarga = {
    'Keyboard Mechanical': 350000.0,
    'Mouse Gaming': 150000.0,
    'Headset Gaming': 250000.0,
    'Mousepad XL': 85000.0,
    'Webcam HD': 275000.0,
    'USB Hub': 60000.0,
  };

  // 2. Menyimpan daftar belanjaan menggunakan Map (built-in type)
  Map<String, int> daftarBelanjaan = {
    'Keyboard Mechanical': 1,
    'Mouse Gaming': 1,
    'Mousepad XL': 2,
  };

  // 4. Memproses dan menampilkan total akhir belanjaan setelah diskon
  tampilkanRingkasanBelanja(
    keranjang: daftarBelanjaan,
    katalogHarga: daftarHarga,
  );
}
