// PATH FILE: lib/features/owner/bahan_baku/views/bahan_baku_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/bahan_baku_controller.dart';

// Data dipindah ke luar class agar bisa jadi const
const List<Map<String, dynamic>> _kategoriList = [
  {'label': 'Kopi', 'icon': Icons.coffee_rounded, 'color': Color(0xFF6F4E37)},
  {
    'label': 'Susu',
    'icon': Icons.local_drink_rounded,
    'color': Color(0xFF4A90E2)
  },
  {'label': 'Pemanis', 'icon': Icons.grain_rounded, 'color': Color(0xFFFF69B4)},
  {
    'label': 'Sirup',
    'icon': Icons.water_drop_rounded,
    'color': Color(0xFFFFD700)
  },
  {
    'label': 'Lainnya',
    'icon': Icons.inventory_2_rounded,
    'color': Color(0xFF2D7A4F)
  },
];

// Icon categories KHUSUS tema BAHAN BAKU (tidak keluar tema)
const Map<String, List<Map<String, dynamic>>> _iconCategories = {
  'Semua': [
    {'icon': Icons.grain_rounded, 'label': 'Biji'},
    {'icon': Icons.coffee_rounded, 'label': 'Kopi'},
    {'icon': Icons.bakery_dining_rounded, 'label': 'Tepung'},
    {'icon': Icons.water_drop_rounded, 'label': 'Air'},
    {'icon': Icons.water_rounded, 'label': 'Sirup'},
    {'icon': Icons.local_drink_rounded, 'label': 'Susu'},
    {'icon': Icons.eco_rounded, 'label': 'Daun'},
    {'icon': Icons.grass_rounded, 'label': 'Herba'},
    {'icon': Icons.forest_rounded, 'label': 'Rempah'},
    {'icon': Icons.local_florist_rounded, 'label': 'Bunga'},
    {'icon': Icons.cake_rounded, 'label': 'Gula'},
    {'icon': Icons.cookie_rounded, 'label': 'Karamel'},
    {'icon': Icons.icecream_rounded, 'label': 'Madu'},
    {'icon': Icons.inventory_2_rounded, 'label': 'Kotak'},
    {'icon': Icons.inventory_rounded, 'label': 'Stok'},
  ],
  'Biji & Tepung': [
    {'icon': Icons.grain_rounded, 'label': 'Biji'},
    {'icon': Icons.coffee_rounded, 'label': 'Kopi'},
    {'icon': Icons.bakery_dining_rounded, 'label': 'Tepung'},
  ],
  'Cairan': [
    {'icon': Icons.water_drop_rounded, 'label': 'Air'},
    {'icon': Icons.water_rounded, 'label': 'Sirup'},
    {'icon': Icons.local_drink_rounded, 'label': 'Susu'},
  ],
  'Daun & Rempah': [
    {'icon': Icons.eco_rounded, 'label': 'Daun'},
    {'icon': Icons.grass_rounded, 'label': 'Herba'},
    {'icon': Icons.forest_rounded, 'label': 'Rempah'},
    {'icon': Icons.local_florist_rounded, 'label': 'Bunga'},
  ],
  'Pemanis': [
    {'icon': Icons.cake_rounded, 'label': 'Gula'},
    {'icon': Icons.cookie_rounded, 'label': 'Karamel'},
    {'icon': Icons.icecream_rounded, 'label': 'Madu'},
  ],
  'Kemasan': [
    {'icon': Icons.inventory_2_rounded, 'label': 'Kotak'},
    {'icon': Icons.inventory_rounded, 'label': 'Stok'},
  ],
};

