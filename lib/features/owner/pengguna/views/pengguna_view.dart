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

                  // LABEL PILIH PENGELOLAAN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PILIH PENGELOLAAN',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // CARD ROLE: KARYAWAN
                  Obx(() => _buildRoleCard(
                        icon: Icons.engineering_rounded,
                        tint: const Color(0xFFFFE1EE),
                        title: 'Karyawan',
                        badge: '${controller.jumlahKaryawan.value} ORANG',
                        badgeColor: AppColors.primary,
                        desc:
                            'Absen selfie, akses aplikasi, jadwal & tracking lokasi',
                        initials: controller.karyawanInitials,
                        footerInfo:
                            '${controller.karyawanAktif.value} aktif jualan',
                        onTap: controller.openKaryawan,
                      )),
                  const SizedBox(height: 14),

                  // CARD ROLE: INVESTOR
                  Obx(() => _buildRoleCard(
                        icon: Icons.payments_rounded,
                        tint: const Color(0xFFE3EEE5),
                        title: 'Investor',
                        badge: '${controller.jumlahInvestor.value} ORANG',
                        badgeColor: AppColors.brandGreen,
                        desc: 'Penanaman modal, bagi hasil & akses laporan',
                        initials: controller.investorInitials,
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
  // HEADER PINK dengan pola dots
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 24),
      child: Stack(
        children: [
          // Pola dots seluruh header
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _HeaderDotsPainter()),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const BrutalIcon(
                    icon: Icons.star_rounded,
                    color: AppColors.yellow,
                    size: 36,
                    outlineWidth: 3.5,
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
              const SizedBox(height: 6),
              Container(
                width: 56,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Text('Kelola hak akses karyawan & investor usaha',
                  style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
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
    required Color tint,
    required String title,
    required String badge,
    required Color badgeColor,
    required String desc,
    required List<String> initials,
    required String footerInfo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon lingkaran
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: tint,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Icon(icon, color: AppColors.ink, size: 24),
            ),
            const SizedBox(width: 12),
            // Konten tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === KONTEN JUDUL & DESKRIPSI ===
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w900)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(50),
                          border: appBorder(1),
                        ),
                        child: Text(badge,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),

                  // ✅ GARIS PEMBATAS antara Judul+Deskripsi dengan Info Akun
                  Container(
                    height: 1.5,
                    width: double.infinity,
                    color: AppColors.ink.withOpacity(0.15),
                  ),
                  const SizedBox(height: 10),

                  // === KONTEN INFO AKUN + STATUS ===
                  Row(
                    children: [
                      // Info Akun (avatar initials) - di KIRI
                      Row(
                        children: initials
                            .map((i) => Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: tint,
                                    shape: BoxShape.circle,
                                    border: appBorder(1),
                                  ),
                                  child: Center(
                                    child: Text(i,
                                        style: GoogleFonts.inter(
                                            color: AppColors.ink,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                ))
                            .toList(),
                      ),
                      const Spacer(),
                      // Status - di SEBELAH KANAN info akun
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.brandGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(footerInfo,
                              style: GoogleFonts.inter(
                                  color: AppColors.brandGreen,
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
}

// ==========================================
// PAINTER POLA DOTS HEADER
// ==========================================
class _HeaderDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.25);
    const spacing = 18.0;
    for (double y = spacing; y < size.height; y += spacing) {
      for (double x = spacing; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
