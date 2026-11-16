import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import '../owner/owner_auth_screen.dart';

/// Layar Autentikasi USER (`Masuk` & `Buat Akun`) sesuai 6 frame Auth pada `USER.svg`:
/// - Header oranye `#F0A04B` dengan ilustrasi chef memasak (`user_auth_header.png`)
/// - Mendukung 3 state persis Figma:
///   1. State kosong (tombol utama abu-abu `#E0E0E0`)
///   2. State validasi error (`*wajib diisi` berwarna merah `#FF0606`)
///   3. State terisi (`jason271@gmail.com` -> tombol utama berubah menjadi oranye `#F0A04B`)
/// - Link bawah: `"Masuk sebagai Pemilik Usaha"` / `"Daftar sebagai Pemilik Usaha"`
class UserAuthScreen extends StatefulWidget {
  final bool initialIsRegister;

  const UserAuthScreen({
    super.key,
    this.initialIsRegister = false,
  });

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  late bool _isRegister;
  bool _showValidationErrors = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isRegister = widget.initialIsRegister;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormFilled {
    if (_isRegister) {
      return _nameController.text.trim().isNotEmpty &&
          _usernameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    }
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  void _fillDemoUser() {
    setState(() {
      _showValidationErrors = false;
      if (_isRegister) {
        _nameController.text = 'Jason';
        _usernameController.text = 'JasonUvUWW';
      }
      _emailController.text = 'jason271@gmail.com';
      _passwordController.text = '12345678';
    });
  }

  Future<void> _submit() async {
    if (!_isFormFilled) {
      setState(() => _showValidationErrors = true);
      return;
    }

    final state = context.read<FoodViewUiState>();
    if (_isRegister) {
      await FoodViewDialogs.showStatusPopup(
        context,
        message: 'Akun anda\nberhasil dibuat!',
      );
      if (!mounted) return;
      state.loginUser(
        email: _emailController.text,
        name: _nameController.text,
        username: _usernameController.text,
      );
      Navigator.of(context).pop();
    } else {
      state.loginUser(email: _emailController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Oranye dengan Ilustrasi Chef (persis USER.svg)
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _isRegister ? 'Buat Akun' : 'Masuk',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _fillDemoUser,
                            child: const Text(
                              'Isi Demo',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14),
                      ),
                      child: Image.asset(
                        'assets/images/user_auth_header.png',
                        height: _isRegister ? 235 : 290,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Input
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                child: Column(
                  children: [
                    if (_isRegister) ...[
                      FoodViewAuthInputField(
                        controller: _nameController,
                        hintText: 'Nama',
                        icon: Icons.person_rounded,
                        showError: _showValidationErrors &&
                            _nameController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      FoodViewAuthInputField(
                        controller: _usernameController,
                        hintText: 'Nama Pengguna',
                        icon: Icons.person_outline_rounded,
                        showError: _showValidationErrors &&
                            _usernameController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                    ],
                    FoodViewAuthInputField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      showError: _showValidationErrors &&
                          _emailController.text.trim().isEmpty,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    FoodViewAuthInputField(
                      controller: _passwordController,
                      hintText: 'Kata Sandi',
                      icon: Icons.lock_rounded,
                      obscureText: true,
                      showError: _showValidationErrors &&
                          _passwordController.text.trim().isEmpty,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Utama (Abu-abu saat kosong, Oranye saat terisi; tetap bisa diketuk untuk memicu state *wajib diisi!)
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormFilled
                              ? AppColors.primaryOrange
                              : AppColors.disabledButtonGray,
                          foregroundColor:
                              _isFormFilled ? Colors.white : AppColors.textDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _isRegister ? 'Buat Akun' : 'Masuk',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tombol Sekunder (berpindah antara Masuk & Buat Akun)
                    FoodViewSecondaryButton(
                      text: _isRegister ? 'Masuk' : 'Buat Akun',
                      onPressed: () {
                        setState(() {
                          _isRegister = !_isRegister;
                          _showValidationErrors = false;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    // Link berpindah ke Role Pemilik Restoran
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => OwnerAuthScreen(
                              initialIsRegister: _isRegister,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        _isRegister
                            ? 'Daftar sebagai Pemilik Usaha'
                            : 'Masuk sebagai Pemilik Usaha',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.primaryOrange,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Komponen TextField ber-border dengan ikon kiri & state error `*wajib diisi`
/// yang digunakan bersama oleh `UserAuthScreen`, `OwnerAuthScreen`, dan `Tambah/Edit Menu`.
class FoodViewAuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool showError;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const FoodViewAuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.showError = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.borderGray,
          width: 0.9,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: showError ? '*wajib diisi' : hintText,
                hintStyle: TextStyle(
                  fontSize: 11.5,
                  color: showError ? AppColors.errorRed : AppColors.textGray,
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
        ],
      ),
    );
  }
}