class BahanBakuView extends GetView<BahanBakuController> {
  const BahanBakuView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          // ========== 1. HEADER ==========
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 42),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bahan Baku',
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              shadows: const [
                                Shadow(
                                    color: Colors.black, offset: Offset(2, 2))
                              ])),
                      const SizedBox(height: 2),
                      Text('Kelola stok & harga bahan',
                          style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ========== TAB MENGAMBANG ==========
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(50),
                  border: appBorder(),
                  boxShadow: AppShadows.hard(3),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final active = controller.selectedTabIndex.value == 0;
                        return GestureDetector(
                          onTap: () => controller.changeTab(0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: active
                                      ? AppColors.ink
                                      : Colors.transparent,
                                  width: 2),
                            ),
                            child: Center(
                              child: Text('Tambah Bahan',
                                  style: GoogleFonts.inter(
                                      color: active
                                          ? Colors.white
                                          : AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Obx(() {
                        final active = controller.selectedTabIndex.value == 1;
                        return GestureDetector(
                          onTap: () => controller.changeTab(1),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: active
                                      ? AppColors.ink
                                      : Colors.transparent,
                                  width: 2),
                            ),
                            child: Center(
                              child: Text('Daftar Bahan',
                                  style: GoogleFonts.inter(
                                      color: active
                                          ? Colors.white
                                          : AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ========== KONTEN ==========
          Expanded(
            child: Obx(() => controller.selectedTabIndex.value == 0
                ? _buildTambahBahan(context)
                : _buildDaftarBahan(context)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB TAMBAH BAHAN
  // ==========================================
  Widget _buildTambahBahan(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ========== CARD KHUSUS BAHAN RESEP ==========
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7A4F),
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.eco_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KHUSUS BAHAN RESEP',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text('Masuk ke dalam komposisi Resep Menu',
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
          const SizedBox(height: 14),

          // ========== CARD PILIH KATEGORI (VERTIKAL) ==========
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PILIH KATEGORI BAHAN',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                const SizedBox(height: 12),

                // Susunan VERTIKAL (atas-bawah)
                ..._kategoriList.map((k) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Obx(() {
                        final aktif = controller.kategori.value == k['label'];
                        return GestureDetector(
                          onTap: () =>
                              controller.selectKategori(k['label'] as String),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: aktif
                                  ? (k['color'] as Color)
                                  : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: appBorder(1.5),
                              boxShadow: aktif ? AppShadows.hard(2) : [],
                            ),
                            child: Row(
                              children: [
                                Icon(k['icon'] as IconData,
                                    color: aktif
                                        ? Colors.white
                                        : (k['color'] as Color),
                                    size: 16),
                                const SizedBox(width: 10),
                                Text(k['label'] as String,
                                    style: GoogleFonts.inter(
                                        color: aktif
                                            ? Colors.white
                                            : AppColors.ink,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800)),
                                const Spacer(),
                                if (aktif)
                                  const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        );
                      }),
                    )),

                // Render Kategori Custom (Dinamis)
                Obx(() {
                  if (controller.customKategoriList.isEmpty)
                    return const SizedBox.shrink();
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      ...controller.customKategoriList.map((k) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Obx(() {
                              final aktif =
                                  controller.kategori.value == k['label'];
                              return GestureDetector(
                                onTap: () => controller
                                    .selectKategori(k['label'] as String),
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: aktif
                                        ? (k['color'] as Color)
                                        : AppColors.appWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border: appBorder(1.5),
                                    boxShadow: aktif ? AppShadows.hard(2) : [],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(k['icon'] as IconData,
                                          color: aktif
                                              ? Colors.white
                                              : (k['color'] as Color),
                                          size: 16),
                                      const SizedBox(width: 10),
                                      Text(k['label'] as String,
                                          style: GoogleFonts.inter(
                                              color: aktif
                                                  ? Colors.white
                                                  : AppColors.ink,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800)),
                                      const Spacer(),
                                      if (aktif)
                                        const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 18),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )),
                    ],
                  );
                }),

                // Tombol + Kategori Lain
                GestureDetector(
                  onTap: _showKategoriBaruSheet, // <-- UBAH INI
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.muted,
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_rounded,
                            color: AppColors.muted, size: 16),
                        const SizedBox(width: 10),
                        Text('Kategori Lain',
                            style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // INFO "i" KATEGORI
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.muted, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                            'Kategori = kelompok bahan (warna & icon). Satu kategori bisa berisi banyak bahan — buat baru lewat + Kategori Lain.',
                            style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                height: 1.3)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD NAMA BAHAN + INFO "i" ==========
          _labelCard('NAMA BAHAN'),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: TextField(
              controller: controller.namaController,
              decoration: const InputDecoration(
                fillColor: AppColors.appWhite,
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Contoh: Kopi Bubuk Arabica',
                hintStyle: TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.muted.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: appBorder(1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.muted, size: 12),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                      'Nama item bahan nyata yang dibeli & distok — contoh: Kopi Bubuk Arabica (bukan nama kelompok).',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          height: 1.3)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD SATUAN UNIT (2 KOLOM RAPI) ==========
          _labelCard('SATUAN UNIT'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _unitButton(
                          'kg',
                          controller.unit.value == 'kg',
                          () => controller.selectUnit('kg'))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => _unitButton(
                          'gram',
                          controller.unit.value == 'gr',
                          () => controller.selectUnit('gr'))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => _unitButton(
                          'liter',
                          controller.unit.value == 'L',
                          () => controller.selectUnit('L'))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(() => _unitButton(
                          'ml',
                          controller.unit.value == 'ml',
                          () => controller.selectUnit('ml'))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD STOK SAAT INI (2 INPUT + BADGE) ==========
          _labelCard('STOK SAAT INI'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STOK SAAT INI',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: appBorder(1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.stokController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  fillColor: AppColors.appWhite,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                      color: AppColors.ink,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D7A4F),
                                    borderRadius: BorderRadius.circular(50),
                                    border: appBorder(1),
                                  ),
                                  child: Text(controller.unit.value,
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800)),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('STOK MINIMUM',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: appBorder(1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.stokMinController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  fillColor: AppColors.appWhite,
                                  filled: true,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                      color: AppColors.ink,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            Obx(() => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    borderRadius: BorderRadius.circular(50),
                                    border: appBorder(1),
                                  ),
                                  child: Text(controller.unit.value,
                                      style: GoogleFonts.inter(
                                          color: AppColors.ink,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w800)),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD TOTAL HARGA BELI (LENGKAP) ==========
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOTAL HARGA BELI',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('Total uang yang dibayarkan untuk stok di atas',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: appBorder(1),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppColors.ink, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: Row(
                    children: [
                      Text('Rp',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller.hargaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            fillColor: AppColors.appWhite,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: '255.000',
                            hintStyle: TextStyle(
                                color: AppColors.ink,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() => Text(
                          '(untuk ${controller.stokController.text.isEmpty ? "0" : controller.stokController.text} ${controller.unit.value})',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Hasil hitungan per satuan:',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(50),
                        border: appBorder(1),
                      ),
                      child: Obx(() => Text(
                          'Menjadi Rp 85.000/${controller.unit.value}',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w800))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD HPP DASAR ==========
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: appBorder(1),
                  ),
                  child: const Icon(Icons.calculate_rounded,
                      color: AppColors.ink, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() => Text(
                        'Rp 255.000 ÷ ${controller.stokController.text.isEmpty ? "3" : controller.stokController.text} ${controller.unit.value} = Rp 85.000/${controller.unit.value}',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      )),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7A4F),
                    borderRadius: BorderRadius.circular(50),
                    border: appBorder(1),
                  ),
                  child: Text('HPP DASAR',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD KALKULASI OTOMATIS ==========
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7A4F),
                        borderRadius: BorderRadius.circular(50),
                        border: appBorder(1.5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt_rounded,
                              color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text('KALKULASI OTOMATIS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: appBorder(1),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppColors.ink, size: 14),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('HARGA SATUAN TERKECIL',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D7A4F),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Obx(() => Text(
                                'Per ${controller.unit.value}',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.w800))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(() => RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Rp 85',
                                    style: GoogleFonts.inter(
                                        color: AppColors.ink,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900)),
                                TextSpan(
                                    text: ' / ${controller.unit.value}',
                                    style: GoogleFonts.inter(
                                        color: AppColors.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: AppColors.muted),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.muted.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.calculate_rounded,
                                color: AppColors.ink, size: 12),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Obx(() => Text(
                                  'Rp 85.000  1.000 ${controller.unit.value} = Rp 85/${controller.unit.value}',
                                  style: GoogleFonts.inter(
                                      color: AppColors.ink,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF2D7A4F), size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          'Dihitung otomatis oleh sistem saat kamu memasukkan harga beli. Nilai ini akan dipakai untuk menghitung HPP di Resep Menu.',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              height: 1.3)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD SUPPLIER ==========
          _labelCard('SUPPLIER (OPSIONAL)'),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: TextField(
              controller: controller.supplierController,
              decoration: const InputDecoration(
                fillColor: AppColors.appWhite,
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: 'Contoh: Koperasi Gayo',
                hintStyle: TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ========== CARD AKTIF DIGUNAKAN ==========
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7A4F),
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktif Digunakan',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text('Bahan akan muncul di daftar resep',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                // Toggle custom dengan border
                Obx(() {
                  final aktif = controller.aktif.value;
                  return GestureDetector(
                    onTap: () => controller.toggleAktifForm(!aktif),
                    child: Container(
                      width: 50,
                      height: 28,
                      decoration: BoxDecoration(
                        color: aktif
                            ? const Color(0xFFE8F5E9)
                            : AppColors.appWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: appBorder(1.5),
                      ),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.all(2),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color:
                                  aktif ? const Color(0xFF2D7A4F) : Colors.grey,
                              shape: BoxShape.circle,
                              border: appBorder(1),
                            ),
                            transform:
                                Matrix4.translationValues(aktif ? 20 : 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ========== BUTTON SIMPAN ==========
          GestureDetector(
            onTap: () => controller.simpanBahan(),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                border: appBorder(),
                boxShadow: AppShadows.hard(3),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Simpan Bahan',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('OMG COFFEE • COFFEE KELILING',
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

  // ==========================================
  // TAB DAFTAR BAHAN (DESIGN FIGMA)
  // ==========================================
  Widget _buildDaftarBahan(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. SEARCH + FILTER KUNING
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: AppColors.muted, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: controller.onSearchChanged,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Cari bahan...',
                            hintStyle: TextStyle(
                                color: AppColors.muted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _showFilterBahanSheet,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: const Icon(Icons.filter_list_rounded,
                      color: AppColors.ink, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. SUMMARY STATUS (AMAN / MENIPIS / HABIS)
          Row(
            children: [
              Expanded(
                child: Obx(() => _statusCard(
                    controller.countStatus('Aman'),
                    'AMAN',
                    const Color(0xFF2D7A4F),
                    Icons.check_circle_rounded)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => _statusCard(
                    controller.countStatus('Menipis'),
                    'MENIPIS',
                    const Color(0xFFFFB800),
                    Icons.warning_amber_rounded)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() => _statusCard(controller.countStatus('Habis'),
                    'HABIS', const Color(0xFFD32F2F), Icons.block_rounded)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. HEADER STOK + BADGE JUMLAH
          Row(
            children: [
              Expanded(
                child: Text('STOK BAHAN BAKU',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
              ),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(8),
                      border: appBorder(1),
                    ),
                    child: Column(
                      children: [
                        Text('${controller.bahanList.length}',
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                        Text('bahan',
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 7,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 12),

          // 4. LIST BAHAN (mengalir ikut scroll, seperti Tambah Bahan)
          Obx(() {
            final list = controller.filteredBahan;
            if (list.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: appBorder(),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_rounded,
                        color: AppColors.muted.withValues(alpha: 0.5),
                        size: 40),
                    const SizedBox(height: 10),
                    Text('Bahan tidak ditemukan',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            }
            return Column(
              children: [
                for (var b in list) ...[
                  _bahanCard(b),
                  const SizedBox(height: 12),
                ],
              ],
            );
          }),

          // 5. FOOTER (CODE SAMA PERSIS DENGAN TAB TAMBAH BAHAN)
          const SizedBox(height: 16),
          Center(
            child: Text('Tap card untuk lihat detail & restock',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('OMG COFFEE • COFFEE KELILING',
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

  // ---------- CARD SUMMARY STATUS ----------
  Widget _statusCard(int count, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$count',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900)),
              const SizedBox(width: 6),
              Icon(icon, color: Colors.white, size: 14),
            ],
          ),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // ---------- WARNA KATEGORI ----------
  Color _colorKategori(String k) {
    switch (k) {
      case 'Kopi':
        return const Color(0xFF6F4E37);
      case 'Susu':
        return const Color(0xFF4A90E2);
      case 'Pemanis':
        return const Color(0xFFFF69B4);
      case 'Sirup':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF2D7A4F);
    }
  }

  // ---------- CARD BAHAN ----------
  Widget _bahanCard(Map<String, dynamic> b) {
    final nama = (b['nama'] ?? '-').toString();
    final kategori = (b['kategori'] ?? 'Lainnya').toString();
    final stok = (b['stok'] as num).toDouble();
    final min = (b['stokMin'] as num).toDouble();
    final unit = (b['unit'] ?? '').toString();
    final harga = (b['harga'] as num).toInt();
    final status = controller.statusBahan(b);
    final catColor = _colorKategori(kategori);

    final statusColor = status == 'Aman'
        ? const Color(0xFF2D7A4F)
        : status == 'Menipis'
            ? const Color(0xFFFFB800)
            : const Color(0xFFD32F2F);

    return GestureDetector(
      onTap: () => _showDetailBahanSheet(b),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(14),
          border: appBorder(),
          boxShadow: AppShadows.hard(3),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: catColor,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Icon(controller.iconKategori(kategori),
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama,
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text('${controller.formatStok(stok)} $unit • $kategori',
                      style: GoogleFonts.inter(
                          color: catColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                      'Min: ${controller.formatStok(min)} $unit • Rp ${controller.formatRupiah(harga)}/$unit',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1),
              ),
              child: Text(status.toUpperCase(),
                  style: GoogleFonts.inter(
                      color: statusColor == const Color(0xFFFFB800)
                          ? AppColors.ink
                          : Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.ink, size: 18),
          ],
        ),
      ),
    );
  }

  // ---------- BOTTOM SHEET DETAIL & RESTOCK ----------
  void _showDetailBahanSheet(Map<String, dynamic> b) {
    final nama = (b['nama'] ?? '-').toString();
    final kategori = (b['kategori'] ?? 'Lainnya').toString();
    final unit = (b['unit'] ?? '').toString();
    final status = controller.statusBahan(b);
    final catColor = _colorKategori(kategori);

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAF9F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: catColor,
                    shape: BoxShape.circle,
                    border: appBorder(1.5),
                  ),
                  child: Icon(controller.iconKategori(kategori),
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nama,
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text('$kategori • Status: ${status.toUpperCase()}',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('RESTOK CEPAT (+$unit)',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _restockButton(b, 1, '+1')),
                const SizedBox(width: 8),
                Expanded(child: _restockButton(b, 5, '+5')),
                const SizedBox(width: 8),
                Expanded(child: _restockButton(b, 10, '+10')),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => controller.hapusBahan(b),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(12),
                  border: appBorder(),
                  boxShadow: AppShadows.hard(2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text('Hapus Bahan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _restockButton(Map<String, dynamic> b, double amount, String label) {
    return GestureDetector(
      onTap: () => controller.restockBahan(b, amount),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(10),
          border: appBorder(1.5),
          boxShadow: AppShadows.hard(2),
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  // ---------- BOTTOM SHEET FILTER STATUS ----------
  void _showFilterBahanSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAF9F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Filter Status',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: ['Semua', 'Aman', 'Menipis', 'Habis']
                      .map((s) => GestureDetector(
                            onTap: () {
                              controller.filterStatus.value = s;
                              Get.back();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: controller.filterStatus.value == s
                                    ? AppColors.primary
                                    : AppColors.appWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: appBorder(),
                                boxShadow: controller.filterStatus.value == s
                                    ? AppShadows.hard(2)
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(s,
                                      style: GoogleFonts.inter(
                                          color:
                                              controller.filterStatus.value == s
                                                  ? Colors.white
                                                  : AppColors.ink,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800)),
                                  if (controller.filterStatus.value == s)
                                    const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                )),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _labelCard(String text) {
    return Text(text,
        style: GoogleFonts.inter(
            color: AppColors.ink,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5));
  }

  // ==========================================
  // HELPER WIDGET UNTUK UNIT BUTTON
  // ==========================================
  Widget _unitButton(String label, bool aktif, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: aktif ? const Color(0xFF2D7A4F) : AppColors.appWhite,
          borderRadius: BorderRadius.circular(10),
          border: appBorder(1.5),
          boxShadow: aktif ? AppShadows.hard(2) : [],
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.inter(
                  color: aktif ? Colors.white : AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM SHEET: KATEGORI BARU (FINAL CORRECTED)
  // ==========================================
  void _showKategoriBaruSheet() {
    final screenHeight = MediaQuery.of(Get.context!).size.height;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        decoration: const BoxDecoration(
          color: Color(0xFFFAF9F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ========== HANDLE + HEADER ==========
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFAF9F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Judul + Badge CUSTOM (Rata Kiri)
                  Row(
                    children: [
                      Text('Kategori Baru',
                          style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(6),
                          border: appBorder(1),
                        ),
                        child: Text('CUSTOM',
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 9,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Deskripsi (Rata Kiri)
                  Text('Kategori custom untuk bahan baku',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            // ========== SCROLLABLE CONTENT ==========
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. NAMA KATEGORI
                    _sectionLabel('NAMA KATEGORI'),
                    const SizedBox(height: 6),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(),
                      ),
                      child: Center(
                        child: TextField(
                          controller: controller.newKategoriNama,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Contoh: Bumbu Dapur',
                            hintStyle: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. WARNA IDENTITAS
                    _sectionLabel('WARNA IDENTITAS'),
                    const SizedBox(height: 6),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: TextField(
                                controller: controller.hexColorController,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '#6F4E37',
                                  hintStyle: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                onChanged: (v) {
                                  if (controller.isValidHex(v)) {
                                    controller.updateKategoriFromHex(v);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(() => Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: controller.newKategoriWarna.value,
                                  borderRadius: BorderRadius.circular(6),
                                  border: appBorder(1),
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. ICON KATEGORI (Emoji-keyboard style with category tabs)
                    Row(
                      children: [
                        _sectionLabel('ICON KATEGORI'),
                        const Spacer(),
                        Text('Pilih 1 Simbol',
                            style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Category Tabs (Horizontal Scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(() {
                        final currentCat =
                            controller.selectedIconCategory.value;
                        final categories = _iconCategories.keys.toList();
                        return Row(
                          children: categories.map((cat) {
                            final isSelected = currentCat == cat;
                            return GestureDetector(
                              onTap: () =>
                                  controller.setSelectedIconCategory(cat),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.appWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: appBorder(1),
                                  boxShadow:
                                      isSelected ? AppShadows.hard(1.5) : [],
                                ),
                                child: Text(
                                  cat,
                                  style: GoogleFonts.inter(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.ink,
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Grid Icon (50px, 4 kolom, alignment start)
                    Obx(() {
                      final currentCat = controller.selectedIconCategory.value;
                      final iconList = _iconCategories[currentCat] ??
                          _iconCategories['Semua']!;

                      return Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 10,
                        children: iconList.map((item) {
                          final icon = item['icon'] as IconData;
                          final label = item['label'] as String;
                          return _iconGrid(icon, label, 50.0);
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 16),

                    // 4. LIVE PREVIEW
                    _sectionLabel('LIVE PREVIEW TAMPILAN'),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: appBorder(),
                      ),
                      child: Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.newKategoriWarna.value,
                              borderRadius: BorderRadius.circular(10),
                              border: appBorder(1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(controller.newKategoriIcon.value,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 10),
                                Text(
                                  'Preview',
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),

            // ========== BUTTON SIMPAN ==========
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFFFAF9F6),
              ),
              child: GestureDetector(
                onTap: controller.simpanKategoriBaru,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.label_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Simpan Kategori',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Helper untuk Icon Grid
  Widget _iconGrid(IconData icon, String label, double width) {
    return GestureDetector(
      onTap: () => controller.setNewKategoriIcon(icon),
      child: Obx(() {
        final isActive = controller.newKategoriIcon.value == icon;
        return SizedBox(
          width: width,
          height: width,
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.appWhite,
              borderRadius: BorderRadius.circular(10),
              border: appBorder(1.5),
              boxShadow: isActive ? AppShadows.hard(2) : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: isActive ? Colors.white : AppColors.ink, size: 20),
                const SizedBox(height: 2),
                Text(label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: isActive ? Colors.white : AppColors.muted,
                        fontSize: 7,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Helper nama icon
  String _getIconLabel(IconData icon) {
    if (icon == Icons.eco_rounded) return 'Bahan';
    if (icon == Icons.water_drop_rounded) return 'Cair';
    if (icon == Icons.grain_rounded) return 'Biji';
    if (icon == Icons.local_drink_rounded) return 'Minum';
    if (icon == Icons.coffee_rounded) return 'Kopi';
    if (icon == Icons.emoji_food_beverage_rounded) return 'Teh';
    if (icon == Icons.bakery_dining_rounded) return 'Roti';
    if (icon == Icons.cake_rounded) return 'Kue';
    if (icon == Icons.cookie_rounded) return 'Cookie';
    if (icon == Icons.icecream_rounded) return 'Dingin';
    if (icon == Icons.restaurant_rounded) return 'Sendok';
    if (icon == Icons.kitchen_rounded) return 'Dapur';
    if (icon == Icons.blender_rounded) return 'Blender';
    if (icon == Icons.inventory_2_rounded) return 'Kotak';
    if (icon == Icons.abc_rounded) return 'Huruf';
    if (icon == Icons.star_rounded) return 'Bintang';
    return 'Custom';
  }

  // Helper label section
  Widget _sectionLabel(String text) {
    return Text(text,
        style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5));
  }
}
