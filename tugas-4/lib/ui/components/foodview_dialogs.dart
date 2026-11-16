import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Kumpulan komponen Popup & Dialog persis dari `Components.svg`:
/// 1. `Filter diterapkan`
/// 2. `Berhasil Terkirim!`
/// 3. `Berhasil Ditambah!`
/// 4. `Akun anda berhasil dibuat!`
/// 5. `Keluar dari akun Anda?` (`Keluar` / `Batalkan`)
/// 6. `Masuk ke akun Anda untuk mengakses fitur ini` (`Masuk` / `Batalkan`)
class FoodViewDialogs {
  /// Menampilkan popup status putih dengan teks oranye di tengah (auto-dismiss opsional).
  static Future<void> showStatusPopup(
    BuildContext context, {
    required String message,
    Duration autoDismiss = const Duration(milliseconds: 1300),
  }) async {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black26,
      builder: (ctx) {
        Future.delayed(autoDismiss, () {
          if (ctx.mounted && Navigator.of(ctx).canPop()) {
            Navigator.of(ctx).pop();
          }
        });
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 220,
            height: 92,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Menampilkan dialog konfirmasi `Keluar dari akun Anda?` sesuai `Components.svg`.
  static Future<bool> showLogoutConfirmDialog(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: 210,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 14),
                child: Text(
                  'Keluar dari akun\nAnda?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              InkWell(
                onTap: () => Navigator.of(ctx).pop(true),
                child: const SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: Center(
                    child: Text(
                      'Keluar',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              InkWell(
                onTap: () => Navigator.of(ctx).pop(false),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: Center(
                    child: Text(
                      'Batalkan',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return res ?? false;
  }

  /// Menampilkan dialog `Masuk ke akun Anda untuk mengakses fitur ini` sesuai `Components.svg`.
  static Future<bool> showLoginRequiredDialog(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: 230,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: Text(
                  'Masuk ke akun Anda\nuntuk mengakses fitur ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              InkWell(
                onTap: () => Navigator.of(ctx).pop(true),
                child: const SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: Center(
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              InkWell(
                onTap: () => Navigator.of(ctx).pop(false),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: Center(
                    child: Text(
                      'Batalkan',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return res ?? false;
  }
}
