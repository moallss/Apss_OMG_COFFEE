import 'dart:async'; // WAJIB ADA UNTUK TIMER
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ringkasan_pesanan_controller.dart';
import '../../struk/views/struk_view.dart';
import '../../struk/bindings/struk_binding.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ==========================================
// PALETTE BRUTALISME
// ==========================================
const Color _ink = Color(0xFF1A1A1A);
const Color _pink = Color(0xFFEF2B7C);
const Color _yellow = Color(0xFFFFC94D);
const Color _green = Color(0xFF2D7A4F);
const Color _white = Color(0xFFFAF9F6); // Cream Brutalisme (#FAF9F6)
const Color _red = Color(0xFFD32F2F);

Border _bdr([double w = 2]) => Border.all(color: _ink, width: w);
List<BoxShadow> _hard([double o = 2]) =>
    [BoxShadow(color: _ink, offset: Offset(o, o), blurRadius: 0)];

// ==========================================
// ENDPOINT GENERATE QRIS (Edge Function Supabase)
// ==========================================
const String _qrisGenerateUrl =
    'https://ezekfixqzkacvqdnqaiq.supabase.co/functions/v1/payments';

// ====================================================
// 1. BOTTOM SHEET RINGKASAN PEMESANAN
// ====================================================
class RingkasanPesananView extends GetView<RingkasanPesananController> {
  const RingkasanPesananView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) controller.commitToPos();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // LAYER 1: BLUR + GELAP (POS tetap terlihat samar di belakang)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  controller.commitToPos();
                  Get.back();
                },
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: const ColoredBox(
                      color: Color(
                          0x59000000), // Abu-abu gelap transparan (35% opacity)
                    ),
                  ),
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

// ============================================
// WIDGET SHEET DRAGGABLE
// ============================================
class _DraggableSheet extends StatefulWidget {
  final RingkasanPesananController controller;
  const _DraggableSheet({required this.controller});

  @override
  State<_DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<_DraggableSheet>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _offset = ValueNotifier(0);
  bool _isAnimating = false;
  late AnimationController _animController;
  late Animation<double> _anim;

