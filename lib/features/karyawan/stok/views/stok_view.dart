import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/stok_controller.dart';

// Palette Brutalism OMG Coffee
const Color _ink = Color(0xFF1A1A1A);
const Color _pink = Color(0xFFEF2B7C);
const Color _yellow = Color(0xFFFFC94D);
const Color _green = Color(0xFF2D7A4F);
const Color _red = Color(0xFFD32F2F);
const Color _white = Color(0xFFFFFFFF);
const Color _cream = Color(0xFFFAF9F6);
const Color _grayLight = Color(0xFFF3F4F6);

Border _bdr([double w = 2]) => Border.all(color: _ink, width: w);
List<BoxShadow> _hard([double o = 4]) =>
    [BoxShadow(color: _ink, offset: Offset(o, o), blurRadius: 0)];

class StokView extends GetView<StokController> {
  const StokView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    // Header pink tingginya sekitar 80px + safe area atas
    final headerH = topPad + 80;

    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          // ============================================
          // LAYER 1: HEADER PINK SOLID
          // ============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: Container(
              color: _pink,
              padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cek Stok Rombong',
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        shadows: const [
                          Shadow(color: Colors.black, offset: Offset(2, 2))
                        ]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rombong 01 • Shift Pagi',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================
          // LAYER 2: KONTEN UTAMA (ALERT, FILTER, LIST)
          // ============================================
          Positioned(
            top: headerH,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // 2A. ALERT BANNER MERAH
                Obx(() {
                  if (!controller.hasCriticalStock)
                    return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _red,
                          borderRadius: BorderRadius.circular(16),
                          border: _bdr(2),
                          boxShadow: _hard(3),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Colors.white, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${controller.criticalCount} Item hampir habis',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              'tap untuk lihat ▼',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // 2B. FILTER TABS (Pink Active Style)
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 8),
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFilterChip('SEMUA', 0),
                      _buildFilterChip('KOPI', 1),
                      _buildFilterChip('SUSU & DAIRY', 2),
                      _buildFilterChip('PEMANIS', 3),
                      _buildFilterChip('LAINNYA', 4),
                    ],
                  ),
                ),

                // 2C. SECTION TITLE
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STOK SHIFT BERJALAN',
                        style: GoogleFonts.inter(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Obx(() => Text(
                            '${controller.filteredStokItems.length} item ditampilkan',
                            style: GoogleFonts.inter(
                              color: Colors.grey[500],
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          )),
                    ],
                  ),
                ),

                // 2D. LIST ITEM STOK (Scrollable Area)
                Expanded(
                  child: Obx(() {
                    final items = controller.filteredStokItems;
                    if (items.isEmpty) {
                      return Center(
                          child: Text('Tidak ada item.',
                              style: TextStyle(color: Colors.grey)));
                    }

                    return ListView.separated(
                      // Naikkan bottom padding ke 160 agar item terakhir terlihat utuh di atas tombol Request
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 4, bottom: 150),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final originalIndex = controller.stokItems
                            .indexWhere((e) => e['id'] == item['id']);

                        return _buildStokCard(item, originalIndex);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),

          // ============================================
          // LAYER 3: BUTTON REQUEST STOK (FLOATING / OVERLAY)
          // Persis seperti CART SUMMARY BAR di POS VIEW
          // ============================================
          Positioned(
            left: 20,
            right: 20,
            // Angka 50 ini memberi jarak aman dari Navbar Floating (biasanya tinggi navbar ~70-80px)
            bottom: 50,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _pink,
                borderRadius: BorderRadius.circular(16),
                border: _bdr(),
                boxShadow: _hard(4),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _white,
                      borderRadius: BorderRadius.circular(10),
                      border: _bdr(1.5),
                    ),
                    child:
                        const Icon(Icons.send_rounded, color: _pink, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'REQUEST STOK KE OWNER',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER (TETAP SAMA SEBELUMNYA) ---

  Widget _buildFilterChip(String label, int index) {
    final isActive = controller.selectedFilterIndex.value == index;

    return GestureDetector(
      onTap: () => controller.selectedFilterIndex.value = index,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _pink : _white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _ink, width: 1.5),
          boxShadow: isActive ? [] : [_shadowSoft()],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isActive ? Colors.white : _ink,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  BoxShadow _shadowSoft() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: const Offset(0, 2),
      blurRadius: 4,
    );
  }

  Widget _buildStokCard(Map<String, dynamic> item, int originalIndex) {
    final stok = item['stok'] as double;
    final maks = item['maksimal'] as double;
    final progressRatio = (stok / maks).clamp(0.0, 1.0);
    final statusColor = controller.getStatusColor(item['status'] as String);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(14),
        border: _bdr(2),
        boxShadow: _hard(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // A. SISI KIRI (ICON)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _grayLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _ink.withOpacity(0.1)),
            ),
            child: Icon(
              item['ikon'] as IconData,
              color: _ink,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // B. TENGAH (DETAIL & PROGRESS)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['nama'] as String,
                  style: GoogleFonts.inter(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _buildSmoothProgressBar(progressRatio, statusColor),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['status'] as String,
                          style: GoogleFonts.inter(
                            color: statusColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      item['estimasi'] as String,
                      style: GoogleFonts.inter(
                        color: Colors.grey[500],
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // C. KANAN (ANGKA & TOMBOL ADJUSTMENT - HORIZONTAL ALIGNMENT)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Blok Angka Stok
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$stok',
                    style: GoogleFonts.outfit(
                      color: _ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    item['satuan'] as String,
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8), // Jarak antara angka dan tombol

              // Tombol Adjustment
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _grayLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _ink.withOpacity(0.1)),
                ),
                child: const Icon(Icons.tune_rounded, size: 16, color: _ink),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmoothProgressBar(double ratio, Color fillColor) {
    return Stack(
      children: [
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _grayLight,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: ratio,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
