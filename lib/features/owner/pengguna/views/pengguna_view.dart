// PATH FILE: lib/features/owner/pengguna/views/pengguna_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/pengguna_controller.dart';

class PenggunaView extends GetView<PenggunaController> {
  const PenggunaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SUMMARY CARD (Karyawan vs Investor)
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: appBorder(),
                          boxShadow: AppShadows.hard(2),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _summaryItem(
                                '${controller.jumlahKaryawan.value}',
                                'KARYAWAN',
                                AppColors.primary,
                                Icons.group_rounded,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.ink.withOpacity(0.2),
                            ),
                            Expanded(
                              child: _summaryItem(
                                '${controller.jumlahInvestor.value}',
                                'INVESTOR',
                                AppColors.brandGreen,
                                Icons.bar_chart_rounded,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),

                  // LABEL PILIH PENGELOLAAN (TANPA GARIS KUNING)
                  Text('PILIH PENGELOLAAN',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),

                  // CARD ROLE: KARYAWAN (BACKGROUND PINK)
                  Obx(() => _buildRoleCard(
                        icon: Icons.engineering_rounded,
                        bgColor: const Color(0xFFFF2D7A),
                        iconBgColor: const Color(0xFFFFE1EE),
                        iconColor: const Color(0xFFEF2B7C),
                        title: 'Karyawan',
                        badge: '${controller.jumlahKaryawan.value} ORANG',
                        badgeTextColor: AppColors.primary,
                        desc:
                            'Absen selfie, akses aplikasi, jadwal & tracking lokasi',
                        footerInfo:
                            '${controller.karyawanAktif.value} aktif jualan',
                        onTap: controller.openKaryawan,
                      )),
                  const SizedBox(height: 14),

                  // CARD ROLE: INVESTOR (BACKGROUND HIJAU)
                  Obx(() => _buildRoleCard(
                        icon: Icons.payments_rounded,
                        bgColor: const Color(0xFF2D7A4F),
                        iconBgColor: const Color(0xFFE3EEE5),
                        iconColor: const Color(0xFF2D7A4F),
                        title: 'Investor',
                        badge: '${controller.jumlahInvestor.value} ORANG',
                        badgeTextColor: AppColors.brandGreen,
                        desc: 'Penanaman modal, bagi hasil & akses laporan',
                        footerInfo:
                            'Total ${controller.totalBagiHasil.value}% Bagi Hasil',
                        onTap: controller.openInvestor,
                      )),
                  const SizedBox(height: 24),

                  // FOOTER NOTE
                  Center(
                    child: Text(
                        'Karyawan menjalankan operasional • investor memantau performa bisnis',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),

                  // FOOTER
                  Center(
                    child: Text('OMG COFFEE · COFFEE KELILING',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // HEADER PINK (TANPA DOTS & BINTANG)
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    shape: BoxShape.circle,
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.ink, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Pengguna',
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  shadows: const [
                    Shadow(color: Colors.black, offset: Offset(2, 2))
                  ])),
          const SizedBox(height: 8),
          Text('Kelola hak akses karyawan & investor usaha',
              style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ==========================================
  // SUMMARY ITEM (angka + icon + label)
  // ==========================================
  Widget _summaryItem(String value, String label, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: GoogleFonts.outfit(
                    color: color, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(width: 6),
            Icon(icon, color: color, size: 16),
          ],
        ),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8)),
      ],
    );
  }

  // ==========================================
  // CARD ROLE (Karyawan / Investor)
  // ==========================================
  Widget _buildRoleCard({
    required IconData icon,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String badge,
    required Color badgeTextColor,
    required String desc,
    required String footerInfo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon lingkaran dengan background terang
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            // Konten tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul & Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: appBorder(1),
                        ),
                        child: Text(badge,
                            style: GoogleFonts.inter(
                                color: badgeTextColor,
                                fontSize: 8,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),

                  // GARIS PEMBATAS
                  Container(
                    height: 1.5,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 10),

                  // Foto Profile Orang + Status
                  Row(
                    children: [
                      // Foto Profile (3 orang)
                      Row(
                        children: [
                          _profilePhoto('https://i.pravatar.cc/150?u=karyawan1',
                              Colors.white),
                          _profilePhoto('https://i.pravatar.cc/150?u=karyawan2',
                              Colors.white),
                          _profilePhoto('https://i.pravatar.cc/150?u=karyawan3',
                              Colors.white),
                        ],
                      ),
                      const Spacer(),
                      // Status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(footerInfo,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Tombol chevron
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.ink, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Foto Profile Orang
  Widget _profilePhoto(String url, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: appBorder(1),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: bgColor,
            child: Center(
              child: Text('?',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: bgColor,
              child: Center(
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
