import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/offline_status_banner.dart';
import '../widgets/risk_banner_card.dart';
import '../widgets/action_step_card.dart';
import '../widgets/check_countdown_widget.dart';
import '../widgets/expert_contact_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedPond = 'Kolam 01 - Terpal (5.000 Ekor)';
  final List<String> _pondList = [
    'Kolam 01 - Terpal (5.000 Ekor)',
    'Kolam 02 - Terpal (4.500 Ekor)',
    'Kolam 03 - Tanah (8.000 Ekor)',
  ];

  final RiskLevel _currentRisk = RiskLevel.high;

  void _onDailyCheckPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuka Form Cek Harian Air & Ikan (1 Menit)...'),
        backgroundColor: AppColors.primaryButton,
      ),
    );
  }

  void _onExpertContactPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menghubungi Penyuluh Perikanan (Pak Budi - WhatsApp)...'),
        backgroundColor: AppColors.expertContactDark,
      ),
    );
  }

  void _onReportFalseAlarm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lapor Alarm Palsu'),
        content: const Text(
          'Apakah tingkat risiko ini tidak sesuai dengan kondisi asli di kolam? '
          'Laporan Anda akan membantu menyempurnakan aturan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Laporan alarm palsu telah dicatat.'),
                ),
              );
            },
            child: const Text('Kirim Laporan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.water_rounded, color: Colors.cyanAccent),
            const SizedBox(width: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPond,
                dropdownColor: AppColors.primaryHeader,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: AppTypography.screenHeader.copyWith(fontSize: 17),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPond = newValue;
                    });
                  }
                },
                items: _pondList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Offline Indicator Bar
          const OfflineStatusBanner(isOffline: true),

          // Scrollable Home Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Primary Risk Warning Card (Treatment 1: Warning)
                  RiskBannerCard(
                    riskLevel: _currentRisk,
                    title: 'Indikasi Amonia & Oksigen Rendah',
                    reason:
                        'Ikan menggantung di permukaan air & pakan semalam masih tersisa di dasar kolam.',
                    lastCheckTime: '05:30 WIB (Pagi)',
                    onReportFalseAlarm: _onReportFalseAlarm,
                  ),
                  const SizedBox(height: 16),

                  // 2. Main Daily Check Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _onDailyCheckPressed,
                      icon: const Icon(Icons.add_task_rounded, size: 24),
                      label: const Text('Cek Kondisi Air & Ikan Sekarang (1 Menit)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Action Step List Section (Treatment 2: Action)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tindakan Utama Saat Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.riskHighLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '3 Langkah Medis',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.riskHighText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Step 1
                  const ActionStepCard(
                    stepNumber: 1,
                    title: 'Nyalakan Aerator / Kocor Air',
                    timeLimit: 'Lakukan Sekarang (Batas: 30 Menit)',
                    description:
                        'Tambahkan suplai oksigen terlarut segera untuk mencegah kematian massal di pagi hari.',
                  ),

                  // Action Step 2
                  const ActionStepCard(
                    stepNumber: 2,
                    title: 'Tunda Pemberian Pakan',
                    timeLimit: 'Tunda s/d 09:00 WIB',
                    description:
                        'Jangan berikan pakan saat ikan stres. Pakan sisa akan memperparah racun amonia.',
                  ),

                  // Action Step 3
                  const ActionStepCard(
                    stepNumber: 3,
                    title: 'Angkat Bangkai Ikan',
                    timeLimit: 'Batas: 1 Jam',
                    description:
                        'Keluarkan bangkai ikan dari kolam untuk mencegah penularan bakteri Aeromonas.',
                  ),
                  const SizedBox(height: 16),

                  // 4. Next Scheduled Check Countdown
                  CheckCountdownWidget(
                    nextCheckTime: '09:00 WIB',
                    remainingText: '3 Jam 15 Menit Lagi',
                    onStartCheckNow: _onDailyCheckPressed,
                  ),
                  const SizedBox(height: 16),

                  // 5. Expert Escalation Button
                  ExpertContactButton(
                    expertName: 'Pak Budi (Penyuluh Perikanan)',
                    onPressed: _onExpertContactPressed,
                  ),
                  const SizedBox(height: 16),

                  // Safety & Trust Disclaimer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderOutline),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield_outlined, size: 18, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Catatan Keselamatan: LMS memberikan rekomendasi tindakan lingkungan kolam. LMS tidak pernah menyebutkan merek obat, antibiotik, atau dosis obat kimia tanpa konsultasi ahli.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
