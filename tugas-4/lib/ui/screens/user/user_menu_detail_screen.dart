import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_auth_screen.dart';
import 'user_chat_screen.dart';

/// Layar Detail Menu (`Ayam Goreng Rica`) sesuai `USER.svg` (kolom paling kanan):
/// - Baris atas: Tombol kembali di kiri, tombol bulat Chat & Favorit di kanan
/// - Foto besar hidangan di atas
/// - Harga (`Rp25.000`), Judul (`Ayam Goreng Rica`), Deskripsi
/// - Bagian `Beri Penilaian` (5 bintang interaktif) & `Beri Ulasan` + tombol `Kirim`
/// - Daftar ulasan pelanggan untuk menu tersebut
class UserMenuDetailScreen extends StatefulWidget {
  final MenuModel menu;

  const UserMenuDetailScreen({
    super.key,
    required this.menu,
  });

  @override
  State<UserMenuDetailScreen> createState() => _UserMenuDetailScreenState();
}

class _UserMenuDetailScreenState extends State<UserMenuDetailScreen> {
  int _selectedStars = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<bool> _ensureLoggedIn(FoodViewUiState state) async {
    if (state.isUserLoggedIn) return true;
    final goLogin = await FoodViewDialogs.showLoginRequiredDialog(context);
    if (goLogin && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const UserAuthScreen()),
      );
    }
    return false;
  }

  Future<void> _submitDishReview(FoodViewUiState state) async {
    if (!await _ensureLoggedIn(state)) return;
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) return;

    final stars = _selectedStars == 0 ? 5 : _selectedStars;
    state.addMenuReview(widget.menu.id, stars, comment);
    _reviewController.clear();
    setState(() => _selectedStars = 0);

    if (mounted) {
      await FoodViewDialogs.showStatusPopup(
        context,
        message: 'Berhasil Terkirim!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();
    final currentMenu = state.menus.firstWhere(
      (m) => m.id == widget.menu.id,
      orElse: () => widget.menu,
    );
    final isReadyToSend = _reviewController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: Back + Chat + Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Row(
                    children: [
                      FoodViewChatCircleButton(
                        onTap: () async {
                          if (!await _ensureLoggedIn(state)) return;
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UserChatDetailScreen(
                                thread: state.userChats.first,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      FoodViewFavoriteButton(
                        isFavorite: currentMenu.isFavorite,
                        onTap: () async {
                          if (!await _ensureLoggedIn(state)) return;
                          state.toggleMenuFavorite(currentMenu.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Foto Hidangan Besar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  currentMenu.imageAsset,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                currentMenu.price,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                currentMenu.name,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                currentMenu.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGray,
                  height: 1.38,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Beri Penilaian',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              FoodViewInteractiveStars(
                selectedStars: _selectedStars,
                onStarSelected: (s) => setState(() => _selectedStars = s),
              ),

              const SizedBox(height: 12),

              const Text(
                'Beri Ulasan',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _reviewController,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Ketikkan sesuatu...',
                    hintStyle: TextStyle(
                      fontSize: 11.5,
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

              const SizedBox(height: 10),

              FoodViewPrimaryButton(
                text: 'Kirim',
                enabled: isReadyToSend,
                height: 38,
                onPressed: () => _submitDishReview(state),
              ),

              const SizedBox(height: 18),

              for (final rev in currentMenu.reviews)
                FoodViewReviewCommentTile(
                  userName: rev.userName,
                  comment: rev.comment,
                  avatarAsset: rev.avatarAsset,
                  rating: rev.rating,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
