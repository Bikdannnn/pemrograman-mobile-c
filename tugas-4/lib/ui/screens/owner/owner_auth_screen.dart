import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../components/components.dart';
import '../../view_models/foodview_ui_state.dart';
import '../user/user_auth_screen.dart';

/// Layar Autentikasi PEMILIK RESTORAN (`Masuk` & `Buat Akun`) sesuai 6 frame Auth pada `PEMILIK RESTORAN.svg`:
/// - Pada `Masuk`: Header oranye `#F0A04B` dengan ilustrasi toko/barista (`owner_auth_header.png`),
///   input `Email` (`buatikwar@gmail.com`) & `Kata Sandi`, tombol `Masuk` / `Buat Akun`,
///   dan link bawah `"Masuk sebagai Pengguna"`.
/// - Pada `Buat Akun`: Header oranye compact `"Buat Akun"`, 7 field lengkap:
///   1. `Nama lengkap` (`Atik Rosdalinah`)
///   2. `Email` (`buatikwar@gmail.com`)
///   3. `No. HP` (`081234152673`)
///   4. `Kata Sandi`
///   5. `Nama rumah makan/restoran/usaha` (`Warung Bu Atik`)
///   6. `Alamat rumah makan/restoran/usaha` (`Jl. Samata, Borong Indah, Makassar`)
///   7. `Surat legalitas` (`+ Tambah file` -> `"surat-legalitas-wrg-bu-atik.jpg"` + `"Ubah"`)
class OwnerAuthScreen extends StatefulWidget {
  final bool initialIsRegister;

  const OwnerAuthScreen({
    super.key,
    this.initialIsRegister = false,
  });

  @override
  State<OwnerAuthScreen> createState() => _OwnerAuthScreenState();
}

class _OwnerAuthScreenState extends State<OwnerAuthScreen> {
  late bool _isRegister;
  bool _showValidationErrors = false;
  String? _legalFileName;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _restoNameController = TextEditingController();
  final TextEditingController _restoAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isRegister = widget.initialIsRegister;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _restoNameController.dispose();
    _restoAddressController.dispose();
    super.dispose();
  }

  bool get _isFormFilled {
    if (_isRegister) {
      return _fullNameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _phoneController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _restoNameController.text.trim().isNotEmpty &&
          _restoAddressController.text.trim().isNotEmpty &&
          _legalFileName != null;
    }
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;
  }

  void _fillDemoOwner() {
    setState(() {
      _showValidationErrors = false;
      if (_isRegister) {
        _fullNameController.text = 'Atik Rosdalinah';
        _emailController.text = 'buatikwar@gmail.com';
        _phoneController.text = '081234152673';
        _passwordController.text = '12345678';
        _restoNameController.text = 'Warung Bu Atik';
        _restoAddressController.text = 'Jl. Samata, Borong Indah, Makassar';
        _legalFileName = 'surat-legalitas-wrg-bu-atik.jpg';
      } else {
        _emailController.text = 'buatikwar@gmail.com';
        _passwordController.text = '12345678';
      }
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
      state.loginOwner(
        restaurantName: _restoNameController.text,
        address: _restoAddressController.text,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      state.loginOwner();
      Navigator.of(context).popUntil((route) => route.isFirst);
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
              // Header Oranye (Ilustrasi penuh saat Masuk, Header compact saat Buat Akun persis PEMILIK RESTORAN.svg)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(_isRegister ? 0 : 14),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
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
                            onPressed: _fillDemoOwner,
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
                    if (!_isRegister)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                        child: Image.asset(
                          'assets/images/owner_auth_header.png',
                          height: 295,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
                ),
              ),

              // Form Input
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                child: Column(
                  children: [
                    if (_isRegister) ...[
                      FoodViewAuthInputField(
                        controller: _fullNameController,
                        hintText: 'Nama lengkap',
                        icon: Icons.person_rounded,
                        showError: _showValidationErrors &&
                            _fullNameController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      FoodViewAuthInputField(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        showError: _showValidationErrors &&
                            _emailController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      FoodViewAuthInputField(
                        controller: _phoneController,
                        hintText: 'No. HP',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        showError: _showValidationErrors &&
                            _phoneController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      FoodViewAuthInputField(
                        controller: _passwordController,
                        hintText: 'Kata Sandi',
                        icon: Icons.lock_rounded,
                        obscureText: true,
                        showError: _showValidationErrors &&
                            _passwordController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      FoodViewAuthInputField(
                        controller: _restoNameController,
                        hintText: 'Nama rumah makan/restoran/usaha',
                        icon: Icons.restaurant_rounded,
                        showError: _showValidationErrors &&
                            _restoNameController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),
                      FoodViewAuthInputField(
                        controller: _restoAddressController,
                        hintText: 'Alamat rumah makan/restoran/usaha',
                        icon: Icons.location_on_rounded,
                        showError: _showValidationErrors &&
                            _restoAddressController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),

                      // Box Surat Legalitas (persis PEMILIK RESTORAN.svg)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.borderGray,
                            width: 0.9,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.insert_drive_file_rounded,
                                  size: 17,
                                  color: AppColors.primaryGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _showValidationErrors &&
                                          _legalFileName == null
                                      ? '*wajib diisi'
                                      : 'Surat legalitas',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: _showValidationErrors &&
                                            _legalFileName == null
                                        ? AppColors.errorRed
                                        : AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: _legalFileName == null
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            _legalFileName =
                                                'surat-legalitas-wrg-bu-atik.jpg';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFB5B5B5),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            '+ Tambah file',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _legalFileName!,
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _legalFileName = null;
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFB5B5B5),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                '↻ Ubah',
                                                style: TextStyle(
                                                  fontSize: 9.5,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
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
                    ],

                    const SizedBox(height: 18),

                    // Tombol Utama
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

                    FoodViewSecondaryButton(
                      text: _isRegister ? 'Masuk' : 'Buat Akun',
                      onPressed: () {
                        setState(() {
                          _isRegister = !_isRegister;
                          _showValidationErrors = false;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => UserAuthScreen(
                              initialIsRegister: _isRegister,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        _isRegister
                            ? 'Daftar sebagai Pengguna'
                            : 'Masuk sebagai Pengguna',
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
