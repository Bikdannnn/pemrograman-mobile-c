import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Layar Splash Screen 3 Tahap sesuai 3 frame krem (`#FEFBE9`) pada `USER.svg` & `PEMILIK RESTORAN.svg`:
/// - Tahap 1: Latar krem polos `#FEFBE9`
/// - Tahap 2: Muncul ilustrasi burger/hotdog melayang (`splash_illustration.png`)
/// - Tahap 3: Muncul ilustrasi lengkap + teks logo `"FoodView"` (`splash_logo.png`)
class FoodViewSplashScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const FoodViewSplashScreen({
    super.key,
    required this.onFinished,
  });

  @override
  State<FoodViewSplashScreen> createState() => _FoodViewSplashScreenState();
}

class _FoodViewSplashScreenState extends State<FoodViewSplashScreen> {
  int _stage = 0;
  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;

  @override
  void initState() {
    super.initState();
    _timer1 = Timer(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _stage = 1);
    });
    _timer2 = Timer(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() => _stage = 2);
    });
    _timer3 = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashCream,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onFinished,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: switch (_stage) {
              0 => const SizedBox.shrink(key: ValueKey('stage0')),
              1 => Image.asset(
                  'assets/images/splash_illustration.png',
                  key: const ValueKey('stage1'),
                  width: 240,
                  fit: BoxFit.contain,
                ),
              _ => Image.asset(
                  'assets/images/splash_logo.png',
                  key: const ValueKey('stage2'),
                  width: 240,
                  fit: BoxFit.contain,
                ),
            },
          ),
        ),
      ),
    );
  }
}
