import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import '../user/user_auth_screen.dart';
import '../user/user_profile_screen.dart';
import 'owner_auth_screen.dart';

/// Layar `Profil Restoran` pada Role PEMILIK RESTORAN sesuai `PEMILIK RESTORAN.svg`:
/// - Menampilkan logo bulat `Warung Bu Atik`, nama `"Warung Bu Atik ✏️"`, deskripsi usaha,
///   serta 3 menu utama:
///   1. `Manajemen Menu` -> membuka `OwnerMenuManagementScreen`
///   2. `Lihat Rating & Review` -> membuka `OwnerRatingReviewListScreen`
///   3. `Pengaturan` -> membuka `FoodViewSettingsScreen(isOwner: true)`
class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    if (!state.isOwnerLoggedIn) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.storefront_rounded,
              size: 70,
              color: Color(0xFFD9D9D9),
            ),
            const SizedBox(height: 10),
            const Text(
              'Masuk ke Akun Pemilik Restoran',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 140,
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OwnerAuthScreen(),
                    ),
                  );
                },
                child: const Text('Masuk'),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Column(
        children: [
          const Text(
            'Profil Restoran',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/u_pm_12.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.ownerRestaurantName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.edit_rounded,
                size: 13,
                color: AppColors.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            state.ownerRestaurantBio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textGray,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          _OwnerActionRow(
            icon: Icons.favorite_rounded,
            label: 'Manajemen Menu',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OwnerMenuManagementScreen(),
                ),
              );
            },
          ),
          _OwnerActionRow(
            icon: Icons.history_rounded,
            label: 'Lihat Rating & Review',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OwnerRatingReviewListScreen(),
                ),
              );
            },
          ),
          _OwnerActionRow(
            icon: Icons.settings_outlined,
            label: 'Pengaturan',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FoodViewSettingsScreen(isOwner: true),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OwnerActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OwnerActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryGreen),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textDark,
            ),
          ],
        ),
      ),
    );
  }
}

/// Layar `Manajemen Menu` sesuai `PEMILIK RESTORAN.svg`:
/// - Header hijau tua `"Manajemen Menu"`
/// - Tombol atas `"+ Tambah menu baru"` ber-border abu tipis dengan ikon `+` oranye
/// - Daftar kartu menu (`FoodViewOwnerMenuCard`) lengkap dengan tombol `⋮` (`Edit` / `Hapus`)
class OwnerMenuManagementScreen extends StatelessWidget {
  const OwnerMenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Manajemen Menu',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          // Tombol "+ Tambah menu baru" (persis PEMILIK RESTORAN.svg)
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OwnerMenuFormScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tambah menu baru',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          for (final menu in state.menus)
            FoodViewOwnerMenuCard(
              name: menu.name,
              description: menu.description,
              price: menu.price,
              imageAsset: menu.imageAsset,
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OwnerMenuFormScreen(existingMenu: menu),
                  ),
                );
              },
              onDelete: () {
                state.deleteOwnerMenu(menu.id);
              },
            ),
        ],
      ),
    );
  }
}

/// Layar `Tambah Menu` & `Edit Menu` sesuai 4 frame form pada `PEMILIK RESTORAN.svg`:
/// - Field 1: `Nama menu` (`Ayam Rica` / `Ayam Goreng Rica`)
/// - Field 2: `Harga menu` (`25.000`)
/// - Field 3: `Deskripsi menu` + kotak teks abu-abu `"Ketikkan sesuatu..."`
/// - Field 4: `Foto menu` + kotak upload (`"+ Tambah file"` -> `"ayam-goreng-rica.jpg"` + `"↻ Ubah"`)
/// - Tombol `"Tambah"` atau `"Edit"` (abu-abu saat belum lengkap, oranye `#F0A04B` saat terisi)
class OwnerMenuFormScreen extends StatefulWidget {
  final MenuModel? existingMenu;

  const OwnerMenuFormScreen({
    super.key,
    this.existingMenu,
  });

  @override
  State<OwnerMenuFormScreen> createState() => _OwnerMenuFormScreenState();
}

