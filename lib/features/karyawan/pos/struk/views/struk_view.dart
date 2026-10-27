import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/struk_controller.dart';

// ===== palette (clean: hitam + abu; aksen pink/hijau kecil saja) =====
const Color _ink = Color(0xFF1A1A1A);
const Color _pink = Color(0xFFEF2B7C);
const Color _cream = Color(0xFFFAF9F6);
const Color _white = Color(0xFFFFFDF8);

Border _bdr([double w = 2]) => Border.all(color: _ink, width: w);
List<BoxShadow> _hard([double o = 2]) =>
    [BoxShadow(color: _ink, offset: Offset(o, o), blurRadius: 0)];

class _NoScrollbar extends ScrollBehavior {
  const _NoScrollbar();
  @override
  Widget buildScrollbar(
          BuildContext ctx, Widget child, ScrollableDetails details) =>
      child;
}

class StrukView extends StatefulWidget {
  const StrukView({super.key});

  @override
  State<StrukView> createState() => _StrukViewState();
}

class _StrukViewState extends State<StrukView> {
  final GlobalKey _paperKey = GlobalKey();
  bool _sharing = false;

  StrukController get c => Get.find<StrukController>();

  Future<void> _shareStrukAsImage() async {
    if (_sharing) return;
    setState(() => _sharing = true);

    try {
      final boundary = _paperKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Konteks struk tidak ditemukan.');

      // Pixel ratio 2x supaya hasil PNG tajam di HP/WA.
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Gagal membuat PNG struk.');

      final fileName = 'struk_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = XFile.fromData(byteData.buffer.asUint8List(),
          name: fileName, mimeType: 'image/png');

      final idText = c.trxId.isEmpty ? '#A-017' : c.trxId;
      final caption =
          'OMG COFFEE • Struk $idText\nTotal: ${_rp(c.grandTotal)}\nMetode: ${c.methodDisplay}\nTerima kasih ☕';

      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          text: caption,
          subject: 'Struk OMG COFFEE',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        'Bagikan Gagal',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final idText = c.trxId.isEmpty ? '#A-017' : c.trxId;

    return Scaffold(
      backgroundColor: _cream,
      body: Column(
        children: [
          // ============ HEADER PINK (tetap) ============
          Container(
            color: _pink,
            padding: EdgeInsets.fromLTRB(16, topPad + 14, 16, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _white,
                      shape: BoxShape.circle,
                      border: _bdr(1.5),
                      boxShadow: _hard(2),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: _ink, size: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Struk Transaksi',
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              shadows: const [
                                Shadow(
                                    color: Colors.black, offset: Offset(2, 2))
                              ])),
                      const SizedBox(height: 2),
                      Text('Bukti pembayaran yang sah',
                          style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ============ KERTAS STRUK (gerigi + border + watermark tetap) ============
          Expanded(
            child: ScrollConfiguration(
              behavior: const _NoScrollbar(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: RepaintBoundary(
                  key: _paperKey,
                  child: CustomPaint(
                    painter: _PaperPainter(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _brand(),
                              _dashLine(),

                              // ---- KONTEN 1: grid meta 2x2 ----
                              _metaRow('NO. TRANSAKSI', idText, 'TANGGAL',
                                  c.trxDate.isEmpty ? '-' : c.trxDate),
                              const SizedBox(height: 10),
                              _metaRow('KARYAWAN', c.kasir, 'JAM PESAN',
                                  c.orderTime.isEmpty ? '-' : c.orderTime),
                              _dashLine(),

                              // ---- KONTEN 2: item ----
                              Row(children: [
                                _label('ITEM PESANAN'),
                                const Spacer(),
                                Text('${c.totalItem} Porsi Total',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey.shade500,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              const SizedBox(height: 10),
                              for (final it in c.items)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _kvRow(
                                    label: "${it['nama']}   ×${it['quantity']}",
                                    value: _rp((it['harga'] as int) *
                                        (it['quantity'] as int)),
                                    labelColor: _ink,
                                    labelWeight: FontWeight.w700,
                                    labelSize: 10.5,
                                    valueSize: 10.5,
                                  ),
                                ),
                              _dashLine(),

                              // ---- KONTEN 3 + 4: subtotal, pajak, total ----
                              _kvRow(
                                  label: 'Subtotal (${c.totalItem} item)',
                                  value: _rp(c.subtotal),
                                  valueWeight: FontWeight.w700),
                              const SizedBox(height: 5),
                              _kvRow(
                                  label: 'Pajak',
                                  value: c.useTax ? '${c.taxPercent}%' : '0%',
                                  valueWeight: FontWeight.w700),
                              _thinDiv(),
                              _totalPlain(c.grandTotal),
                              _dashLine(),

                              // ---- KONTEN 5: pembayaran ----
                              _payCard(c),
                              _dashLine(),

                              // ---- KONTEN 7: kostumer + catatan ----
                              _label('KOSTUMER'),
                              const SizedBox(height: 8),
                              _kvRow(
                                  label: 'Kostumer',
                                  value: '-',
                                  valueWeight: FontWeight.w700),
                              const SizedBox(height: 5),
                              _kvRow(
                                  label: 'ID Kostumer',
                                  value:
                                      c.costumerId.isEmpty ? '-' : c.costumerId,
                                  valueWeight: FontWeight.w700),
                              _dashLine(),
                              _label('CATATAN PELANGGAN'),
                              const SizedBox(height: 8),
                              _noteBox(c.catatan.isEmpty
                                  ? 'Es sedikit, jangan terlalu manis'
                                  : c.catatan),
                              const SizedBox(height: 18),

                              // ---- paling bawah: catatan struk ----
                              Text(
                                  '“Terima kasih! Kopi hangat, hari menyenangkan.”\nSimpan struk ini sebagai bukti transaksi yang sah.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      color: Colors.grey.shade500,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // garis batas atas area tombol
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.grey.shade300,
          ),

          // ============ TOMBOL FIXED DI LUAR KERTAS ============
          Container(
            color: _cream,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => c.pesanBaru(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pink,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: _ink, width: 2),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 17),
                    label: Text('PESANAN BARU',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _ghostBtn(Icons.print_rounded, 'Cetak Struk',
                            () {/* TODO: cetak */})),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _ghostBtn(
                      Icons.share_rounded,
                      _sharing ? 'Memproses...' : 'Bagikan',
                      _sharing ? () {} : _shareStrukAsImage,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= helpers =================
  String _rp(int v) => 'Rp ${v.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      )}';

  Widget _brand() => Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: _pink,
                shape: BoxShape.circle,
                border: _bdr(1.5),
                boxShadow: _hard(2)),
            child:
                const Icon(Icons.coffee_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 8),
          Text('OMG COFFEE',
              style: GoogleFonts.outfit(
                  color: _ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5)),
          const SizedBox(height: 2),
          Text('COFFEE KELILING, ROMBONG 01',
              style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          // TODO(sumber-data): alamat toko belum ada di controller (fiktif sesuai gambar)
          const SizedBox(height: 1),
          Text('Rute Alun-Alun Utara, Bandung',
              style: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontSize: 7,
                  fontWeight: FontWeight.w600)),
        ],
      );

  Widget _label(String t) => Text(t,
      style: GoogleFonts.inter(
          color: Colors.grey.shade500,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2));

  // pemisah major = garis putus (DIPERTAHANKAN)
  Widget _dashLine() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: LayoutBuilder(
            builder: (ctx, pc) => SizedBox(
                height: 10,
                child: CustomPaint(
                    painter: _DashPainter(), size: Size(pc.maxWidth, 10)))),
      );

  // pemisah minor = hairline abu
  Widget _thinDiv() => Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: _ink.withOpacity(0.08));

  // baris label:kiri value:kanan (polos, tanpa leader)
  Widget _kvRow({
    IconData? icon,
    Color? iconColor,
    required String label,
    required String value,
    Color? labelColor,
    FontWeight? labelWeight,
    double labelSize = 9.5,
    FontWeight valueWeight = FontWeight.w800,
    double valueSize = 9.5,
  }) =>
      Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? Colors.grey.shade500, size: 14),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    color: labelColor ?? Colors.grey.shade600,
                    fontSize: labelSize,
                    fontWeight: labelWeight ?? FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Text(value,
              style: GoogleFonts.inter(
                  color: _ink, fontSize: valueSize, fontWeight: valueWeight)),
        ],
      );

  Widget _metaCell(String label, String value, {bool right = false}) => Column(
        crossAxisAlignment:
            right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6)),
          const SizedBox(height: 3),
          Text(value,
              textAlign: right ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.inter(
                  color: _ink, fontSize: 10.5, fontWeight: FontWeight.w800)),
        ],
      );

  Widget _metaRow(String l1, String v1, String l2, String v2) => Row(
        children: [
          Expanded(child: _metaCell(l1, v1)),
          const SizedBox(width: 12),
          Expanded(child: _metaCell(l2, v2, right: true)),
        ],
      );

  Widget _totalPlain(int total) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('TOTAL',
              style: GoogleFonts.inter(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
          const Spacer(),
          Text(_rp(total),
              style: GoogleFonts.outfit(
                  color: _ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 0.9)),
        ],
      );

  // KONTEN 5: putih murni + border abu; watermark ditanam di sini
  Widget _payCard(StrukController c) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
        ),
        child: Stack(
          children: [
            // watermark di BELAKANG teks isi card => pas di area card, tak menghapus teks
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: IgnorePointer(
                  child: Center(
                    child: Transform.rotate(
                      angle: -0.26,
                      child: Text('OMG COFFEE',
                          maxLines: 1,
                          softWrap: false,
                          style: GoogleFonts.outfit(
                              color: _pink.withOpacity(0.18),
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2)),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _label('PEMBAYARAN'),
                const SizedBox(height: 10),
                _kvRow(
                  icon: c.isCash
                      ? Icons.payments_rounded
                      : Icons.qr_code_2_rounded,
                  iconColor: Colors.grey.shade600,
                  label: c.isCash ? 'TUNAI' : 'QRIS',
                  labelColor: _ink,
                  labelWeight: FontWeight.w800,
                  value: _rp(c.grandTotal),
                ),
                _thinDiv(),
                _kvRow(
                    label: 'Uang Diterima',
                    value: c.isCash ? _rp(c.receiptCash) : 'Scan QR',
                    valueWeight: FontWeight.w700),
                _thinDiv(),
                _kvRow(
                    label: 'Kembalian',
                    value: c.isCash ? _rp(c.receiptChange) : '—',
                    valueWeight: FontWeight.w700),
              ],
            ),
          ],
        ),
      );

  Widget _noteBox(String note) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.edit_rounded, color: Colors.grey.shade600, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '“$note”',
                style: GoogleFonts.inter(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _ghostBtn(IconData icon, String label, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(10),
              border: _bdr(1.5),
              boxShadow: _hard(1)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: _ink, size: 15),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.inter(
                    color: _ink, fontSize: 9.5, fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}

// ================= painters (gerigi + dash — DIPERTAHANKAN) =================
class _PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double tw = 14, th = 8, r = 14;
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h - th);
    double x = w;
    bool down = true;
    while (x - tw / 2 >= 0) {
      x -= tw / 2;
      path.lineTo(x, down ? h : h - th);
      down = !down;
    }
    path
      ..lineTo(0, h - th)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF1A1A1A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant _PaperPainter o) => false;
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1A1A1A).withOpacity(0.30)
      ..strokeWidth = 1;
    final y = size.height / 2;
    double x = 0;
    while (x < size.width) {
      final end = (x + 5) > size.width ? size.width : x + 5;
      canvas.drawLine(Offset(x, y), Offset(end, y), p);
      x += 9;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter o) => false;
}
