# Tugas 4 / Projek Akhir - FoodView (UI Modular Component & Screen)

Proyek Flutter aplikasi **FoodView** yang dibangun berdasarkan desain Figma (`Components.svg`, `USER.svg`, dan `PEMILIK RESTORAN.svg`) dengan arsitektur modular `component -> screen` di dalam `lib/ui/`.

---

## 📁 Struktur Direktori (`lib/ui/`)

```text
tugas-4/
├── assets/
│   └── images/                              # Aset ilustrasi, peta, foto menu, restoran & avatar hasil ekstraksi SVG Figma
└── lib/
    ├── core/
    │   ├── advanced_dart/
    │   │   ├── api_state.dart               # Sealed classes, Generics, Exhaustive Pattern Matching & Records
    │   │   ├── extensions.dart              # Extension methods (Currency, String, DateTime)
    │   │   └── mixins.dart                  # ValidationMixin & SearchFilterMixin
    │   └── theme/
    │       └── app_theme.dart               # Palet warna Figma (#183A1D, #F0A04B, #D9750B, #FEFBE9, #E1EEDD)
    ├── ui/
    │   ├── components/                      # Modular UI Components (dari Components.svg)
    │   │   ├── components.dart              # Barrel export seluruh komponen
    │   │   ├── foodview_search_bar.dart     # Search bar putih ber-outline oranye + tombol filter
    │   │   ├── foodview_filter_dialog.dart  # Kartu Filter (Jarak, Harga, Jam Operasional) & Filter Chip
    │   │   ├── foodview_buttons.dart        # Tombol utama, sekunder, tombol bulat Favorit (Heart) & Chat
    │   │   ├── foodview_dialogs.dart        # Popup status ("Filter diterapkan", "Berhasil Terkirim!", dsb.) & konfirmasi
    │   │   ├── foodview_star_rating.dart    # Baris bintang statis & pemilih 1-5 bintang interaktif
    │   │   ├── foodview_restaurant_cards.dart # Kartu Restoran, Top of the Week, Riwayat & Restoran Favorit
    │   │   ├── foodview_menu_cards.dart     # Kartu Menu Favoritku, Grid Menu 2 Kolom & Kartu Menu Pemilik Restoran
    │   │   ├── foodview_chat_review_tiles.dart # Tile Komentar Ulasan, Daftar Chat, Chat Bubble & Notifikasi
    │   │   ├── foodview_map_card.dart       # Kartu Peta Claro Hotel Makassar + overlay "Lihat di Maps"
    │   │   └── foodview_bottom_nav.dart     # Bottom Navigation Bar User & Pemilik Restoran
    │   ├── view_models/
    │   │   └── foodview_ui_state.dart       # State Management (Provider ChangeNotifier)
    │   └── screens/                         # Modular Screens (dari USER.svg & PEMILIK RESTORAN.svg)
    │       ├── components_preview_screen.dart # Katalog interaktif seluruh komponen Components.svg
    │       ├── splash/
    │       │   └── splash_screen.dart       # Splash screen 3 tahap (#FEFBE9 -> Ilustrasi -> FoodView)
    │       ├── user/                        # Layar Role USER (USER.svg)
    │       │   ├── user_main_screen.dart
    │       │   ├── user_home_screen.dart
    │       │   ├── user_search_screen.dart
    │       │   ├── user_restaurant_detail_screen.dart
    │       │   ├── user_menu_detail_screen.dart
    │       │   ├── user_chat_screen.dart
    │       │   ├── user_auth_screen.dart
    │       │   └── user_profile_screen.dart
    │       └── owner/                       # Layar Role PEMILIK RESTORAN (PEMILIK RESTORAN.svg)
    │           ├── owner_main_screen.dart
    │           ├── owner_auth_screen.dart
    │           ├── owner_chat_screen.dart
    │           ├── owner_notification_screen.dart
    │           └── owner_profile_screen.dart
    └── main.dart                            # Entry point aplikasi
```

---

## 🚀 Cara Menjalankan

```bash
cd tugas-4
flutter pub get
flutter run
```
