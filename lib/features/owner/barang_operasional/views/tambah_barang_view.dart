import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/tambah_barang_controller.dart';

class TambahBarangView extends GetView<TambahBarangController> {
  TambahBarangView({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(context),
          Transform.translate(
            offset: const Offset(0, -22),
            child: _buildTabs(),
          ),
          Expanded(
            child: PageView(
              controller:
                  controller.pageController, // ✅ Gunakan _pageController
              onPageChanged: (index) {
                controller.selectedTabIndex.value =
                    index; // ✅ Sync tab dengan page
              },
              children: [
                RepaintBoundary(child: _buildTambahBarang()),
                RepaintBoundary(child: _buildDaftarBarang()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 50),
      child: Stack(
        children: [
          const Positioned(
            top: -8,
            right: 0,
            child: BrutalDots(cols: 4, rows: 3),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    shape: BoxShape.circle,
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.ink, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tambah Barang',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(color: Colors.black, offset: Offset(2, 2))
                            ])),
                    const SizedBox(height: 2),
                    Text('Barang operasional & stok',
                        style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const BrutalIcon(
                icon: Icons.star_rounded,
                color: AppColors.yellow,
                size: 36,
                outlineWidth: 3.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(50),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Row(
        children: [
          SizedBox(width: 140, child: _tabButton(0, 'TAMBAH BARANG')),
          const SizedBox(width: 4),
          SizedBox(width: 140, child: _tabButton(1, 'DAFTAR BARANG')),
        ],
      ),
    );
  }

  Widget _tabButton(int index, String label) {
    return Obx(() {
      final active = controller.selectedTabIndex.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectedTabIndex.value = index;
          controller.pageController.jumpToPage(index); // ✅ Ganti di sini
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.appWhite,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: active ? AppColors.ink : Colors.transparent, width: 1.5),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
          ),
        ),
      );
    });
  }

  Widget _buildTambahBarang() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. INFO CARD: KHUSUS BARANG OPERASIONAL
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC94D),
                    shape: BoxShape.circle,
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.inventory_2_rounded,
                      color: AppColors.ink, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KHUSUS BARANG OPERASIONAL',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(
                          'Tidak masuk resep sebagai bahan — ikut sebagai biaya per porsi',
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
          const SizedBox(height: 20),