  final RxString _payMethod = 'CASH'.obs;
  final RxString _qrisMode = 'STATIS'.obs;
  final RxBool _qrisGenerated = false.obs;
  final RxBool _qrisPaid = false.obs;
  final RxInt _uang = 0.obs;
  final TextEditingController _uangController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.resync();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _anim = Tween<double>(begin: 0, end: 0).animate(_animController);
    _animController.addListener(() {
      _offset.value = _anim.value;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _offset.dispose();
    _uangController.dispose();
    super.dispose();
  }

  double get _sheetHeight => MediaQuery.of(context).size.height * 0.94;

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    double next = _offset.value + details.delta.dy;
    if (next < 0) next = 0;
    if (next > _sheetHeight) next = _sheetHeight;
    _offset.value = next;
  }

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
        builder: (context, offset, child) =>
            Transform.translate(offset: Offset(0, offset), child: child),
        child: Container(
          height: _sheetHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF9F6),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border.all(color: _ink, width: 2),
          ),
          child: Column(
            children: [
              // ========== AREA DRAG + HEADER (FIXED) ==========
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
                        color: _ink.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pesanan Aktif',
                                    style: GoogleFonts.inter(
                                        color: _ink,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 2),
                                Text('Rombong 01 • Pelanggan: Andi',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey[600],
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _yellow,
                              borderRadius: BorderRadius.circular(8),
                              border: _bdr(1.5),
                              boxShadow: _hard(1),
                            ),
                            child: Text('ID: #A-017',
                                style: GoogleFonts.inter(
                                    color: _ink,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ========== DIVIDER BAWAH HEADER ==========
              Divider(height: 1, thickness: 1.5, color: _ink.withOpacity(0.15)),

              // ========== KONTEN YANG BISA DI-SCROLL ==========
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 14, 0, 16),
                  child: Column(
                    children: [
                      // LABEL SECTION
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_cart_rounded,
                                color: _pink, size: 14),
                            const SizedBox(width: 6),
                            Obx(() => Text(
                                'DAFTAR MENU PESANAN (${widget.controller.cartItems.length} VARIAN)',
                                style: GoogleFonts.inter(
                                    color: _ink,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.6))),
                            const Spacer(),
                            Obx(() {
                              final porsi = widget.controller.cartItems
                                  .fold<int>(
                                      0, (s, i) => s + (i['quantity'] as int));
                              return Text('$porsi porsi total',
                                  style: GoogleFonts.inter(
                                      color: Colors.grey[600],
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600));
                            }),
                          ],
                        ),
                      ),

                      // LIST ITEM (Column, bukan ListView)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Obx(() {
                          if (widget.controller.cartItems.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text('Keranjang masih kosong',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey[500], fontSize: 13)),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              for (int i = 0;
                                  i < widget.controller.cartItems.length;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Obx(() => _buildItem(
                                      widget.controller.cartItems[i], i)),
                                ),
                            ],
                          );
                        }),
                      ),

                      // CATATAN PELANGGAN (CARD BRUTALISME)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _white,
                            borderRadius: BorderRadius.circular(12),
                            border: _bdr(1.5),
                            boxShadow: _hard(2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('CATATAN PELANGGAN',
                                      style: GoogleFonts.inter(
                                          color: _ink,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.6)),
                                  const SizedBox(width: 6),
                                  Text('(Opsional)',
                                      style: GoogleFonts.inter(
                                          color: Colors.grey[500],
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text('Khusus Rombong',
                                      style: GoogleFonts.inter(
                                          color: _pink,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: widget.controller.catatanController,
                                maxLines: 2,
                                style: GoogleFonts.inter(
                                    color: _ink,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  hintText: 'Contoh: kurang manis, es dikit',
                                  hintStyle: GoogleFonts.inter(
                                      color: Colors.grey[400], fontSize: 10),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // METODE PEMBAYARAN
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('METODE PEMBAYARAN',
                                style: GoogleFonts.inter(
                                    color: _ink,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.6)),
                            const SizedBox(height: 8),
                            Obx(() => Row(
                                  children: [
                                    Expanded(
                                        child: _payTile(
                                            'CASH (TUNAI)',
                                            Icons.payments_rounded,
                                            'CASH',
                                            _green)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: _payTile(
                                            'QRIS',
                                            Icons.qr_code_rounded,
                                            'QRIS',
                                            _pink)),
                                  ],
                                )),
                            // ✅ PANEL QRIS (muncul hanya saat QRIS dipilih)
                            Obx(() => _payMethod.value == 'QRIS'
                                ? _buildQrisPanel()
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ),

                      // UANG DITERIMA (hanya tampil saat metode CASH)
                      Obx(() => _payMethod.value == 'CASH'
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('UANG DITERIMA',
                                          style: GoogleFonts.inter(
                                              color: _ink,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.6)),
                                      const Spacer(),
                                      Text('Nominal Bayar',
                                          style: GoogleFonts.inter(
                                              color: Colors.grey[500],
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: _bdr(1.5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.5),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            color: _yellow,
                                            child: Text('Rp',
                                                style: GoogleFonts.inter(
                                                    color: _ink,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ),
                                          Container(width: 1.5, color: _ink),
                                          Expanded(
                                            child: TextField(
                                              controller: _uangController,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (v) => _uang.value =
                                                  int.tryParse(v.replaceAll(
                                                          RegExp(r'[^0-9]'),
                                                          '')) ??
                                                      0,
                                              style: GoogleFonts.inter(
                                                  color: _ink,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                isDense: true,
                                                hintText: '0',
                                                hintStyle: GoogleFonts.inter(
                                                    color: Colors.grey[400],
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    final chips = <Map<String, dynamic>>[
                                      {
                                        'label': 'Uang Pas',
                                        'value': widget.controller.grandTotal
                                      },
                                      {'label': '20.000', 'value': 20000},
                                      {'label': '50.000', 'value': 50000},
                                      {'label': '100.000', 'value': 100000},
                                    ];
                                    return Row(
                                      children: chips.map((c) {
                                        final val = c['value'] as int;
                                        final active =
                                            _uang.value == val && val > 0;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              _uang.value = val;
                                              _uangController.text =
                                                  val.toString();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color:
                                                    active ? _yellow : _white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: _bdr(1.5),
                                              ),
                                              child: Text(c['label'] as String,
                                                  style: GoogleFonts.inter(
                                                      color: _ink,
                                                      fontSize: 8.5,
                                                      fontWeight:
                                                          FontWeight.w800)),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }),
                                ],
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ),

              // ========== DIVIDER ATAS FOOTER ==========
              Divider(height: 1, thickness: 1.5, color: _ink.withOpacity(0.15)),

              // ========== FOOTER FIXED (TIDAK DI-SCROLL) ==========
              Container(
                color: const Color(0xFFFAF9F6),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SUMMARY TOTAL + KEMBALIAN
                    Obx(() {
                      final total = widget.controller.grandTotal;
                      final kembali = _uang.value - total;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _yellow,
                                borderRadius: BorderRadius.circular(12),
                                border: _bdr(1.5),
                                boxShadow: _hard(2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Flexible(
                                      child: Text(
                                          'TOTAL (${widget.controller.cartItems.length} ITEM)',
                                          style: GoogleFonts.inter(
                                              color: _ink,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w900)),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: _bdr(1),
                                      ),
                                      child: Text(
                                          'Pajak ${widget.controller.taxPercent}%',
                                          style: GoogleFonts.inter(
                                              color: _ink,
                                              fontSize: 6.5,
                                              fontWeight: FontWeight.w800)),
                                    ),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text(widget.controller.formatRupiah(total),
                                      style: GoogleFonts.outfit(
                                          color: _ink,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 2),
                                  Text('Semua item terkonfirmasi',
                                      style: GoogleFonts.inter(
                                          color: _ink.withOpacity(0.6),
                                          fontSize: 7,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _green,
                                borderRadius: BorderRadius.circular(12),
                                border: _bdr(1.5),
                                boxShadow: _hard(2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 12),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text('KEMBALIAN KONSUMEN',
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w900)),
                                    ),
                                  ]),
                                  const SizedBox(height: 4),
                                  Text(
                                      kembali < 0
                                          ? 'Kurang ${widget.controller.formatRupiah(-kembali)}'
                                          : widget.controller
                                              .formatRupiah(kembali),
                                      style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 2),
                                  Text(
                                      _uang.value > 0
                                          ? 'Dari ${widget.controller.formatRupiah(_uang.value)}'
                                          : 'Belum ada uang masuk',
                                      style: GoogleFonts.inter(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 7,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    // NOTE SISTEM
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.block_rounded,
                              color: Colors.grey[500], size: 12),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                                'Dihitung otomatis oleh sistem • tidak dapat diubah manual',
                                style: GoogleFonts.inter(
                                    color: Colors.grey[500],
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),

                    // FOOTER BUTTONS
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  widget.controller.commitToPos();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side:
                                        const BorderSide(color: _ink, width: 2),
                                  ),
                                ),
                                icon: const Icon(Icons.bookmark_rounded,
                                    color: _ink, size: 15),
                                label: Text('Simpan Draft',
                                    style: GoogleFonts.inter(
                                        color: _ink,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // 1) sinkron state lokal sheet -> controller
                                  widget.controller.selectedMethod.value =
                                      _payMethod.value == 'QRIS'
                                          ? 'QRIS'
                                          : 'Tunai';
                                  widget.controller.cashReceived.value =
                                      _uang.value;
                                  widget.controller.qrisMode.value =
                                      _qrisMode.value;
                                  widget.controller.qrisGenerated.value =
                                      _qrisGenerated.value;
                                  widget.controller.qrisPaid.value =
                                      _qrisPaid.value;

                                  // 2) validasi via controller
                                  if (!widget.controller.canProcess) {
                                    Get.snackbar(
                                      'Belum bisa diselesaikan',
                                      widget.controller.selectedMethod.value ==
                                              'Tunai'
                                          ? 'Uang diterima kurang dari total tagihan.'
                                          : 'QRIS dinamis belum terbayar (status belum "SUDAH MASUK").',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: _ink,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(12),
                                    );
                                    return;
                                  }

                                  // 3) commit snapshot struk (TIDAK clear cart dulu)
                                  widget.controller.processPayment();

                                  // 4) buka STRUK via Get.to + binding.
                                  Get.to(
                                    () => const StrukView(),
                                    binding: StrukBinding(),
                                    transition: Transition.cupertino,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _pink,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side:
                                        const BorderSide(color: _ink, width: 2),
                                  ),
                                ),
                                icon: const Icon(Icons.payments_rounded,
                                    color: Colors.white, size: 15),
                                label: Text('Bayar & Selesai',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TILE METODE PEMBAYARAN
  // ==========================================
  Widget _payTile(
      String label, IconData icon, String method, Color activeColor) {
    final active = _payMethod.value == method;
    return GestureDetector(
      onTap: () => _payMethod.value = method,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? activeColor : _white,
          borderRadius: BorderRadius.circular(12),
          border: _bdr(1.5),
          boxShadow: active ? _hard(2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? Colors.white : _ink, size: 15),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : _ink,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // PANEL QRIS (STATIS / DINAMIS + STATUS)
  // ==========================================
  Widget _buildQrisPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12),
        border: _bdr(1.5),
        boxShadow: _hard(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Segmented STATIS / DINAMIS = pemilih mode (tetap di sheet)
          Row(
            children: [
              Expanded(child: _qrisSeg('STATIS', 'STATIS')),
              const SizedBox(width: 8),
              Expanded(child: _qrisSeg('DINAMIS', 'DINAMIS')),
            ],
          ),
          const SizedBox(height: 12),
          // Tombol pembuka POPUP QRIS (QR dirender di popup, bukan inline)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => Get.dialog(
                _QrisPopup(
                  mode: _qrisMode.value,
                  total: widget.controller.grandTotal,
                  totalLabel: widget.controller
                      .formatRupiah(widget.controller.grandTotal),
                  paidRef: _qrisPaid,
                ),
                barrierColor: const Color(0x99000000),
                barrierDismissible: true,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _pink,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: _ink, width: 2),
                ),
              ),
              icon: const Icon(Icons.qr_code_2_rounded,
                  color: Colors.white, size: 16),
              label: Text('TAMPILKAN QRIS',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrisSeg(String label, String mode) {
    final active = _qrisMode.value == mode;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _qrisMode.value = mode,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: active ? _pink : _white,
          borderRadius: BorderRadius.circular(10),
          border: _bdr(1.5),
          boxShadow: active ? _hard(2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? Icons.qr_code_scanner_rounded : Icons.qr_code_rounded,
                color: active ? Colors.white : _ink, size: 13),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : _ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ITEM PESANAN (CARD BRUTALISME + SWIPE HAPUS)
  // ==========================================
  Widget _buildItem(Map<String, dynamic> item, int idx) {
    final qty = item['quantity'] as int;
    final harga = item['harga'] as int;

    return Dismissible(
      key: ValueKey('order-${item['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: _red,
          borderRadius: BorderRadius.circular(14),
          border: _bdr(),
          boxShadow: _hard(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hapus',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            const Icon(Icons.delete_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
      onDismissed: (_) {
        final i = widget.controller.cartItems
            .indexWhere((e) => e['id'] == item['id']);
        if (i >= 0) widget.controller.removeItem(i);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(14),
          border: _bdr(),
          boxShadow: _hard(2),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => widget.controller.removeItem(idx),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _red,
                  borderRadius: BorderRadius.circular(10),
                  border: _bdr(1.5),
                ),
                child: const Icon(Icons.delete_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['nama'] ?? '',
                      style: GoogleFonts.inter(
                          color: _ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${widget.controller.formatRupiah(harga)} /cup',
                      style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.controller.formatRupiah(harga * qty),
                    style: GoogleFonts.outfit(
                        color: _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.controller.decreaseItem(idx),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _red,
                          shape: BoxShape.circle,
                          border: _bdr(1.5),
                          boxShadow: _hard(1),
                        ),
                        child: const Icon(Icons.remove_rounded,
                            color: Colors.white, size: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('$qty',
                          style: GoogleFonts.inter(
                              color: _ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w900)),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.controller.increaseItem(idx),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _green,
                          shape: BoxShape.circle,
                          border: _bdr(1.5),
                          boxShadow: _hard(1),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// KONTRAK UKURAN GAMBAR QRIS STATIS
// ============================================================
const double qrisStatisRasioMin = 1.0;
const double qrisStatisRasioMaks = 1.6;
const int qrisStatisLebarMinPx = 800;
const int qrisStatisLebarMaksPx = 1200;
const int qrisStatisTinggiMinPx = 800;
const int qrisStatisTinggiMaksPx = 1920;
const int qrisStatisFileMaksKb = 500;
const String qrisStatisFormatDianjurkan = 'PNG';

// ==========================================
// POPUP QRIS — statis = PNG merchant | dinamis = QR ASLI dari Duitku
// ==========================================
class _QrisPopup extends StatefulWidget {
  const _QrisPopup({
    required this.mode,
    required this.total,
    required this.totalLabel,
    required this.paidRef,
  });

  final String mode;
  final int total;
  final String totalLabel;
  final RxBool paidRef;

  static const String _statisAsset =
      'assets/images/qris_statis/qris_omgcoffee_statis.png';

  @override
  State<_QrisPopup> createState() => _QrisPopupState();
}

class _QrisPopupState extends State<_QrisPopup> {
  bool _loading = false;
  String? _qrString;
  String? _errorMsg;
  String? _currentOrderId;
  Timer? _pollingTimer;
  int _remainingSeconds = 600; // 10 menit dalam detik
  Timer? _countdownTimer; // Timer terpisah untuk hitung mundur

  /// Panggil Edge Function untuk generate QRIS dinamis sungguhan.
  Future<void> _generateQris() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    try {
      final orderId = 'OMG-${DateTime.now().millisecondsSinceEpoch}';

      final resp = await http
          .post(
            Uri.parse(_qrisGenerateUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'action': 'generate',
              'method': 'qris_dynamic',
              'amount': widget.total,
              'orderId': orderId,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      if (!mounted) return;

      if (resp.statusCode == 200 && data['success'] == true) {
        setState(() {
          _qrString = data['qrString'] as String?;
          _currentOrderId = orderId;
          _loading = false;
          _remainingSeconds = 600;
        });
        _startPolling(); // Mulai polling otomatis setelah QR jadi
        _startCountdown(); // Mulai countdown 10 menit
      } else {
        setState(() {
          _errorMsg = (data['message'] ?? 'Gagal membuat QRIS.') as String;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = 'Tidak bisa menghubungi server pembayaran. Cek koneksi.';
        _loading = false;
      });
    }
  }

  /// Metode untuk mengecek status transaksi secara berkala
  Future<void> _checkStatus() async {
    if (_currentOrderId == null) return;

    try {
      final resp = await http
          .post(
            Uri.parse(_qrisGenerateUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'action': 'check',
              'orderId': _currentOrderId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      if (data['status'] == 'PAID') {
        widget.paidRef.value = true;
        _stopPolling();
      }
    } catch (e) {
      // Ignore error sementara
    }
  }

  /// Memulai timer polling setiap 4 detik
  void _startPolling() {
    _stopPolling();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _checkStatus();
    });
  }

  /// Menghentikan timer polling
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Memulai countdown timer 10 menit
  void _startCountdown() {
    _stopCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        _stopCountdown();
        _stopPolling();
        setState(() {
          _remainingSeconds = 0;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  /// Menghentikan timer countdown
  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  /// Format detik ke format MM:SS
  String get _formattedTime {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'DINAMIS') _generateQris();
  }

  @override
  void dispose() {
    _stopCountdown();
    _stopPolling(); // Pastikan polling berhenti saat popup ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDyn = widget.mode == 'DINAMIS';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(20),
              border: _bdr(2),
              boxShadow: _hard(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isDyn ? 'QRIS DINAMIS' : 'QRIS STATIS',
                            style: GoogleFonts.inter(
                                color: _ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                decoration: TextDecoration.none)),
                        const SizedBox(height: 2),
                        Text(
                            isDyn
                                ? 'Nominal terkunci • ${widget.totalLabel}'
                                : 'Scan lalu ketik nominal',
                            style: GoogleFonts.inter(
                                color: Colors.grey[500],
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _white,
                        shape: BoxShape.circle,
                        border: _bdr(1.5),
                        boxShadow: _hard(1),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: _ink, size: 16),
                    ),
                  ),
                ]),
                const SizedBox(height: 14),

                // ===== AREA QR / LOADING / ERROR (DINAMIS) atau PNG (STATIS) =====
                if (isDyn)
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: _bdr(2),
                        boxShadow: _hard(2),
                      ),
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : _errorMsg != null
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(_errorMsg!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            color: _red,
                                            fontSize: 8.5,
                                            fontWeight: FontWeight.w700,
                                            height: 1.4,
                                            decoration: TextDecoration.none)),
                                  ),
                                )
                              : _remainingSeconds <= 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.timer_off_rounded,
                                              color: _red, size: 48),
                                          const SizedBox(height: 8),
                                          Text(
                                            'QR KEDALUWARSA',
                                            style: GoogleFonts.inter(
                                                color: _red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          const SizedBox(height: 12),
                                          OutlinedButton(
                                            onPressed: _generateQris,
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: _white,
                                              side: const BorderSide(
                                                  color: _ink, width: 2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 8),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              'BUAT QR BARU',
                                              style: GoogleFonts.inter(
                                                  color: _ink,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _qrString != null
                                      ? QrImageView(
                                          data: _qrString!,
                                          size: 220,
                                          version: QrVersions.auto,
                                          backgroundColor: Colors.white,
                                        )
                                      : const Center(
                                          child: Text('Menyiapkan QR...',
                                              style: TextStyle(fontSize: 10))),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: _bdr(2),
                      boxShadow: _hard(2),
                    ),
                    child: Image.asset(
                      _QrisPopup._statisAsset,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_rounded,
                              color: Colors.grey[400], size: 40),
                          const SizedBox(height: 6),
                          Text(
                              'QRIS statis belum terbaca.\nCek file ada di:\nassets/images/qris_statis/\nqris_omgcoffee_statis.png',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                  decoration: TextDecoration.none)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 14),

                // ===== BAGIAN BAWAH: nominal + countdown + pill status + tombol =====
                if (isDyn) ...[
                  if (_remainingSeconds > 0 &&
                      _qrString != null &&
                      !_loading &&
                      _errorMsg == null) ...[
                    Column(
                      children: [
                        Text(
                          'WAKTU TERSISA',
                          style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              decoration: TextDecoration.none),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formattedTime,
                          style: GoogleFonts.outfit(
                              color: _remainingSeconds < 60 ? _red : _ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(widget.totalLabel,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.none)),
                  const SizedBox(height: 10),
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: widget.paidRef.value
                              ? const Color(0xFFE3EEE5)
                              : const Color(0xFFFFF3D6),
                          borderRadius: BorderRadius.circular(50),
                          border: _bdr(1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                    color: widget.paidRef.value
                                        ? _green
                                        : const Color(0xFFFFB800),
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(
                                widget.paidRef.value
                                    ? 'SUDAH MASUK'
                                    : 'MENUNGGU PEMBAYARAN...',
                                style: GoogleFonts.inter(
                                    color: widget.paidRef.value
                                        ? _green
                                        : const Color(0xFFB8860B),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  // Tombol DEV sementara sampai polling stabil
                  Obx(() => OutlinedButton(
                        onPressed: _qrString == null && !_loading
                            ? _generateQris
                            : () =>
                                widget.paidRef.value = !widget.paidRef.value,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _white,
                          side: const BorderSide(color: _ink, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                        ),
                        child: Text(
                            _qrString == null && !_loading
                                ? 'Coba Lagi'
                                : '[DEV] ${widget.paidRef.value ? "Reset ke Belum Masuk" : "Tandai Sudah Masuk"}',
                            style: GoogleFonts.inter(
                                color: _ink,
                                fontSize: 7.5,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none)),
                      )),
                ] else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3D6),
                      borderRadius: BorderRadius.circular(50),
                      border: _bdr(1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_note_rounded,
                            color: Color(0xFFB8860B), size: 13),
                        const SizedBox(width: 6),
                        Text('Nominal diketik manual oleh pelanggan',
                            style: GoogleFonts.inter(
                                color: const Color(0xFFB8860B),
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.none)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
