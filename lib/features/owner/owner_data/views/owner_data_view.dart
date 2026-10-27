// PATH FILE: lib/features/owner/owner_data/views/owner_data_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/owner_data_controller.dart';

class OwnerDataView extends GetView<OwnerDataController> {
  const OwnerDataView({super.key});

  static const Color _orange = Color(0xFFFFB800);
  static const Color _green = Color(0xFF2D7A4F);
  static const Color _brown = Color(0xFF8B4513);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildContent(),
            const SizedBox(height: 20),
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
    );
  }

  // ==========================================
  // HEADER PINK + CAROUSEL
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MASTER DATA',
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  shadows: const [
                    Shadow(color: AppColors.ink, offset: Offset(2, 2))
                  ])),
          const SizedBox(height: 4),
          Text('Kelola katalog, stok & tim',
              style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 148,
            child: PageView(
              padEnds: false,
              controller: controller.pageController,
              onPageChanged: controller.onCarouselChanged,
              children: [
                _slideShell(
                  icon: Icons.coffee_rounded,
                  accent: AppColors.primary,
                  title: 'RINGKASAN MENU',
                  bigText: '${controller.totalMenu.value} Menu Aktif',
                  smallText: 'Kopi, Non-Kopi, Snack, Makanan',
                ),
                _slideShell(
                  icon: Icons.eco_rounded,
                  accent: _green,
                  title: 'BAHAN BAKU',
                  bigText: '${controller.stokKritis.length} Bahan Kritis',
                  smallText: controller.stokKritis.join(', '),
                ),
                _slideShell(
                  icon: Icons.group_rounded,
                  accent: _green,
                  title: 'TIM ANDA',
                  bigText:
                      '${controller.jumlahKaryawan.value} Karyawan & ${controller.jumlahInvestor.value} Investor',
                  smallText:
                      '${controller.sudahCheckIn.value} karyawan sudah check-in hari ini',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final active = controller.carouselIndex.value == i;
                  return GestureDetector(
                    onTap: () => controller.goToSlide(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: AppColors.ink, width: 1),
                      ),
                    ),
                  );
                }),
              )),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE CAROUSEL (sesuai desain: tanpa chip)
  // ==========================================
  Widget _slideShell({
    required IconData icon,
    required Color accent,
    required String title,
    required String bigText,
    required String smallText,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 4, 12, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(18),
        border: appBorder(),
        boxShadow: AppShadows.hard(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(bigText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const _DashedLine(),
          const SizedBox(height: 8),
          Text(smallText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ==========================================
  // KONTEN CREAM
  // ==========================================
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            icon: Icons.local_shipping_rounded,
            iconColor: AppColors.primary,
            title: 'Distribusi',
            subtitle: 'Catat & rekap serah terima barang',
            onTap: () => Get.toNamed(Routes.distribusi),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: _buildSquareCard(
                        Icons.coffee_rounded,
                        _orange,
                        'Menu',
                        'Daftar jual & harga',
                        () => Get.toNamed(Routes.menu))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildSquareCard(
                        Icons.eco_rounded,
                        _green,
                        'Bahan Baku',
                        'Kopi, susu, gula, dll.',
                        () => Get.toNamed(Routes.bahanBaku))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: _buildSquareCard(
                        Icons.receipt_long_rounded,
                        AppColors.primary,
                        'Resep Menu',
                        'Standar takaran menu',
                        () => Get.toNamed(Routes.resepMenu))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildSquareCard(
                        Icons.inventory_2_rounded,
                        _orange,
                        'Barang Operasional',
                        'Cup, sedotan, tisu, dll.',
                        () => Get.toNamed(Routes.tambahBarang))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.airport_shuttle_rounded,
            iconColor: _brown,
            title: 'Rombong',
            subtitle: 'Armada, rute & titik jualan',
            onTap: () => AppDialogs.showCustomSnackbar(
              title: 'Segera Hadir',
              message: 'Halaman Rombong sedang dalam pengembangan.',
              type: SnackbarType.info,
            ),
          ),
          const SizedBox(height: 12),
          _buildCard(
            icon: Icons.group_rounded,
            iconColor: _green,
            title: 'Pengguna',
            subtitle: '4 karyawan & 2 investor',
            onTap: () => Get.toNamed(Routes.pengguna),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD LEBAR (circle icon solid + circle chevron)
  // ==========================================
  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () => AppDialogs.showCustomSnackbar(
                title: 'Segera Hadir',
                message: 'Halaman $title sedang dalam pengembangan.',
                type: SnackbarType.info,
              ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(3),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                shape: BoxShape.circle,
                border: appBorder(1.5),
                boxShadow: AppShadows.hard(2),
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.ink, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CARD GRID 2x2
  // ==========================================
  Widget _buildSquareCard(IconData icon, Color iconColor, String title,
      String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    border: appBorder(1.5),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.ink, size: 14),
              ],
            ),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// DIVIDER PUTUS-PUTUS
// ====================================================
class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 2,
      child: CustomPaint(
        painter: _DashedLinePainter(AppColors.muted.withOpacity(0.4)),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    double x = 0;
    while (x < size.width) {
      final end = (x + 6) > size.width ? size.width : (x + 6);
      canvas.drawLine(
          Offset(x, size.height / 2), Offset(end, size.height / 2), paint);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
