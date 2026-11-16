import 'package:flutter/material.dart';
import '../../components/components.dart';
import 'owner_chat_screen.dart';
import 'owner_notification_screen.dart';
import 'owner_profile_screen.dart';

/// Main Shell untuk Role PEMILIK RESTORAN (`Chat Pelanggan`, `Notifikasi`, `Profil Restoran`)
/// sesuai `PEMILIK RESTORAN.svg`.
class OwnerMainScreen extends StatefulWidget {
  const OwnerMainScreen({super.key});

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen> {
  int _currentIndex = 2; // Default membuka Profil Restoran / Dashboard atau Chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            OwnerChatListScreen(),
            OwnerNotificationScreen(),
            OwnerProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: FoodViewOwnerBottomNav(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}
