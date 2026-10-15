# Tugas 3 - Aplikasi Cuaca (Weather App)

**Nama**: M. Wildan Humaisi S. Budi  
**NIM**: D121241058  
**Mata Kuliah**: Pemrograman Mobile (Kelas C)  

---

## ⛅ Deskripsi Aplikasi
Aplikasi cuaca sederhana, modern, dan informatif yang dibangun menggunakan **Flutter** dan mengonsumsi data cuaca real-time dari **Open-Meteo REST API** (gratis tanpa perlu API key khusus).

## 🚀 Fitur Utama
1. **Informasi Cuaca Real-Time**:
   - Suhu saat ini (°C) & suhu yang dirasakan (apparent temperature).
   - Kondisi cuaca (Cerah, Cerah Berawan, Mendung, Hujan, Badai Petir, dsb.) dengan ikon dinamis dan warna tema adaptif.
   - Kelembapan udara (%), kecepatan angin (km/h), dan curah hujan (mm).
2. **Pilihan Cepat Kota Populer**:
   - Makassar, Jakarta, Surabaya, Bandung, Denpasar, Yogyakarta.
3. **Pencarian Kota (Geocoding API)**:
   - Pengguna dapat mencari cuaca di kota mana pun di Indonesia maupun mancanegara.
4. **Prakiraan 7 Hari ke Depan (7-Day Forecast)**:
   - Menampilkan ramalan cuaca harian lengkap dengan perkiraan suhu tertinggi & terendah.
5. **Pull-to-Refresh & Error Handling**:
   - Tarik layar ke bawah atau tekan tombol refresh untuk memperbarui data cuaca.
   - Penanganan offline / gangguan internet dengan tombol "Coba Lagi".

---

## 🛠️ Cara Menjalankan Aplikasi

Jalankan perintah berikut di terminal root proyek:

```bash
# Menjalankan langsung aplikasi tugas 3 Wildan:
flutter run -t "tugas 3/tugas 3 wildan (D121241058)/main.dart"
```

Atau jika menjalankan `lib/main.dart`:
```bash
flutter run
```
(Dapat diakses melalui menu navigasi anggota kelompok pada layar utama).
