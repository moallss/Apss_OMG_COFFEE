import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/stok_kritis_controller.dart';

class StokKritisView extends GetView<StokKritisController> {
  const StokKritisView({super.key});

  static const Color _red = Color(0xFFD32F2F);
  static const Color _orange = Color(0xFFFFB800);
  static const Color _amberText = Color(0xFFD97706);
  static const Color _brown = Color(0xFF8B4513);
  static const Color _green = Color(0xFF2D7A4F);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ============================================
            // HEADER PINK + DOTS + STICKER PENTING
            // ============================================
            Container(
              color: AppColors.primary,
              height: topPad + 90, // ✅ fix tinggi = sama dengan notifikasi
              padding: EdgeInsets.only(top: topPad, left: 16, right: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ✅ Teks CENTER absolut (tidak terpengaruh back button)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Stok Kritis',
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                shadows: const [
                                  Shadow(
                                      color: AppColors.ink,
                                      offset: Offset(2, 2))
                                ])),
                        const SizedBox(height: 4),
                        Text('Gabungan Bahan Baku & Barang Operasional',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  // ✅ Back di kiri (center vertikal)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (Get.previousRoute.isEmpty) {
                          Get.offAllNamed(Routes.ownerDashboard);
                        } else {
                          Get.back();
                        }
                      },
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          shape: BoxShape.circle,
                          border: appBorder(),
                          boxShadow: AppShadows.hard(2),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.ink, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ============================================
                  // 3 CARD STATISTIK
                  // ============================================
                  Row(
                    children: [
                      Expanded(
                          child: _statCard(
                              '${controller.habisTotal}',
                              'HABIS TOTAL',
                              _red,
                              Colors.white,
                              Colors.white.withOpacity(0.85))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _statCard('${controller.hampirHabis}',
                              'HAMPIR HABIS', _orange, AppColors.ink,
                              AppColors.ink.withOpacity(0.7))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _statCard('${controller.dipantau}',
                              'ITEM DIPANTAU', AppColors.appWhite,
                              AppColors.ink, AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ============================================
                  // SEGMENTED KATEGORI
                  // ============================================
                  Obx(() => Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(50),
                          border: appBorder(),
                          boxShadow: AppShadows.hard(3),
                        ),
                        child: Row(
                          children: [
                            _segment('SEMUA ITEM'),
                            _segment('BAHAN BAKU'),
                            _segment('BARANG'),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),

                  // ============================================
                  // CHIPS STATUS
                  // ============================================
                  Obx(() => Row(
                        children: [
                          _statusChip('Semua Status', null),
                          const SizedBox(width: 8),
                          _statusChip('Habis', _red),
                          const SizedBox(width: 8),
                          _statusChip('Hampir Habis', _orange),
                        ],
                      )),
                  const SizedBox(height: 20),

                  // ============================================
                  // LIST CARD STOK
                  // ============================================
                  Obx(() => Column(
                        children: controller.filtered
                            .map((s) => _stockCard(s))
                            .toList(),
                      )),
                  const SizedBox(height: 16),

                  // ============================================
                  // BANNER INFO HIJAU
                  // ============================================
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3EFE6),
                      borderRadius: BorderRadius.circular(14),
                      border: appBorder(),
                      boxShadow: AppShadows.hard(2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: _green,
                            borderRadius: BorderRadius.circular(10),
                            border: appBorder(1.5),
                          ),
                          child: const Icon(Icons.sync_alt_rounded,
                              color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Restock membuka Master Data terkait',
                                  style: GoogleFonts.inter(
                                      color: AppColors.ink,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 3),
                              Text(
                                  'Bahan menuju card Bahan Baku, barang menuju Barang Operasional. Notifikasi otomatis aktif untuk kondisi kritis (Habis & Hampir Habis).',
                                  style: GoogleFonts.inter(
                                      color: AppColors.muted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
  // CARD STATISTIK
  // ==========================================
  Widget _statCard(
      String value, String label, Color bg, Color fg, Color labelColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.outfit(
                  color: fg, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: labelColor,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8)),
        ],
      ),
    );
  }

  // ==========================================
  // SEGMENTED KATEGORI
  // ==========================================
  Widget _segment(String label) {
    final active = controller.filterKategori.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.pilihKategori(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: active ? AppColors.ink : Colors.transparent,
                width: 1.5),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : AppColors.ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // CHIP STATUS
  // ==========================================
  Widget _statusChip(String label, Color? dot) {
    final active = controller.filterStatus.value == label;
    return GestureDetector(
      onTap: () => controller.pilihStatus(label),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.appWhite,
          borderRadius: BorderRadius.circular(50),
          border: appBorder(1.5),
          boxShadow: active ? AppShadows.hard(2) : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot != null) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                    color: dot,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.ink, width: 1)),
              ),
              const SizedBox(width: 6),
            ],
            Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : AppColors.ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CARD STOK (tab kategori + sticker status)
  // ==========================================
  Widget _stockCard(Map s) {
    final isHabis = s['status'] == 'HABIS';
    final isBahan = s['kategori'] == 'BAHAN';
    final tabColor = isBahan ? _brown : AppColors.primary;

    IconData icon;
    switch (s['icon']) {
      case 'coffee':
        icon = Icons.coffee_rounded;
        break;
      case 'inventory':
        icon = Icons.inventory_2_rounded;
        break;
      case 'cup':
        icon = Icons.local_drink_rounded;
        break;
      default:
        icon = Icons.water_drop_rounded;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: s['warna'] as Color,
                        borderRadius: BorderRadius.circular(12),
                        border: appBorder(1.5),
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['nama'] as String,
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(s['subtitle'] as String,
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    // ✅ Sticker status miring + dashed inner
                    Transform.rotate(
                      angle: -0.04,
                      child: CustomPaint(
                        foregroundPainter: _DashedRRectPainter(
                            isHabis
                                ? Colors.white.withOpacity(0.9)
                                : AppColors.ink.withOpacity(0.7),
                            6,
                            3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isHabis ? _red : _orange,
                            borderRadius: BorderRadius.circular(8),
                            border: appBorder(1.5),
                            boxShadow: AppShadows.hard(2),
                          ),
                          child: Text(s['status'] as String,
                              style: GoogleFonts.inter(
                                  color: isHabis ? Colors.white : AppColors.ink,
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _DashedLine(),
                const SizedBox(height: 10),
                // ✅ 3 kolom statistik + divider vertikal putus-putus
                Row(
                  children: [
                    Expanded(
                        child: _statCol('SISA', s['sisa'] as String,
                            isHabis ? _red : _amberText)),
                    _vDash(),
                    Expanded(
                        child: _statCol('MIN', s['min'] as String,
                            AppColors.ink)),
                    _vDash(),
                    Expanded(
                        child: _statCol('CUKUP', s['cukup'] as String,
                            AppColors.ink)),
                  ],
                ),
                const SizedBox(height: 10),
                const _DashedLine(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(s['pemakaian'] as String,
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ),
                    GestureDetector(
                      onTap: () => controller.restock(s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                          border: appBorder(1.5),
                          boxShadow: AppShadows.hard(2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Restock',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right_rounded,
                                color: Colors.white, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ✅ Tab kategori DIGAMBAR DI ATAS card → tidak tenggelam
          Positioned(
            top: -7,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tabColor,
                borderRadius: BorderRadius.circular(6),
                border: appBorder(1),
                boxShadow: AppShadows.hard(1),
              ),
              child: Text(s['kategori'] as String,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCol(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 7,
                fontWeight: FontWeight.w800,
                letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.inter(
                color: valueColor, fontSize: 11, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _vDash() => SizedBox(
        height: 34,
        width: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              4,
              (_) => Container(
                  width: 2,
                  height: 4,
                  color: AppColors.muted.withOpacity(0.4))),
        ),
      );
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

// ====================================================
// DASHED ROUNDED-RECT (inner sticker status)
// ====================================================
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double inset;

  _DashedRRectPainter(this.color, this.radius, this.inset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final rect = Rect.fromLTWH(
        inset, inset, size.width - inset * 2, size.height - inset * 2);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = distance + 4;
        canvas.drawPath(
            metric.extractPath(
                distance, end > metric.length ? metric.length : end),
            paint);
        distance = end + 4;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