          // 2. PILIH KATEGORI BARANG (Card + Pill Buttons)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan garis bawah kuning
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('PILIH KATEGORI BARANG',
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Text('WAJIB',
                            style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Kategori Buttons (PILL SHAPE - 2 kolom)
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.kategoriList.map((kat) {
                        final isSelected =
                            controller.selectedKategori.value == kat['nama'];
                        return GestureDetector(
                          onTap: () => controller.selectKategori(kat['nama']),
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kat['color']
                                  : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(50),
                              border: appBorder(1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(kat['icon'] as IconData,
                                    color: AppColors.ink, size: 16),
                                const SizedBox(width: 6),
                                Text(kat['nama'] as String,
                                    style: GoogleFonts.inter(
                                        color: AppColors.ink,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                                if (isSelected) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: AppColors.brandGreen,
                                      shape: BoxShape.circle,
                                      border: appBorder(1),
                                    ),
                                    child: const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                const SizedBox(height: 10),
                // Tombol + Kategori Lain (PILL DASHED)
                GestureDetector(
                  onTap: () {},
                  child: CustomPaint(
                    painter: _DashedRRectPainter(AppColors.ink, 50),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_rounded,
                              color: AppColors.ink, size: 16),
                          const SizedBox(width: 4),
                          Text('+ Kategori Lain',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. NAMA BARANG
          Text('NAMA BARANG',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => controller.namaBarang.value = val,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Masukkan nama barang...',
                      hintStyle: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                const Icon(Icons.edit_rounded,
                    color: AppColors.primary, size: 18),
              ],
            ),
          ),
          const SizedBox(height: 20),

// 4. PILIH SATUAN (Card + Layout Horizontal + Dashed Line)
// 4. PILIH SATUAN (Card + Layout Horizontal + Efek Timbul)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan garis bawah kuning
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('PILIH SATUAN (MENGIKUTI KATEGORI)',
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            shape: BoxShape.circle,
                            border: appBorder(1.5),
                          ),
                          child: const Icon(Icons.info_outline_rounded,
                              color: AppColors.ink, size: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Daftar Satuan per Kategori (Horizontal Layout)
// Daftar Satuan per Kategori (Horizontal Layout)
                Obx(() => Column(
                      children: controller.kategoriList.map((kat) {
                        final satuanList =
                            controller.satuanPerKategori[kat['nama']] ?? [];
                        final isKategoriActive =
                            controller.selectedKategori.value == kat['nama'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ SATU CONTAINER UTUH untuk Label + Units
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: kat['color'],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.ink,
                                    width: isKategoriActive ? 2.5 : 1.5),
                              ),
                              child: Row(
                                children: [
                                  // Label Kategori
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.appWhite.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(kat['icon'] as IconData,
                                            color: AppColors.ink, size: 14),
                                        const SizedBox(width: 4),
                                        Text(kat['nama'] as String,
                                            style: GoogleFonts.inter(
                                                color: AppColors.ink,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Units (Horizontal Scroll)
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: satuanList.map((satuan) {
                                          final isSelected =
                                              controller.selectedSatuan.value ==
                                                  satuan;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.selectKategori(
                                                    kat['nama']);
                                                controller.selectSatuan(satuan);
                                              },
                                              child: Container(
                                                height: 28,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppColors.brandGreen
                                                      : AppColors.appWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: AppColors.ink,
                                                      width:
                                                          isSelected ? 1.5 : 1),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(satuan,
                                                        style: GoogleFonts.inter(
                                                            color: isSelected
                                                                ? Colors.white
                                                                : AppColors.ink,
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                    if (isSelected) ...[
                                                      const SizedBox(width: 3),
                                                      const Icon(
                                                          Icons.check_rounded,
                                                          color: Colors.white,
                                                          size: 10),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Garis putus-putus pemisah
                            SizedBox(
                              height: 2,
                              child: Row(
                                children: List.generate(
                                  40,
                                  (i) => Expanded(
                                    child: Container(
                                      color: i % 2 == 0
                                          ? AppColors.muted.withOpacity(0.4)
                                          : Colors.transparent,
                                      height: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    )),
                // Tombol + Kategori Lain (PILL DASHED)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: CustomPaint(
                          painter: _DashedRRectPainter(AppColors.ink, 50),
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.appWhite,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_rounded,
                                    color: AppColors.ink, size: 14),
                                const SizedBox(width: 4),
                                Text('+ Kategori Lain',
                                    style: GoogleFonts.inter(
                                        color: AppColors.ink,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('(bebas pilih)',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. STOK SAAT INI & STOK MINIMUM
          // 5. STOK SAAT INI & STOK MINIMUM
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STOK SAAT INI',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Obx(() => Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: AppShadows.hard(2),
                          ),
                          child: Stack(
                            children: [
                              // [1] ISI CARD (di-clip sempurna)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: AppColors.appWhite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          onChanged: (val) {
                                            final cleanVal = val.replaceAll(
                                                RegExp(r'[^0-9]'), '');
                                            controller.stokSaatIni.value =
                                                cleanVal.isNotEmpty
                                                    ? int.parse(cleanVal)
                                                    : 0;
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText:
                                                '${controller.stokSaatIni.value}',
                                            hintStyle: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 56,
                                        color: AppColors.brandGreen,
                                        alignment: Alignment.center,
                                        child: Text(
                                          controller.selectedSatuan.value
                                              .toUpperCase(),
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // [2] BORDER OVERLAY (paling atas, anti-putus)
                              IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: appBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STOK MINIMUM',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Obx(() => Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: AppShadows.hard(2),
                          ),
                          child: Stack(
                            children: [
                              // [1] ISI CARD (di-clip sempurna)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: AppColors.appWhite,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          onChanged: (val) {
                                            final cleanVal = val.replaceAll(
                                                RegExp(r'[^0-9]'), '');
                                            controller.stokMinimum.value =
                                                cleanVal.isNotEmpty
                                                    ? int.parse(cleanVal)
                                                    : 0;
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText:
                                                '${controller.stokMinimum.value}',
                                            hintStyle: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 56,
                                        color: const Color(0xFFFFC94D),
                                        alignment: Alignment.center,
                                        child: Text(
                                          controller.selectedSatuan.value
                                              .toUpperCase(),
                                          style: GoogleFonts.inter(
                                              color: AppColors.ink,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // [2] BORDER OVERLAY (paling atas, anti-putus)
                              IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: appBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 6. TOTAL HARGA BELI (Card Kuning)
// 6. TOTAL HARGA BELI (Card Kuning - Sesuai Desain)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD93D), // Kuning terang sesuai desain
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text('TOTAL HARGA BELI',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: appBorder(1.5),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppColors.ink, size: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Total uang yang dibayarkan untuk stok di atas',
                    style: GoogleFonts.inter(
                        color: AppColors.ink.withOpacity(0.7),
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),

                // Input Field dengan "Rp | angka" layout
                Obx(() => Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                      ),
                      child: Row(
                        children: [
                          // "Rp" di kiri dengan garis vertikal
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: AppColors.ink.withOpacity(0.3),
                                    width: 1.5),
                              ),
                            ),
                            child: Text('Rp',
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 10),
                          // Input angka
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                              onChanged: (val) {
                                final cleanVal =
                                    val.replaceAll(RegExp(r'[^0-9]'), '');
                                controller.totalHargaBeli.value =
                                    cleanVal.isNotEmpty
                                        ? int.parse(cleanVal)
                                        : 0;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: '0',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 16, fontWeight: FontWeight.w900),
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // "(untuk X satuan)" di kanan
                          Text(
                              '(untuk ${controller.stokSaatIni.value} ${controller.selectedSatuan.value})',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),

                // Hasil hitungan per satuan
                Text('Hasil hitungan per satuan:',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Menjadi Rp',
                                    style: GoogleFonts.inter(
                                        color: AppColors.muted,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    '${controller.formatHargaPerSatuan}/${controller.selectedSatuan.value}',
                                    style: GoogleFonts.inter(
                                        color: AppColors.ink,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 7. KALKULASI OTOMATIS (Card Hijau)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE3EEE5),
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen,
                        borderRadius: BorderRadius.circular(6),
                        border: appBorder(1.5),
                      ),
                      child: const Icon(Icons.calculate_rounded,
                          color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text('KALKULASI OTOMATIS',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w900)),
                    const Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: appBorder(1.5),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppColors.ink, size: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('HARGA SATUAN TERKECIL',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.brandGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppColors.brandGreen, width: 1.5),
                            ),
                            child: Text(
                                'Per ${controller.selectedSatuan.value.substring(0, 1).toUpperCase() + controller.selectedSatuan.value.substring(1)}',
                                style: GoogleFonts.inter(
                                    color: AppColors.brandGreen,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Rp ${controller.formatHargaPerSatuan}',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                      Text('/${controller.selectedSatuan.value}',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      const Divider(height: 16, thickness: 1),
                      Row(
                        children: [
                          const Icon(Icons.calculate_rounded,
                              color: AppColors.muted, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                                'Rp ${controller.formatTotalHarga} ÷ ${controller.stokSaatIni.value} ${controller.selectedSatuan.value} = Rp ${controller.formatHargaPerSatuan}/${controller.selectedSatuan.value}',
                                style: GoogleFonts.inter(
                                    color: AppColors.muted,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.brandGreen, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          'Dihitung otomatis oleh sistem saat kamu memasukkan harga beli. Nilai ini akan otomatis dipakai untuk hitung biaya per porsi di Resep Menu.',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 8. AKTIF DIGUNAKAN
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktif Digunakan',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('Barang akan muncul di pemantauan stok',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Obx(() => Switch(
                      value: controller.aktifDigunakan.value,
                      onChanged: (val) => controller.aktifDigunakan.value = val,
                      activeColor: AppColors.brandGreen,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // FOOTER
          Center(
            child: Text('OMG COFFEE · COFFEE KELILING',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),

          // TOMBOL SIMPAN
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.simpanBarang,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.ink, width: 2),
                ),
                shadowColor: AppColors.ink,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Simpan Barang',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaftarBarang() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEARCH & FILTER
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: AppColors.ink, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (val) =>
                              controller.searchQuery.value = val,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Cari barang...',
                            hintStyle: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Tombol FILTER dengan badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC94D),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xFF1A1A1A), width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF1A1A1A),
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.filter_list_rounded,
                      color: AppColors.ink,
                      size: 22,
                    ),
                  ),
                  // Badge "2"
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.appWhite, width: 2),
                      ),
                      child: const Center(
                        child: Text('2',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // SUMMARY CARDS (3 kolom)
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  value: '${controller.jumlahAman}',
                  label: 'AMAN',
                  bgColor: AppColors.brandGreen,
                  icon: Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatusCard(
                  value: '${controller.jumlahMenipis}',
                  label: 'MENIPIS',
                  bgColor: const Color(0xFFFFB800),
                  icon: Icons.info_outline_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatusCard(
                  value: '${controller.jumlahHabis}',
                  label: 'HABIS',
                  bgColor: const Color(0xFFD32F2F),
                  icon: Icons.error_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // HEADER LIST
          Row(
            children: [
              Text('STOK BARANG OPERASIONAL',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              Text('${controller.totalBarang} barang',
                  style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),

          // LIST BARANG
// ✅ BENAR: Langsung Column tanpa Obx (karena daftarBarang adalah List biasa, bukan RxList)
          Column(
            children: controller.daftarBarang.map((barang) {
              return _buildBarangCard(barang);
            }).toList(),
          ),
          const SizedBox(height: 12),

          // FOOTER TEXT
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.muted, width: 1.5),
                ),
                child: const Icon(Icons.touch_app_rounded,
                    color: AppColors.muted, size: 10),
              ),
              const SizedBox(width: 6),
              Text('Tap card untuk lihat detail & restock',
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),

          // FOOTER
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
    );
  }

// Helper: Status Card (AMAN/MENIPIS/HABIS)
  Widget _buildStatusCard({
    required String value,
    required String label,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: appBorder(1.5),
        boxShadow: AppShadows.hard(2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value,
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              Icon(icon, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

// Helper: Barang Card
  Widget _buildBarangCard(Map<String, dynamic> barang) {
    final status = barang['status'] as String;
    final statusColor = status == 'habis'
        ? const Color(0xFFD32F2F)
        : status == 'menipis'
            ? const Color(0xFFFFB800)
            : AppColors.brandGreen;

    final statusLabel = status == 'habis'
        ? 'HABIS'
        : status == 'menipis'
            ? 'MENIPIS'
            : 'AMAN';

    final stokColor = status == 'habis'
        ? const Color(0xFFD32F2F)
        : status == 'menipis'
            ? const Color(0xFFFFB800)
            : AppColors.brandGreen;

    return GestureDetector(
      onTap: () {
        // TODO: Navigasi ke detail barang
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(14),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Row(
          children: [
            // Icon bulat
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: barang['iconColor'] as Color,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Icon(barang['icon'] as IconData,
                  color: AppColors.ink, size: 22),
            ),
            const SizedBox(width: 12),
            // Info barang
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(barang['nama'] as String,
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('${barang['stok']} ${barang['satuan']}',
                          style: GoogleFonts.inter(
                              color: stokColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                      Text(' • ${barang['kategori']}',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                      'Min: ${barang['minStok']} ${barang['satuan']} • Rp ${controller.formatRupiah(barang['harga'] as int)}/${barang['satuan']}',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Badge status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Text(statusLabel,
                  style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.ink, size: 20),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedRRectPainter(this.color, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final rrect =
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = distance + 8;
        canvas.drawPath(
            metric.extractPath(
                distance, end > metric.length ? metric.length : end),
            paint);
        distance = end + 6;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
