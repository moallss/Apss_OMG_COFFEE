import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/notifikasi_karyawan_controller.dart'; // DEV-1: path controller

class NotifikasiKaryawanView extends GetView<NotifikasiKaryawanController> {
  // DEV-2: nama class
  const NotifikasiKaryawanView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          // ============================================
          // HEADER PINK BERSIH (tanpa bintang & dots)
          // ============================================
          Container(
            color: AppColors.primary,
            height: topPad + 90,
            padding: EdgeInsets.only(top: topPad, left: 16, right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text('Notifikasi',
                      style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          shadows: const [
                            Shadow(color: AppColors.ink, offset: Offset(2, 2))
                          ])),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (Get.previousRoute.isEmpty) {
                        Get.offAllNamed(
                            Routes.karyawanApp); // DEV-3: route back karyawan
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

          // ============================================
          // KONTEN
          // ============================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                  Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (controller.hariIni.isNotEmpty) ...[
                            _sectionHeader(
                              'HARI INI',
                              right: _countPill(
                                  '${controller.baruHariIni} BARU',
                                  const Color(0xFFFFB800),
                                  AppColors.ink),
                            ),
                            const SizedBox(height: 12),
                            ...controller.hariIni.map((n) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _swipeDelete(n),
                                )),
                          ],
                          if (controller.kemarin.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _sectionHeader(
                              'KEMARIN',
                              right: _countPill(
                                  '${controller.kemarin.length} NOTIFIKASI',
                                  AppColors.appWhite,
                                  AppColors.ink),
                            ),
                            const SizedBox(height: 12),
                            ...controller.kemarin.map((n) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _swipeDelete(n),
                                )),
                          ],
                          if (controller.hariIni.isEmpty &&
                              controller.kemarin.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.notifications_off_outlined,
                                        size: 48, color: Colors.grey[300]),
                                    const SizedBox(height: 8),
                                    Text('Tidak ada notifikasi',
                                        style: GoogleFonts.inter(
                                            color: AppColors.muted,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )),
                  const SizedBox(height: 12),
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
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOOLBAR FILTER
  // ==========================================
  Widget _buildFilterChips() {
    // DEV-4: daftar filter disesuaikan kategori karyawan (agar tiap chip berguna)
    final filters = [
      'Semua',
      'Belum Dibaca',
      'Distribusi',
      'Stok',
      'Closing',
      'Info',
      'Promo',
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: [
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(0, 6, 28, 6),
                    child: Row(
                      children: filters.map((f) {
                        final active = controller.filterAktif.value == f;
                        final isBelum = f == 'Belum Dibaca';
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => controller.pilihFilter(f),
                            child: Container(
                              height: 38,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.appWhite,
                                borderRadius: BorderRadius.circular(50),
                                border: appBorder(1.5),
                                boxShadow: active ? AppShadows.hard(2) : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!isBelum && f != 'Semua') ...[
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                          color: active
                                              ? Colors.white
                                              : AppColors.primary,
                                          shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(f,
                                      style: GoogleFonts.inter(
                                          color: active
                                              ? Colors.white
                                              : AppColors.ink,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900)),
                                  if (isBelum &&
                                      controller.belumDibacaCount > 0) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 16,
                                      height: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? Colors.white
                                            : AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                          '${controller.belumDibacaCount}',
                                          style: GoogleFonts.inter(
                                              color: active
                                                  ? AppColors.primary
                                                  : Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w900)),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 24,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.55, 1.0],
                        colors: [
                          AppColors.cream.withOpacity(0),
                          AppColors.cream.withOpacity(0.75),
                          AppColors.cream,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _iconAction(Icons.done_all_rounded, AppColors.ink,
            'Tandai semua dibaca', controller.tandaiSemuaBaca),
        const SizedBox(width: 8),
        _iconAction(Icons.delete_outline_rounded, const Color(0xFFD32F2F),
            'Hapus semua', controller.hapusSemua),
      ],
    );
  }

  Widget _iconAction(
      IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
            boxShadow: AppShadows.hard(2),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  // ==========================================
  // SECTION HEADER + PILL COUNT
  // ==========================================
  Widget _sectionHeader(String title, {Widget? right}) {
    return Row(
      children: [
        Text(title,
            style: GoogleFonts.inter(
                color: AppColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1)),
        const Spacer(),
        if (right != null) right,
      ],
    );
  }

  Widget _countPill(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
        border: appBorder(1.5),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              color: fg, fontSize: 8, fontWeight: FontWeight.w900)),
    );
  }

  Widget _swipeDelete(Map n) {
    return _SwipeDelete(
      key: ValueKey(n['id']),
      onDismiss: () => controller.hapusNotifikasi(n),
      child: _notifCard(n),
    );
  }

  // ==========================================
  // CARD NOTIFIKASI
  // ==========================================
  Widget _notifCard(Map n) {
    final unread = n['unread'] as bool;
    final butuhAksi = (n['butuhAksi'] as bool?) ?? false;
    final warna = n['warna'] as Color;
    final icon = n['icon'] as IconData;

    return GestureDetector(
      onTap: () => controller.tandaiBaca(n),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unread ? const Color(0xFFF7ECC9) : AppColors.appWhite,
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
                    color: warna,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(1.5),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(n['judul'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w900)),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: appBorder(1),
                  ),
                  child: Text(n['waktu'] as String,
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 8,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(n['deskripsi'] as String,
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const _DashedLine(),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(n['kategori'] as String,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8)),
                const Spacer(),
                if (unread && butuhAksi)
                  _statusPill(
                      'BUTUH AKSI', const Color(0xFFD32F2F), true, Colors.white)
                else if (unread)
                  _statusPill(
                      'BELUM DIBACA', AppColors.primary, true, Colors.white)
                else
                  _statusPill(
                      'DIBACA', AppColors.muted, false, AppColors.muted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusPill(String text, Color color, bool solid, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: solid ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
            color: solid ? AppColors.ink : color, width: solid ? 1.5 : 1),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              color: solid ? fg : color,
              fontSize: 8,
              fontWeight: FontWeight.w900)),
    );
  }
}

