import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/services/firebase_hybrid_service.dart';
import 'ui/screens/owner/owner_main_screen.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/screens/user/user_main_screen.dart';
import 'ui/view_models/foodview_ui_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const _RootFlowContainer(),
    );
  }
}

class _RootFlowContainer extends StatefulWidget {
  const _RootFlowContainer();

  @override
  State<_RootFlowContainer> createState() => _RootFlowContainerState();
}

class _RootFlowContainerState extends State<_RootFlowContainer> {
  bool _showSplash = true;
  StreamSubscription<PushNotificationEvent>? _pushSub;
  PushNotificationEvent? _activeBanner;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _pushSub = FirebaseHybridService.instance.pushStream.listen((event) {
      if (!mounted) return;
      _bannerTimer?.cancel();
      setState(() => _activeBanner = event);
      _bannerTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _activeBanner = null);
      });
    });
  }

  @override
  void dispose() {
    _pushSub?.cancel();
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return FoodViewSplashScreen(
        onFinished: () => setState(() => _showSplash = false),
      );
    }

    final state = context.watch<FoodViewUiState>();

    return Stack(
      children: [
        // Langsung menampilkan layar utama bersih tanpa bar switcher tambahan di atas header!
        state.activeRole == AppActiveRole.user
            ? const UserMainScreen()
            : const OwnerMainScreen(),

        // Push Notification Floating Banner (muncul saat ada event notifikasi baru)
        if (_activeBanner != null)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryOrange),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(45),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.primaryOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _activeBanner!.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _activeBanner!.body,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _activeBanner = null),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Colors.white70,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
