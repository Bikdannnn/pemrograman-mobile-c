import 'package:flutter/material.dart';
import '../../components/components.dart';
import 'owner_notification_screen.dart';
import 'owner_profile_screen.dart';

/// Main Shell untuk Role PEMILIK RESTORAN (`Notifikasi`, `Profil Restoran`)
/// — tanpa fitur Chat.
class OwnerMainScreen extends StatefulWidget {
  const OwnerMainScreen({super.key});

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen> {
  int _currentIndex = 1; // Default membuka Profil Restoran

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
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
