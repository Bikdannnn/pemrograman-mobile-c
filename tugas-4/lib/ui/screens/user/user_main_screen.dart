import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import 'user_auth_screen.dart';
import 'user_home_screen.dart';
import 'user_profile_screen.dart';

/// Main Shell untuk Role USER (`Home`, `Profile`) — tanpa fitur Chat.
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodViewUiState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            UserHomeScreen(
              onOpenFavoritku: () async {
                if (!state.isUserLoggedIn) {
                  final goLogin =
                      await FoodViewDialogs.showLoginRequiredDialog(context);
                  if (goLogin && context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const UserAuthScreen(),
                      ),
                    );
                  }
                  return;
                }
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UserFavoritkuScreen(),
                  ),
                );
              },
            ),
            const UserProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: FoodViewUserBottomNav(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}
