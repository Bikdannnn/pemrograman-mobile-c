void main() {
  // 1. Menyimpan daftar harga
  Map<String, int> harga = {
    'Beras': 75000,
    'Minyak': 20000,
    'Gula': 18000,
    'Telur': 30000,
  };

  // 2. Menyimpan daftar belanjaan
  Map<String, int> belanjaan = {
    'Beras': 1,
    'Minyak': 2,
    'Gula': 1,
    'Telur': 1,
  };

  // Menghitung total belanja
  int total = hitungTotal(harga, belanjaan);

  // 3. Menentukan case diskon
  double diskon = hitungDiskon(total);

  // Menghitung jumlah potongan
  double potongan = total * diskon;

  // 4. Menghitung total akhir setelah diskon
  double totalAkhir = total - potongan;

  // Menampilkan hasil
  print('Total belanja : Rp$total');
  print('Diskon        : ${diskon * 100}%');
  print('Potongan      : Rp$potongan');
  print('Total akhir   : Rp$totalAkhir');
}


// Function untuk menghitung total belanja
int hitungTotal(
    Map<String, int> harga,
    Map<String, int> belanjaan) {

  int total = 0;

  for (String barang in belanjaan.keys) {
    total += harga[barang]! * belanjaan[barang]!;
  }

  return total;
}


// Function untuk menentukan diskon
double hitungDiskon(int total) {
  if (total >= 150000) {
    return 0.20;
  } else if (total >= 100000) {
    return 0.10;
  } else if (total >= 50000) {
    return 0.05;
  } else {
    return 0;
  }
}