// ====================================================
// SWIPE DELETE CUSTOM
// ====================================================
class _SwipeDelete extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const _SwipeDelete({super.key, required this.child, required this.onDismiss});

  @override
  State<_SwipeDelete> createState() => _SwipeDeleteState();
}

class _SwipeDeleteState extends State<_SwipeDelete>
    with SingleTickerProviderStateMixin {
  double _dx = 0;
  bool _animating = false;
  bool _dismissing = false;
  AnimationController? _ctrl;

  static const double _maxReveal = -160;
  static const double _threshold = -80;

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  void _onDrag(DragUpdateDetails d) {
    if (_animating) return;
    setState(() {
      _dx = (_dx + (d.primaryDelta ?? 0)).clamp(_maxReveal, 0).toDouble();
    });
  }

  void _onEnd(DragEndDetails d) {
    if (_dx <= _threshold) {
      _dismissing = true;
      _animateTo(-MediaQuery.of(context).size.width - 200, widget.onDismiss);
    } else {
      _animateTo(0, null);
    }
  }

  void _animateTo(double target, VoidCallback? done) {
    _ctrl?.dispose();
    _animating = true;
    final start = _dx;
    final ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _ctrl = ctrl;
    final tween = Tween<double>(begin: start, end: target);
    ctrl.addListener(() {
      if (mounted) setState(() => _dx = tween.transform(ctrl.value));
    });
    ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        _animating = false;
        done?.call();
      }
    });
    ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Transform.translate(
            offset: Offset(_dismissing ? _dx : 0, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                height: double.infinity,
                margin: const EdgeInsets.only(top: 4, bottom: 4, right: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(16),
                  border: appBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('HAPUS',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                    const SizedBox(width: 10),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: appBorder(),
                      ),
                      child: const Icon(Icons.delete_rounded,
                          color: Color(0xFFD32F2F), size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(_dx, 0),
          child: GestureDetector(
            onHorizontalDragUpdate: _onDrag,
            onHorizontalDragEnd: _onEnd,
            child: widget.child,
          ),
        ),
      ],
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
