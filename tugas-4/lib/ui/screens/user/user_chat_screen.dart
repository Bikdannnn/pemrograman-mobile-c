import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_restaurant_detail_screen.dart';

/// Layar Daftar `Chat Toko` pada Role USER sesuai `USER.svg`.
class UserChatListScreen extends StatefulWidget {
  const UserChatListScreen({super.key});

  @override
  State<UserChatListScreen> createState() => _UserChatListScreenState();
}

class _UserChatListScreenState extends State<UserChatListScreen> {
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();
    final q = _searchController.text.trim().toLowerCase();
    final chats = state.userChats.where((c) {
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.lastMessage.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_searching)
                const Text(
                  'Chat Toko',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                )
              else
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari chat toko...',
                      isDense: true,
                    ),
                  ),
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _searching = !_searching;
                    if (!_searching) _searchController.clear();
                  });
                },
                icon: Icon(
                  _searching ? Icons.close_rounded : Icons.search_rounded,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final thread = chats[index];
              return FoodViewChatListTile(
                name: thread.name,
                lastMessage: thread.lastMessage,
                time: thread.time,
                unreadCount: thread.unreadCount,
                avatarAsset: thread.avatarAsset,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserChatDetailScreen(thread: thread),
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

/// Layar Detail Percakapan `Warung Bu Atik` pada Role USER sesuai `USER.svg`:
/// - Header putih dengan tombol kembali, logo `Warung Bu Atik`, status `Online`, dan ikon toko di kanan
/// - Tanggal `"Sen, 27 Mei"`
/// - Bubble pesan pelanggan berwarna hijau muda `#E1EEDD` & bubble balasan putih
/// - Input bar bawah dengan ikon kamera, kolom pesan, dan tombol kirim oranye
class UserChatDetailScreen extends StatefulWidget {
  final ChatThreadModel thread;

  const UserChatDetailScreen({
    super.key,
    required this.thread,
  });

  @override
  State<UserChatDetailScreen> createState() => _UserChatDetailScreenState();
}

class _UserChatDetailScreenState extends State<UserChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _send(FoodViewUiState state) {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    state.sendChatMessage(
      thread: widget.thread,
      text: text,
      isCustomer: true,
    );
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            // Header Chat
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  CircleAvatar(
                    radius: 19,
                    backgroundImage: AssetImage(widget.thread.avatarAsset),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.thread.name,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Lihat Restoran',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserRestaurantDetailScreen(
                            restaurant: state.restaurants.first,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),

            // Isi Percakapan
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Text(
                        'Sen, 27 Mei',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ),
                  for (final msg in widget.thread.messages)
                    FoodViewChatBubble(
                      text: msg.text,
                      isGreenBubble: msg.isCustomer,
                      alignRight: false,
                    ),
                ],
              ),
            ),

            // Input Pesan di bawah
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.primaryOrange.withAlpha(160),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.camera_alt_rounded,
                      size: 19,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        onSubmitted: (_) => _send(state),
                        style: const TextStyle(fontSize: 12.5),
                        decoration: const InputDecoration(
                          hintText: 'Tulis pesan...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.textGray,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _send(state),
                      child: const Icon(
                        Icons.send_rounded,
                        size: 19,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