class _OwnerMenuFormScreenState extends State<OwnerMenuFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descController;
  String? _photoFileName;

  bool get _isEditMode => widget.existingMenu != null;

  @override
  void initState() {
    super.initState();
    final m = widget.existingMenu;
    _nameController = TextEditingController(text: m?.name ?? '');
    _priceController = TextEditingController(
      text: m?.price.replaceAll('Rp', '').replaceAll('Rp.', '') ?? '',
    );
    _descController = TextEditingController(text: m?.description ?? '');
    _photoFileName = m?.fileName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool get _isFilled =>
      _nameController.text.trim().isNotEmpty &&
      _priceController.text.trim().isNotEmpty &&
      _descController.text.trim().isNotEmpty &&
      _photoFileName != null;

  void _fillDemoMenu() {
    setState(() {
      _nameController.text = _isEditMode ? 'Ayam Goreng Rica' : 'Ayam Rica';
      _priceController.text = '25.000';
      _descController.text =
          'Hidangan khas Indonesia berupa ayam yang digoreng lalu dibalut dengan sambal rica pedas khas Manado.';
      _photoFileName = 'ayam-goreng-rica.jpg';
    });
  }

  Future<void> _submit() async {
    if (!_isFilled) return;

    final state = context.read<FoodViewUiState>();
    if (_isEditMode) {
      state.updateOwnerMenu(
        id: widget.existingMenu!.id,
        name: _nameController.text.trim(),
        price: _priceController.text.trim(),
        description: _descController.text.trim(),
        fileName: _photoFileName,
      );
      await FoodViewDialogs.showStatusPopup(
        context,
        message: 'Berhasil Terkirim!',
      );
    } else {
      state.addOwnerMenu(
        name: _nameController.text.trim(),
        price: _priceController.text.trim(),
        description: _descController.text.trim(),
        fileName: _photoFileName!,
      );
      await FoodViewDialogs.showStatusPopup(
        context,
        message: 'Berhasil Ditambah!',
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: Text(
          _isEditMode ? 'Edit Menu' : 'Tambah Menu',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _fillDemoMenu,
            child: const Text(
              'Isi Demo',
              style: TextStyle(fontSize: 11, color: AppColors.primaryOrange),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            FoodViewAuthInputField(
              controller: _nameController,
              hintText: 'Nama menu',
              icon: Icons.person_rounded,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            FoodViewAuthInputField(
              controller: _priceController,
              hintText: 'Harga menu',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),

            // Kotak Deskripsi Menu (persis PEMILIK RESTORAN.svg)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderGray, width: 0.9),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.phone_rounded,
                        size: 17,
                        color: AppColors.primaryGreen,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Deskripsi menu',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 92,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _descController,
                      maxLines: 4,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textDark,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ketikkan sesuatu...',
                        hintStyle: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGray,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Kotak Foto Menu (persis PEMILIK RESTORAN.svg)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderGray, width: 0.9),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        size: 17,
                        color: AppColors.primaryGreen,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Foto menu',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: _photoFileName == null
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _photoFileName = 'ayam-goreng-rica.jpg';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB5B5B5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '+ Tambah file',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _photoFileName!,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    setState(() => _photoFileName = null);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB5B5B5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      '↻ Ubah',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            FoodViewPrimaryButton(
              text: _isEditMode ? 'Edit' : 'Tambah',
              enabled: _isFilled,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Layar Daftar `Rating & Review` pada Role PEMILIK RESTORAN sesuai `PEMILIK RESTORAN.svg`.
class OwnerRatingReviewListScreen extends StatelessWidget {
  const OwnerRatingReviewListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Rating & Review',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        itemCount: state.menus.length,
        itemBuilder: (context, index) {
          final menu = state.menus[index];
          return FoodViewOwnerMenuCard(
            name: menu.name,
            description: menu.description,
            price: menu.price,
            imageAsset: menu.imageAsset,
            isReviewMode: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OwnerMenuReviewDetailScreen(menu: menu),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Layar Detail `Rating & Review` per Menu pada Role PEMILIK RESTORAN
/// sesuai `PEMILIK RESTORAN.svg` (menampilkan foto hidangan, harga, deskripsi, dan `4 Komentar`).
class OwnerMenuReviewDetailScreen extends StatelessWidget {
  final MenuModel menu;

  const OwnerMenuReviewDetailScreen({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Rating & Review',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                menu.imageAsset,
                width: double.infinity,
                height: 195,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              menu.price,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              menu.name,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              menu.description,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGray,
                height: 1.38,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              '${menu.reviews.length} Komentar',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            for (final rev in menu.reviews)
              FoodViewReviewCommentTile(
                userName: rev.userName,
                comment: rev.comment,
                avatarAsset: rev.avatarAsset,
                rating: rev.rating,
              ),
          ],
        ),
      ),
    );
  }
}
