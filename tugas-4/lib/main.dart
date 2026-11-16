import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/components_preview_screen.dart';
import 'ui/screens/owner/owner_auth_screen.dart';
import 'ui/screens/owner/owner_main_screen.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/screens/user/user_auth_screen.dart';
import 'ui/screens/user/user_main_screen.dart';
import 'ui/view_models/foodview_ui_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FoodViewUiState(),
      child: const FoodViewApp(),
    ),
  );
}

class FoodViewApp extends StatelessWidget {
  const FoodViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodView - Pemrograman Mobile C',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _RootFlowSwitcher(),
    );
  }
}

class _RootFlowSwitcher extends StatefulWidget {
  const _RootFlowSwitcher();

  @override
  State<_RootFlowSwitcher> createState() => _RootFlowSwitcherState();
}

class _RootFlowSwitcherState extends State<_RootFlowSwitcher> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return FoodViewSplashScreen(
        onFinished: () => setState(() => _showSplash = false),
      );
    }

    final state = context.watch<FoodViewUiState>();

    return Scaffold(
      body: Column(
        children: [
          // Bar Penguji / Quick Figma Switcher (USER.svg | PEMILIK RESTORAN.svg | Components.svg)
          Material(
            color: const Color(0xFF102814),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    _ModeChip(
                      label: 'USER',
                      selected: state.activeRole == AppActiveRole.user,
                      onTap: () => state.setRole(AppActiveRole.user),
                    ),
                    const SizedBox(width: 6),
                    _ModeChip(
                      label: 'PEMILIK RESTORAN',
                      selected:
                          state.activeRole == AppActiveRole.pemilikRestoran,
                      onTap: () =>
                          state.setRole(AppActiveRole.pemilikRestoran),
                    ),
                    const SizedBox(width: 6),
                    _ModeChip(
                      label: 'COMPONENTS',
                      selected: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ComponentsPreviewScreen(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                state.activeRole == AppActiveRole.user
                                    ? const UserAuthScreen()
                                    : const OwnerAuthScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        child: Text(
                          'Auth',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => setState(() => _showSplash = true),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        child: Icon(
                          Icons.replay_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Konten Layar Utama berdasarkan Role aktif
          Expanded(
            child: state.activeRole == AppActiveRole.user
                ? const UserMainScreen()
                : const OwnerMainScreen(),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryOrange : Colors.white12,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
