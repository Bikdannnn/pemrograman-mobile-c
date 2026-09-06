Map<String, double> daftarHarga = {
  'Buku': 15000,
  'Pena': 5000,
  'Tas': 150000,
  'Sepatu': 200000,
  'Penggaris': 3000,
};

double hitungPersentaseDiskon(double total) {

  if (total >= 200000) {
    return 20.0; 
  } else if (total >= 100000) {
    return 10.0; 
  } else if (total >= 50000) {
    return 5.0;  
  } else {
    return 0.0;  
  }
}

void prosesBelanjaan(Map<String, int> daftarBelanjaan) {
  double totalAwal = 0;

  print('--- Struk Belanja ---');
  
  daftarBelanjaan.forEach((barang, jumlah) {
    if (daftarHarga.containsKey(barang)) {
      double hargaSatuan = daftarHarga[barang]!;
      double subTotal = hargaSatuan * jumlah;
      totalAwal += subTotal;
      print('$barang (x$jumlah)\t: Rp $subTotal');
    } else {
      print('$barang \t\t: Barang tidak ditemukan');
    }
  });

  print('---------------------');
  print('Total Awal\t: Rp $totalAwal');

  double persentaseDiskon = hitungPersentaseDiskon(totalAwal);
  double nominalDiskon = totalAwal * (persentaseDiskon / 100);
  
  double totalAkhir = totalAwal - nominalDiskon;

  print('Diskon ($persentaseDiskon%)\t: -Rp $nominalDiskon');
  print('Total Akhir\t: Rp $totalAkhir');
  print('---------------------');
}

void main() {
  Map<String, int> belanjaanSaya = {
    'Buku': 3,
    'Tas': 1,
    'Pena': 2,
  };

  prosesBelanjaan(belanjaanSaya);
}
