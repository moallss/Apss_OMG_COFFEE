// PATH FILE: lib/features/owner/owner_dashboard/views/owner_dashboard_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/owner_dashboard_controller.dart';

class OwnerDashboardView extends GetView<OwnerDashboardController> {
  const OwnerDashboardView({super.key});

  static const Color _orange = Color(0xFFFFB800);
  static const Color _green = Color(0xFF2D7A4F);
  static const Color _redSolid = Color(0xFFD32F2F);
  static const Color _brown = Color(0xFF8B4513);

  static const Map<String, Color> _katBg = {
    'Bahan Pokok': _brown,
    'Dairy': _orange,
    'Sirup': Color(0xFFB45309),
  };

  static const List<Color> _avatarPalette = [
    _orange,
    AppColors.primary,
    _green,
    _brown,
  ];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // ============================================
          // 1. HEADER PINK FIXED
          // ============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + 130,
            child: Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: topPad + 18, // ✅ Jarak dari status bar
                  bottom: 60 // ✅ Jarak ke card omzet (seimbang)
                  ),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment
                          .center, // ✅ Teks block center vertikal
                      children: [
                        Obx(() => Text(
                              controller.greeting.value.toUpperCase(),
                              style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  height: 1.1),
                            )),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                              controller.userName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  shadows: const [
                                    Shadow(
                                        color: AppColors.ink,
                                        offset: Offset(2, 2))
                                  ]),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.notifikasi),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            shape: BoxShape.circle,
                            border: appBorder(),
                            boxShadow: AppShadows.hard(2),
                          ),
                          child: const Icon(Icons.notifications_rounded,
                              color: AppColors.ink, size: 18),
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
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

          // ============================================
          // 2. CONTENT: omzet + quick FIXED,
          //    scroll region DITUTUP quick buttons di atas
          // ============================================
          Positioned(
            top: topPad + 78,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // --- Zona FIXED (tidak ikut scroll) ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Obx(() => controller.isLoadingOmzet.value
                          ? _omzetSkeleton()
                          : _omzetCard()),
                      const SizedBox(height: 18),
                      _quickActions(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- Zona SCROLL (stok + karyawan) ---
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _noScrollbar(
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionTitle(
                              'Stok Kritis',
                              right: GestureDetector(
                                onTap: () => Get.toNamed(Routes.stokKritis),
                                child: Text('LIHAT SEMUA',
                                    style: GoogleFonts.inter(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _stokSection(),
                            const SizedBox(height: 22),
                            _sectionTitle(
                              'Status Karyawan',
                              right: GestureDetector(
                                onTap: () => Get.toNamed(Routes.pengguna),
                                child: Text('LIHAT SEMUA',
                                    style: GoogleFonts.inter(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _karyawanSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Matikan scrollbar (khusus web) tanpa mematikan gesture scroll
  Widget _noScrollbar(Widget child) => ScrollConfiguration(
        behavior:
            ScrollConfiguration.of(Get.context!).copyWith(scrollbars: false),
        child: child,
      );

  // ==========================================
  // PILL SEDERHANA
  // ==========================================
  Widget _simplePill(String text, Color color, {bool withDot = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (withDot) ...[
            Container(
                width: 5,
                height: 5,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          Text(text,
              style: GoogleFonts.inter(
                  color: color,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4)),
        ],
      ),
    );
  }

  // ==========================================
  // CARD OMZET
  // ==========================================
  Widget _omzetCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Text('OMZET HARI INI',
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
              const Spacer(),
              _simplePill('LIVE', _green, withDot: true),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Text(controller.omzetHariIni.value,
              style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                  height: 1.0))),
          const SizedBox(height: 12),
          const _DashedLine(),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
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
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Obx(() => Text(controller.estimasiLaba.value,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(() =>
                      _simplePill(controller.persentaseKenaikan.value, _green)),
                  const SizedBox(height: 4),
                  Obx(() => Text('${controller.totalTransaksi.value} Transaksi',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.ink.withOpacity(0.12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PENGELUARAN HARI INI',
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
              Obx(() => Text(controller.pengeluaranHariIni.value,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _omzetSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(18),
        border: appBorder(),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 10, color: Colors.white),
            const SizedBox(height: 10),
            Container(width: 200, height: 28, color: Colors.white),
            const SizedBox(height: 14),
            Container(width: double.infinity, height: 44, color: Colors.white),
            const SizedBox(height: 14),
            Container(width: 140, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // QUICK ACTIONS
  // ==========================================
  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
            child: _quickTile(Icons.add_rounded, 'MENU', AppColors.primary,
                Colors.white, () => Get.toNamed(Routes.menu))),
        const SizedBox(width: 10),
        Expanded(
            child: _quickTile(
                Icons.local_shipping_rounded,
                'DISTRIBUSI',
                AppColors.appWhite,
                AppColors.ink,
                () => Get.toNamed(Routes.distribusi))),
        const SizedBox(width: 10),
        Expanded(
            child: _quickTile(Icons.account_balance_wallet_rounded, 'KEUANGAN',
                _orange, AppColors.ink, _segeraHadir)),
        const SizedBox(width: 10),
        Expanded(
            child: _quickTile(Icons.verified_user_rounded, 'AUDIT', _green,
                Colors.white, _segeraHadir)),
      ],
    );
  }

  Widget _quickTile(
      IconData icon, String label, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: appBorder(),
          boxShadow: AppShadows.hard(3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(height: 6),
            Text(label,
                style: GoogleFonts.inter(
                    color: fg,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SECTION TITLE
  // ==========================================
  Widget _sectionTitle(String title, {Widget? right}) {
    return Row(
      children: [
        Text(title,
            style: GoogleFonts.outfit(
                color: AppColors.ink,
                fontSize: 17,
                fontWeight: FontWeight.w900)),
        const Spacer(),
        if (right != null) right,
      ],
    );
  }

  // ==========================================
  // STOK KRITIS (horizontal scroll)
  // ==========================================
  Widget _stokSection() {
    return Obx(() {
      if (controller.isLoadingStok.value) {
        return SizedBox(
          height: 180,
          child: _noScrollbar(ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 6, 24, 6),
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) => Container(
              width: 186,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(16),
                border: appBorder(),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 90, height: 10, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 14, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 100, height: 10, color: Colors.white),
                    const Spacer(),
                    Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.white),
                  ],
                ),
              ),
            ),
          )),
        );
      }
      return SizedBox(
        height: 180,
        child: _noScrollbar(ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          // ✅ padding vertical 6 = ruang untuk shadow/border bawah
          // ✅ padding right 24 = shadow card terakhir tidak terpotong
          padding: const EdgeInsets.fromLTRB(0, 6, 24, 6),
          itemCount: controller.stokKritis.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => _stockCard(controller.stokKritis[i]),
        )),
      );
    });
  }

  Widget _stockCard(Map item) {
    final kategori = (item['kategori'] as String?) ?? '';
    final status = (item['status'] as String?) ?? 'Habis';
    final isHabis = status.toLowerCase() == 'habis';
    final tileBg = _katBg[kategori] ?? AppColors.muted;
    final tileFg = tileBg == _orange ? AppColors.ink : Colors.white;

    return Container(
      width: 186,
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: tileBg,
                  borderRadius: BorderRadius.circular(9),
                  border: appBorder(1.5),
                ),
                child: Icon(
                    kategori == 'Dairy'
                        ? Icons.inventory_2_rounded
                        : Icons.coffee_rounded,
                    color: tileFg,
                    size: 16),
              ),
              const Spacer(),
              Flexible(
                child: Text(kategori.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text((item['nama'] as String?) ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text((item['stok'] as String?) ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          // ✅ foregroundPainter → garis DIGAMBAR DI ATAS warna solid (terlihat)
          // ✅ Putih di kedua shape, inset 5px dari border hitam
          CustomPaint(
            foregroundPainter:
                _DashedRRectPainter(Colors.white.withOpacity(0.95), 6.5, 6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isHabis ? _redSolid : _orange,
                borderRadius: BorderRadius.circular(10),
                border: appBorder(1.5),
              ),
              child: Center(
                child: Text(status.toUpperCase(),
                    style: GoogleFonts.inter(
                        color: isHabis ? Colors.white : AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STATUS KARYAWAN (dirender penuh — ikut scroll halaman)
  // ==========================================
  Widget _karyawanSection() {
    return Obx(() {
      if (controller.isLoadingKaryawan.value) {
        return Column(
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: appBorder(),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Row(
                    children: [
                      Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Container(height: 30, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final all = controller.karyawanList;
      final list = all.take(10).toList(); // ✅ batas 10 card

      return Column(
        children: [
          ...List.generate(
            list.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _employeeCard(list[i], i),
            ),
          ),
          if (all.length > 10)
            GestureDetector(
              onTap: () => Get.toNamed(Routes.pengguna),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: appBorder(1.5),
                ),
                child: Center(
                  child: Text('Lihat ${all.length - 10} karyawan lainnya →',
                      style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _employeeCard(Map item, int index) {
    final status = (item['status'] as String?) ?? '';
    final isCheckIn = status.toLowerCase().contains('sudah');
    final statusColor = isCheckIn ? _green : _orange;
    final avatarColor = _avatarPalette[index % _avatarPalette.length];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Row(
        children: [
          _brutalAvatar(
              item['fotoUrl'] as String?, (item['nama'] ?? 'U').toString(), 22,
              bgColor: avatarColor, textColor: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((item['nama'] ?? '').toString(),
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text((item['info'] ?? '').toString(),
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _simplePill(status.toUpperCase(), statusColor),
        ],
      ),
    );
  }

  // ==========================================
  // AVATAR BRUTAL
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
      decoration:
          BoxDecoration(color: bg, shape: BoxShape.circle, border: appBorder()),
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

  void _segeraHadir() => AppDialogs.showCustomSnackbar(
        title: 'Segera Hadir',
        message: 'Halaman ini sedang dalam pengembangan.',
        type: SnackbarType.info,
      );
}

// ====================================================
// DIVIDER PUTUS-PUTUS HORIZONTAL
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
// DASHED ROUNDED-RECT (inner border tombol status)
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
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    final rect = Rect.fromLTWH(
        inset, inset, size.width - inset * 2, size.height - inset * 2);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = distance + 5;
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
