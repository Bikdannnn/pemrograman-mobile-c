import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'owner_profile_screen.dart';

/// Layar `Notifikasi` pada Role PEMILIK RESTORAN sesuai `PEMILIK RESTORAN.svg`:
/// Menampilkan daftar notifikasi rating bintang dari pelanggan (`Gibran Nur Saleh memberi 5 bintang.`, dsb.).
class OwnerNotificationScreen extends StatelessWidget {
  const OwnerNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            'Notifikasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.ownerNotifications.length,
            itemBuilder: (context, index) {
              final notif = state.ownerNotifications[index];
              return FoodViewNotificationTile(
                menuName: notif.menuName,
                userName: notif.userName,
                stars: notif.stars,
                avatarAsset: notif.avatarAsset,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OwnerMenuReviewDetailScreen(
                        menu: state.menus.first,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
