import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ringkasan_pesanan_controller.dart';

import '../../mode_pembayaran/views/mode_pembayaran_view.dart';
import '../../mode_pembayaran/controllers/mode_pembayaran_controller.dart';

// ====================================================
// 1. BOTTOM SHEET RINGKASAN PEMESANAN (Draggable & Smooth)
// ====================================================
class RingkasanPesananView extends GetView<RingkasanPesananController> {
  const RingkasanPesananView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ✅ Simpan perubahan saat sheet ditutup jalur manapun (back Android, swipe, blur, dll)
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) controller.commitToPos();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset:
            false, // ✅ Tidak ikut naik saat keyboard pembayaran muncul
        body: Stack(
          children: [
            // LAYER 1: BLUR + GELAP (POS tetap terlihat di belakang)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  controller.commitToPos();
                  Get.back();
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withValues(alpha: 0.35)),
                ),
              ),
            ),

            // LAYER 2: SHEET DRAGGABLE
            _DraggableSheet(controller: controller),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// SPACER KEYBOARD (Isolasi rebuild - super ringan)
// ====================================================
class _KeyboardSpacer extends StatelessWidget {
  const _KeyboardSpacer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.viewInsetsOf(context).bottom);
  }
}

// ============================================
// WIDGET SHEET DRAGGABLE (Animasi Halus)
// ============================================
class _DraggableSheet extends StatefulWidget {
  final RingkasanPesananController controller;
  const _DraggableSheet({required this.controller});

  @override
  State<_DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<_DraggableSheet>
    with SingleTickerProviderStateMixin {
  // ValueNotifier: hanya Transform yang di-update, bukan seluruh sheet
  final ValueNotifier<double> _offset = ValueNotifier(0);
  bool _isAnimating = false;
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    // ✅ Muat data cart TERBARU setiap sheet dibuka
    widget.controller.resync();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _anim = Tween<double>(begin: 0, end: 0).animate(_animController);
    _animController.addListener(() {
      _offset.value = _anim.value; // Tanpa setState → ringan & halus
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _offset.dispose();
    super.dispose();
  }

  double get _sheetHeight => MediaQuery.of(context).size.height * 0.7;

  // Jari bergerak → sheet mengikuti jari
  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    double next = _offset.value + details.delta.dy;
    if (next < 0) next = 0;
    if (next > _sheetHeight) next = _sheetHeight;
    _offset.value = next;
  }

  // Jari dilepas → animasi halus
  void _onDragEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final velocity = details.primaryVelocity ?? 0;
    final shouldClose = _offset.value > _sheetHeight * 0.25 || velocity > 500;

    _isAnimating = true;
    _anim = Tween<double>(
      begin: _offset.value,
      end: shouldClose ? _sheetHeight : 0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.value = 0;
    _animController.animateTo(1).then((_) {
      _isAnimating = false;
      if (shouldClose && mounted) Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<double>(
        valueListenable: _offset,
        builder: (context, offset, child) {
          // HANYA Transform yang di-update setiap frame (ringan!)
          return Transform.translate(
            offset: Offset(0, offset),
            child: child,
          );
        },
        // ISI SHEET DI-CACHE (tidak di-build ulang saat drag)
        child: Container(
          height: _sheetHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFFAF9F6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              // AREA DRAG (handle + judul)
              GestureDetector(
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDragEnd,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Ringkasan Pemesanan',
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[300]),

              // LIST ITEM
              Expanded(
                child: Obx(() {
                  if (widget.controller.cartItems.isEmpty) {
                    return Center(
                      child: Text('Keranjang masih kosong',
                          style: GoogleFonts.inter(
                              color: Colors.grey[500], fontSize: 13)),
                    );
                  }
                  return ListView.separated(
                    itemCount: widget.controller.cartItems.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      // ✅ KUNCI UTAMA: Bungkus HANYA itemnya dengan Obx!
                      // Saat qty berubah, HANYA baris ini yang di-rebuild, baris lain TIDAK.
                      return Obx(() => _buildItem(
                          widget.controller.cartItems[index], index));
                    },
                  );
                }),
              ),

              // CATATAN PELANGGAN
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catatan Pelanggan (Opsional)',
                        style: GoogleFonts.inter(
                            color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: widget.controller.catatanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Contoh : 1 Less sugar',
                        hintStyle: GoogleFonts.inter(
                            color: Colors.grey[400], fontSize: 12),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFFD6336C), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFFD6336C), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFFFF3E9B), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey[300]),

              // TOTAL + TOMBOL
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    Obx(() => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pajak (${widget.controller.taxPercent}%)',
                                  style: GoogleFonts.inter(
                                      color: Colors.grey[500], fontSize: 12)),
                              Text(
                                  widget.controller.useTax.value
                                      ? widget.controller
                                          .formatRupiah(widget.controller.tax)
                                      : '-',
                                  style: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Obx(() => Text(
                            widget.controller
                                .formatRupiah(widget.controller.grandTotal),
                            style: GoogleFonts.outfit(
                                color: const Color(0xFF3A6F43),
                                fontSize: 17,
                                fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                widget.controller.batalkanPesanan(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFF8F0),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Color(0xFFD6336C), width: 1.5),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text('Batalkan',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFFD6336C),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Inisialisasi controller pembayaran
                              if (!Get.isRegistered<
                                  ModePembayaranController>()) {
                                Get.put(ModePembayaranController());
                              }

                              // Buka sheet pembayaran di atas ringkasan
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  transitionDuration:
                                      const Duration(milliseconds: 350),
                                  pageBuilder: (_, __, ___) =>
                                      const ModePembayaranView(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    if (animation.status ==
                                        AnimationStatus.reverse) {
                                      return FadeTransition(
                                          opacity: animation, child: child);
                                    }
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 1),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      )),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF3E9B),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text('Lanjutkan',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Flexible(
                child: _KeyboardSpacer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ITEM PESANAN COMPACT
  // ==========================================
  Widget _buildItem(Map<String, dynamic> item, int idx) {
    // ✅ Index langsung dari ListView
    final qty = item['quantity'] as int;
    final harga = item['harga'] as int;
    // HAPUS: final idx = widget.controller.posController.cart.indexWhere(...)

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => widget.controller.removeItem(idx),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFFF3E9B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_rounded,
                  color: Colors.white, size: 14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['nama'] ?? '',
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: 'Harga per 1 : ',
                    style: GoogleFonts.inter(
                        color: Colors.grey[500], fontSize: 10),
                    children: [
                      TextSpan(
                        text: widget.controller.formatRupiah(harga),
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.controller.formatRupiah(harga * qty),
                  style: GoogleFonts.outfit(
                      color: const Color(0xFF3A6F43),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              _buildQtyCapsule(qty, idx),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BUTTON QTY KAPSUL
  // ==========================================
  Widget _buildQtyCapsule(int qty, int idx) {
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        border: Border.all(color: const Color(0xFFD6336C), width: 1.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.controller.decreaseItem(idx),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3E9B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: const Center(
                  child:
                      Icon(Icons.remove_rounded, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
          Container(width: 1.5, color: const Color(0xFFD6336C)),
          Expanded(
            child: Center(
              child: Text('$qty',
                  style: GoogleFonts.inter(
                      color: const Color(0xFFD6336C),
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Container(width: 1.5, color: const Color(0xFFD6336C)),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.controller.increaseItem(idx),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3E9B),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.add_rounded, color: Colors.white, size: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
