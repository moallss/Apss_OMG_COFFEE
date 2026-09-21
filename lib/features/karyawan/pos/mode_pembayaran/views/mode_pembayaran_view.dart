import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/mode_pembayaran_controller.dart';

// ====================================================
// 1. BOTTOM SHEET MODE PEMBAYARAN (Tunai / QRIS)
// ====================================================
class ModePembayaranView extends GetView<ModePembayaranController> {
  const ModePembayaranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // LAYER 1: OVERLAY GELAP (tanpa blur, sesuai mockup)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),

          // LAYER 2: SHEET DRAGGABLE
          _DraggablePaymentSheet(controller: controller),
        ],
      ),
    );
  }
}

// ============================================
// WIDGET SHEET DRAGGABLE (Animasi Halus)
// ============================================
class _DraggablePaymentSheet extends StatefulWidget {
  final ModePembayaranController controller;
  const _DraggablePaymentSheet({required this.controller});

  @override
  State<_DraggablePaymentSheet> createState() => _DraggablePaymentSheetState();
}

class _DraggablePaymentSheetState extends State<_DraggablePaymentSheet>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _offset = ValueNotifier(0);
  bool _isAnimating = false;
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  // 0.78 > tinggi sheet Ringkasan (0.7) → menutupi Ringkasan sepenuhnya
  double get _sheetHeight => MediaQuery.of(context).size.height * 0.78;

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
        builder: (context, offset, child) {
          return Transform.translate(
            offset: Offset(0, offset),
            child: child,
          );
        },
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
                    Text('Pembayaran',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // KONTEN (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      _buildMethodSelector(),
                      const SizedBox(height: 24),

                      // TOTAL TAGIHAN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Tagihan',
                              style: GoogleFonts.inter(
                                  color: Colors.grey[500], fontSize: 13)),
                          Obx(() => Text(
                              widget.controller
                                  .formatRupiah(widget.controller.grandTotal),
                              style: GoogleFonts.outfit(
                                  color: const Color(0xFF3A6F43),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(height: 1, color: Colors.grey[300]),
                      const SizedBox(height: 20),

                      // KONTEN SESUAI METODE
                      Obx(() =>
                          widget.controller.selectedMethod.value == 'Tunai'
                              ? _buildCashSection()
                              : _buildQrisSection()),
                      const SizedBox(height: 24),

                      // CTA SELESAIKAN PEMBAYARAN
                      Obx(() => SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: widget.controller.canProcess
                                  ? () {
                                      if (widget.controller.processPayment()) {
                                        Get.to(() =>
                                            const ModePembayaranSuksesView());
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF3E9B),
                                disabledBackgroundColor: Colors.grey[300],
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text('Selesaikan Pembayaran',
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          )),
                      const _KeyboardSpacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SEGMENTED CONTROL METODE (Tunai / QRIS)
  // ==========================================
  Widget _buildMethodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF3E9B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          _methodTab('Tunai', Icons.payments_rounded),
          _methodTab('QRIS', Icons.qr_code_rounded),
        ],
      ),
    );
  }

  Widget _methodTab(String name, IconData icon) {
    return Expanded(
      child: Obx(() {
        final selected = widget.controller.selectedMethod.value == name;
        return GestureDetector(
          onTap: () => widget.controller.selectMethod(name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFFF3E9B) : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: selected ? Colors.white : const Color(0xFFD6336C),
                    size: 18),
                const SizedBox(width: 8),
                Text(name,
                    style: GoogleFonts.inter(
                        color:
                            selected ? Colors.white : const Color(0xFFD6336C),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ==========================================
  // SECTION TUNAI
  // ==========================================
  Widget _buildCashSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UANG DITERIMA',
            style: GoogleFonts.inter(
                color: Colors.grey[500],
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1)),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller.cashController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.controller.onCashChanged,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: '0',
            prefixText: 'Rp  ',
            prefixStyle: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFD6336C), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFD6336C), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF3E9B), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // BOX KEMBALIAN
        Obx(() {
          if (widget.controller.cashReceived.value == 0) {
            return const SizedBox.shrink();
          }
          final enough = widget.controller.isCashSufficient;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: enough
                  ? const Color(0xFF3A6F43).withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(enough ? 'Kembalian' : 'Uang Kurang',
                    style: GoogleFonts.inter(
                        color: enough ? const Color(0xFF3A6F43) : Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Icon(
                        enough
                            ? Icons.check_circle_rounded
                            : Icons.warning_rounded,
                        color: enough ? const Color(0xFF3A6F43) : Colors.red,
                        size: 18),
                    const SizedBox(width: 6),
                    Text(
                        widget.controller
                            .formatRupiah(widget.controller.change.abs()),
                        style: GoogleFonts.inter(
                            color:
                                enough ? const Color(0xFF3A6F43) : Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),

        // QUICK CHIPS
        Row(
          children: [
            _quickChip('Uang Pas', null),
            const SizedBox(width: 8),
            _quickChip('Rp 50rb', 50000),
            const SizedBox(width: 8),
            _quickChip('Rp 100rb', 100000),
          ],
        ),
      ],
    );
  }

  Widget _quickChip(String label, int? amount) {
    return GestureDetector(
      onTap: () =>
          widget.controller.setCash(amount ?? widget.controller.grandTotal),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD6336C), width: 1),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                color: const Color(0xFFD6336C),
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ==========================================
  // SECTION QRIS
  // ==========================================
  Widget _buildQrisSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6336C), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Icon(Icons.qr_code_rounded,
                size: 120, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text('Silakan scan QRIS untuk membayar',
              style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 4),
          Obx(() => Text(
              widget.controller.formatRupiah(widget.controller.grandTotal),
              style: GoogleFonts.outfit(
                  color: const Color(0xFF3A6F43),
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

// ====================================================
// 2. HALAMAN SUKSES
// ====================================================
class ModePembayaranSuksesView extends GetView<ModePembayaranController> {
  const ModePembayaranSuksesView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A6F43).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Color(0xFF3A6F43), size: 60),
                ),
                const SizedBox(height: 20),
                Text('Pembayaran Berhasil!',
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Obx(() => Column(
                      children: [
                        Text(controller.trxId.value,
                            style: GoogleFonts.inter(
                                color: Colors.grey[500], fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(controller.trxDate.value,
                            style: GoogleFonts.inter(
                                color: Colors.grey[500], fontSize: 11)),
                      ],
                    )),
                const SizedBox(height: 24),
                Obx(() => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFD6336C), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _receiptRow('Metode', controller.receiptMethod.value),
                          _receiptRow(
                              'Total',
                              controller
                                  .formatRupiah(controller.receiptTotal.value)),
                          _receiptRow(
                              'Diterima',
                              controller
                                  .formatRupiah(controller.receiptCash.value)),
                          _receiptRow(
                            'Kembalian',
                            controller
                                .formatRupiah(controller.receiptChange.value),
                            valueColor: const Color(0xFF3A6F43),
                          ),
                        ],
                      ),
                    )),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.snackbar(
                            'Info', 'Fitur cetak struk segera hadir',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFF8F0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFFD6336C), width: 1.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('CETAK STRUK',
                            style: GoogleFonts.inter(
                                color: const Color(0xFFD6336C),
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.finishTransaction(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3E9B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('TRANSAKSI BARU',
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
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value,
      {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
          Text(value,
              style: GoogleFonts.inter(
                  color: valueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
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
