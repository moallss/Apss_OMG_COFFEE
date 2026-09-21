// PATH FILE: lib/features/owner/owner_dashboard/views/owner_dashboard_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/owner_dashboard_controller.dart';

class OwnerDashboardView extends GetView<OwnerDashboardController> {
  const OwnerDashboardView({super.key});

  static const Color _orange = Color(0xFFFFB800);
  static const Color _green = Color(0xFF2D7A4F);
  static const Color _yellowTile = Color(0xFFFFD400);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // ruang navbar floating
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ============================================
            // 1. HEADER PINK SEPARUH + CARD OMZET STRADDLE
            //    (setengah di pink, setengah di cream — sesuai desain)
            // ============================================
            Stack(
              clipBehavior: Clip.none,
              children: [
                // --- Blok pink: hanya baris avatar + bell ---
                Container(
                  height: topPad + 126, // pink hanya sampai ±20% atas card
                  color: AppColors.primary,
                  child: Stack(
                    children: [
                      // ✅ DOTS: full background pink (layer paling bawah)
                      const Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(painter: _DotGridPainter()),
                        ),
                      ),
                      // ✅ PROFILE + BELL: center di area pink yang terlihat
                      Positioned(
                        top: topPad, // mulai di bawah status bar
                        left: 20,
                        right: 20,
                        bottom: 40, // bagian pink yang tertutup card omzet
                        child: Center(
                          child: Row(
                            children: [
                              Obx(() => _brutalAvatar(
                                    controller.ownerPhotoUrl.value.isEmpty
                                        ? null
                                        : controller.ownerPhotoUrl.value,
                                    controller.userName.value,
                                    20,
                                    bgColor: AppColors.appWhite,
                                    textColor: AppColors.primary,
                                  )),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => Text(
                                        controller.greeting.value.toUpperCase(),
                                        style: AppTextStyles.labelUpper
                                            .copyWith(
                                                color: Colors.white70,
                                                fontSize: 9,
                                                height: 1.2))),
                                    const SizedBox(height: 2),
                                    Obx(() => Text(controller.userName.value,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 18,
                                            height: 1.1,
                                            fontWeight: FontWeight.w900,
                                            shadows: const [
                                              Shadow(
                                                  color: AppColors.ink,
                                                  offset: Offset(2, 2))
                                            ]))),
                                  ],
                                ),
                              ),
                              // ✅ Bell dalam Row yang sama → sejajar & center
                              GestureDetector(
                                onTap: () => AppDialogs.showCustomSnackbar(
                                  title: 'Notifikasi',
                                  message: 'Belum ada notifikasi baru.',
                                  type: SnackbarType.info,
                                ),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: AppColors.appWhite,
                                    shape: BoxShape.circle,
                                    border: appBorder(),
                                    boxShadow: AppShadows.hard(3),
                                  ),
                                  child: const Icon(Icons.notifications_rounded,
                                      color: AppColors.ink, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // --- Card omzet: separuh pink, separuh cream ---
                Padding(
                  padding: EdgeInsets.fromLTRB(20, topPad + 86, 20, 0),
                  child: Obx(() => controller.isLoadingOmzet.value
                      ? _omzetSkeleton()
                      : _omzetCard()),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ============================================
            // 2. KONTEN CREAM
            // ============================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- QUICK MENU 4 TILE ---
                  Row(
                    children: [
                      Expanded(
                          child: _quickTile(Icons.add_rounded, 'MENU',
                              AppColors.primary, Colors.white,
                              onTap: () => Get.toNamed(Routes.menu))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _quickTile(
                              Icons.local_shipping_rounded,
                              'DISTRIBUSI',
                              AppColors.appWhite,
                              AppColors.primary,
                              onTap: () => Get.toNamed(Routes.distribusi))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _quickTile(
                              Icons.account_balance_wallet_rounded,
                              'KEUANGAN',
                              _yellowTile,
                              AppColors.ink,
                              onTap: _segeraHadir)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _quickTile(Icons.verified_user_rounded,
                              'AUDIT', _green, Colors.white,
                              onTap: _segeraHadir)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- STOK KRITIS ---
                  _sectionTitle(
                    'Stok Kritis',
                    right: GestureDetector(
                      onTap: () {},
                      child: Text('LIHAT SEMUA',
                          style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.isLoadingStok.value) {
                      return SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, __) => BrutalCard(
                            padding: const EdgeInsets.all(12),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 90,
                                      height: 12,
                                      color: Colors.white),
                                  const SizedBox(height: 8),
                                  Container(
                                      width: 120,
                                      height: 14,
                                      color: Colors.white),
                                  const Spacer(),
                                  Container(
                                      width: 70,
                                      height: 20,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.stokKritis.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            _stockCard(controller.stokKritis[i]),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // --- STATUS KARYAWAN ---
                  _sectionTitle('Status Karyawan'),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (controller.isLoadingKaryawan.value) {
                      return Column(
                        children: List.generate(
                          3,
                          (_) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: BrutalCard(
                              padding: const EdgeInsets.all(12),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Row(
                                  children: [
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Container(
                                            height: 30, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: List.generate(
                        controller.karyawanList.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _employeeCard(controller.karyawanList[i]),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _segeraHadir() => AppDialogs.showCustomSnackbar(
        title: 'Segera Hadir',
        message: 'Halaman ini sedang dalam pengembangan.',
        type: SnackbarType.info,
      );

  // ==========================================
  // CARD OMZET (brutal + divider putus-putus)
  // ==========================================
  Widget _omzetCard() {
    return BrutalCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('OMZET HARI INI',
                  style: AppTextStyles.labelUpper.copyWith(fontSize: 9)),
              _chip('LIVE', _green),
            ],
          ),
          const SizedBox(height: 6),
          Obx(() => Text(controller.omzetHariIni.value,
              style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink))),
          const SizedBox(height: 10),
          const _DashedLine(),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(),
                ),
                child: const Icon(Icons.trending_up_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimasi Laba',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                    Obx(() => Text(controller.estimasiLaba.value,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() => _chip(controller.persentaseKenaikan.value, _green)),
                  const SizedBox(height: 4),
                  Obx(() => Text('${controller.totalTransaksi.value} Transaksi',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 9))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _DashedLine(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PENGELUARAN HARI INI',
                  style: AppTextStyles.labelUpper.copyWith(fontSize: 9)),
              Obx(() => Text(controller.pengeluaranHariIni.value,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _omzetSkeleton() {
    return BrutalCard(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 12, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 180, height: 28, color: Colors.white),
            const SizedBox(height: 12),
            Container(width: double.infinity, height: 40, color: Colors.white),
            const SizedBox(height: 12),
            Container(width: 140, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // QUICK TILE
  // ==========================================
  Widget _quickTile(IconData icon, String label, Color bg, Color fg,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.inter(
                    color: fg,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // JUDUL SECTION + SQUIGGLE
  // ==========================================
  Widget _sectionTitle(String title, {Widget? right}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink)),
            if (right != null) right,
          ],
        ),
        const SizedBox(height: 2),
        const BrutalSquiggle(width: 70, height: 8),
      ],
    );
  }

  // ==========================================
  // CARD STOK KRITIS
  // ==========================================
  Widget _stockCard(Map item) {
    final status = (item['status'] as String?) ?? 'Unknown';
    final color = status == 'Habis' ? AppColors.primary : _orange;
    return Container(
      width: 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(16),
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
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: const Icon(Icons.inventory_2_rounded,
                    color: AppColors.primary, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(((item['kategori'] as String?) ?? '').toUpperCase(),
                    maxLines: 2,
                    style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 8,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text((item['nama'] as String?) ?? '',
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink)),
          const SizedBox(height: 2),
          Text((item['stok'] as String?) ?? '',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
          const Spacer(),
          _chip(status.toUpperCase(), color),
        ],
      ),
    );
  }

  // ==========================================
  // CARD STATUS KARYAWAN
  // ==========================================
  Widget _employeeCard(Map item) {
    final status = (item['status'] as String?) ?? 'Unknown';
    final isCheckIn = status.contains('Sudah');
    final color = isCheckIn ? _green : _orange;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(4),
      ),
      child: Row(
        children: [
          _brutalAvatar(
              item['fotoUrl'] as String?, (item['nama'] ?? 'U').toString(), 20,
              bgColor: color.withOpacity(0.15), textColor: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((item['nama'] ?? '').toString(),
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink)),
                const SizedBox(height: 2),
                Text((item['info'] ?? '').toString(),
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
              ],
            ),
          ),
          _chip(status.toUpperCase(), color),
        ],
      ),
    );
  }

  // ==========================================
  // CHIP STATUS (tint + border warna)
  // ==========================================
  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              color: color, fontSize: 9, fontWeight: FontWeight.w800)),
    );
  }

  // ==========================================
  // AVATAR BRUTAL (border hitam + fallback huruf)
  // ==========================================
  Widget _brutalAvatar(String? imageUrl, String name, double radius,
      {Color? bgColor, Color? textColor}) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final bg = bgColor ?? AppColors.appWhite;
    final fg = textColor ?? AppColors.primary;
    final fallback = Center(
      child: Text(letter,
          style: GoogleFonts.outfit(
              color: fg, fontWeight: FontWeight.w900, fontSize: radius * 0.9)),
    );
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: appBorder(),
      ),
      child: ClipOval(
        child: (imageUrl == null || imageUrl.isEmpty)
            ? fallback
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback,
                errorWidget: (_, __, ___) => fallback,
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
        painter: _DashedLinePainter(AppColors.muted.withOpacity(0.5)),
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

// ====================================================
// DOT GRID FULL BACKGROUND (header pink)
// ====================================================
class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  // ✅ Konstanta internal (tidak perlu parameter karena tidak pernah diubah)
  static const Color _color = Colors.white;
  static const double _spacing = 18;
  static const double _radius = 1.8;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _color.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    for (double y = _spacing / 2; y < size.height; y += _spacing) {
      for (double x = _spacing / 2; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
