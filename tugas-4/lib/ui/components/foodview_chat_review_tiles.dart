import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'foodview_star_rating.dart';

/// Item Ulasan/Komentar Pelanggan sesuai `Components.svg`, `USER.svg`, dan `PEMILIK RESTORAN.svg`:
/// Avatar bulat di kiri, nama pengguna abu-abu, teks komentar hitam, dan 5 bintang di bawahnya.
class FoodViewReviewCommentTile extends StatelessWidget {
  final String userName;
  final String comment;
  final String avatarAsset;
  final double rating;

  const FoodViewReviewCommentTile({
    super.key,
    required this.userName,
    required this.comment,
    required this.avatarAsset,
    this.rating = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(avatarAsset),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                FoodViewStarRow(rating: rating, size: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item Daftar Chat (`Chat Toko` pada User & `Chat Pelanggan` pada Pemilik Restoran) sesuai `Components.svg`.
class FoodViewChatListTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String avatarAsset;
  final VoidCallback onTap;

  const FoodViewChatListTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    required this.avatarAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage(avatarAsset),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMessage,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (unreadCount > 0)
                  Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 17),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Gelembung pesan percakapan (`Chat Bubble`) sesuai layar Chat di `USER.svg` & `PEMILIK RESTORAN.svg`:
/// - Bubble hijau muda `#E1EEDD` untuk pesan yang disorot / dikirim
/// - Bubble putih ber-border abu tipis untuk balasan
class FoodViewChatBubble extends StatelessWidget {
  final String text;
  final bool isGreenBubble;
  final bool alignRight;

  const FoodViewChatBubble({
    super.key,
    required this.text,
    required this.isGreenBubble,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 310),
        decoration: BoxDecoration(
          color: isGreenBubble ? AppColors.lightGreenPill : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isGreenBubble
              ? null
              : Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textDark,
            height: 1.38,
          ),
        ),
      ),
    );
  }
}

/// Item Notifikasi pada layar `Notifikasi` Pemilik Restoran sesuai `Components.svg` & `PEMILIK RESTORAN.svg`:
/// Avatar bulat di kiri, nama menu berwarna oranye di atas, dan teks `"<user> memberi 5 bintang."` di bawahnya.
class FoodViewNotificationTile extends StatelessWidget {
  final String menuName;
  final String userName;
  final int stars;
  final String avatarAsset;
  final VoidCallback? onTap;

  const FoodViewNotificationTile({
    super.key,
    required this.menuName,
    required this.userName,
    this.stars = 5,
    required this.avatarAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundImage: AssetImage(avatarAsset),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuName,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$userName memberi $stars bintang.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
