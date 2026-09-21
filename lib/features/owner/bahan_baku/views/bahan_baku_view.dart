// PATH FILE: lib/features/owner/bahan_baku/views/bahan_baku_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/bahan_baku_controller.dart';

class BahanBakuView extends GetView<BahanBakuController> {
  const BahanBakuView({super.key});

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
              controller: controller.tabPageController,
              onPageChanged: controller.onTabChanged,
              children: [
                RepaintBoundary(child: _buildForm()),
                RepaintBoundary(child: _buildDaftar()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
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
                    Text('Bahan Baku',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(color: Colors.black, offset: Offset(2, 2))
                            ])),
                    const SizedBox(height: 2),
                    Text('Kelola stok bahan produksi',
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

  // ============================================================
  // TABS
  // ============================================================
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
          SizedBox(width: 140, child: _tabButton(0, 'Tambah Bahan')),
          const SizedBox(width: 4),
          SizedBox(width: 140, child: _tabButton(1, 'Daftar Bahan')),
        ],
      ),
    );
  }

  Widget _tabButton(int index, String label) {
    return Obx(() {
      final active = controller.selectedTabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeTab(index),
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

  // ============================================================
  // TAB 1: DAFTAR BAHAN
  // ============================================================
  Widget _buildDaftar() {
    return Column(
      children: [
        // SEARCH + FILTER
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: appBorder(),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: AppColors.muted, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: controller.onSearchChanged,
                          style: GoogleFonts.inter(fontSize: 13),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            isCollapsed: true,
                            hintText: 'Cari bahan...',
                            hintStyle: GoogleFonts.inter(
                                color: AppColors.muted, fontSize: 13),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Tombol filter (selalu kuning)
              GestureDetector(
                onTap: _showFilterSheet,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.yellow, // ✅ Selalu kuning
                    borderRadius: BorderRadius.circular(14),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2), // ✅ Shadow brutalism
                  ),
                  child: Icon(Icons.filter_list_rounded,
                      color: AppColors.ink, // ✅ Icon hitam
                      size: 22),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // SUMMARY CHIPS (brutalism style)
// SUMMARY CHIPS (dengan warna SOLID cerah)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => Row(
                children: ['Aman', 'Menipis', 'Habis'].map((s) {
                  final active = controller.filterStatus.value == s;
                  final baseColor = _statusColor(s);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          controller.filterStatus.value = active ? 'Semua' : s,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          // Background: warna solid cerah
                          color: baseColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.ink,
                            width: 2,
                          ),
                          boxShadow: AppShadows.hard(2),
                        ),
                        child: Column(
                          children: [
                            Text('${controller.countStatus(s)}',
                                style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900)),
                            Text(s,
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ),
        const SizedBox(height: 14),

        // SECTION HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('STOK BAHAN BAKU',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: appBorder(1.5),
                ),
                child: Text('${controller.bahanList.length} bahan',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // LIST + FOOTER
        Expanded(
          child: Obx(() {
            final list = controller.filteredBahan;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text('Bahan tidak ditemukan',
                        style: GoogleFonts.inter(
                            color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              children: [
                // Semua cards
                ...List.generate(
                  list.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildBahanCard(list[i]),
                  ),
                ),
                // FOOTER: Text info
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Text('Tap card untuk lihat detail & restock',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: AppColors.muted, fontSize: 10)),
                ),
                // FOOTER: Branding
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('OMG COFFEE · COFFEE KELILING',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

// Ganti method _statusColor dengan warna yang lebih cerah
// Ganti method _statusColor dengan warna yang LEBIH CERAH
  Color _statusColor(String s) => s == 'Aman'
      ? const Color(0xFF66BB6A) // Hijau terang
      : s == 'Menipis'
          ? const Color(0xFFFFCA28) // Kuning terang
          : const Color(0xFFEF5350); // Merah terang

  // ============================================================
  // BAHAN CARD (BRUTALISM STYLE)
  // ============================================================
  Widget _buildBahanCard(Map<String, dynamic> b) {
    final status = controller.statusBahan(b);
    final color = _statusColor(status);

    return GestureDetector(
      onTap: () => _showDetailSheet(b),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(4),
        ),
        child: Row(
          children: [
            // Icon Kategori (BULAT dengan border hitam TEBAL)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.ink, // Hitam eksplisit
                  width: 2, // Lebih tebal
                ),
              ),
              child: Icon(controller.iconKategori(b['kategori'] as String),
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text((b['nama'] as String),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                      ),
                      // Badge Status di kanan
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color,
                            width: 2,
                          ),
                        ),
                        child: Text(status,
                            style: GoogleFonts.inter(
                                color: color,
                                fontSize: 9,
                                fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Teks stok dan kategori warna PINK
                  Text(
                      '${controller.formatStok((b['stok'] as num).toDouble())} ${b['unit']} · ${b['kategori']}',
                      style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                      'Min: ${controller.formatStok((b['stokMin'] as num).toDouble())} ${b['unit']} · Rp ${controller.formatRupiah(b['harga'] as int)}/${b['unit']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          color: AppColors.muted, fontSize: 9)),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.ink, size: 22),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM SHEET: DETAIL BAHAN
  // ============================================================
  void _showDetailSheet(Map<String, dynamic> b) {
    Get.bottomSheet(
      _DetailBahanSheet(bahan: b),
      isScrollControlled: true,
    );
  }

  // ============================================================
  // BOTTOM SHEET: FILTER
  // ============================================================
  void _showFilterSheet() {
    final kategoriOpts = ['Semua', ...controller.kategoriOptions];
    final statusOpts = ['Semua', 'Aman', 'Menipis', 'Habis'];

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
            const SizedBox(height: 12),
            Text('Filter Bahan',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Text('Status',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: statusOpts.map((s) {
                    final selected = controller.filterStatus.value == s;
                    return GestureDetector(
                      onTap: () => controller.filterStatus.value = s,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.primary : AppColors.appWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: appBorder(1.5),
                        ),
                        child: Text(s,
                            style: GoogleFonts.inter(
                                color: selected ? Colors.white : AppColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w800)),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 16),
            Text('Kategori',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kategoriOpts.map((k) {
                    final selected = controller.filterKategori.value == k;
                    return GestureDetector(
                      onTap: () => controller.filterKategori.value = k,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              selected ? AppColors.primary : AppColors.appWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: appBorder(1.5),
                        ),
                        child: Text(k,
                            style: GoogleFonts.inter(
                                color: selected ? Colors.white : AppColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w800)),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.filterStatus.value = 'Semua';
                      controller.filterKategori.value = 'Semua';
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.ink, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Reset',
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              const BorderSide(color: AppColors.ink, width: 2)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Terapkan',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ============================================================
// TAB 0: FORM TAMBAH BAHAN (DESAIN BARU)
// ============================================================
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // INFO CARD
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.brandGreen, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.restaurant_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KHUSUS BAHAN BAKU',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w800)),
                      Text('Masuk Resep Menu & hitungan HPP otomatis',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // PILIH KATEGORI BAHAN
          Text('PILIH KATEGORI BAHAN',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          _buildCategoryButton('Kopi', Icons.coffee_rounded, true),
          const SizedBox(height: 8),
          _buildCategoryButton(
              'Susu & Dairy', Icons.local_drink_rounded, false),
          const SizedBox(height: 8),
          _buildCategoryButton('Pemanis', Icons.grain_rounded, false),
          const SizedBox(height: 8),
          _buildCategoryButton(
              'Topping & Bubuk', Icons.water_drop_rounded, false),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text('+ Kategori Lain',
                      style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // NAMA BAHAN
          Text('NAMA BAHAN',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
            ),
            child: TextField(
              controller: controller.namaController,
              style:
                  GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Contoh: Kopi Bubuk Arabica',
                hintStyle:
                    GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
                suffixIcon: const Icon(Icons.edit_rounded,
                    color: AppColors.primary, size: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // SATUAN UNIT
          Text('SATUAN UNIT',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.unitOptions.map((u) {
                  final selected = controller.unit.value == u;
                  return GestureDetector(
                    onTap: () => controller.selectUnit(u),
                    child: Container(
                      width: 100,
                      height: 44,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.brandGreen
                            : AppColors.appWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: appBorder(1.5),
                      ),
                      child: Center(
                        child: Text(u,
                            style: GoogleFonts.inter(
                                color: selected ? Colors.white : AppColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 20),

          // STOK SAAT INI & MINIMUM
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STOK SAAT INI',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _buildStokInputWithUnit(controller.stokController, '3'),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _buildStokInputWithUnit(controller.stokMinController, '2'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // TOTAL HARGA BELI (YELLOW CARD)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('TOTAL HARGA BELI',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppColors.ink, size: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Total uang yang dibayarkan untuk stok di atas',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.ink, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rp 255.000',
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900)),
                            Text('(untuk 3 kg)',
                                style: GoogleFonts.inter(
                                    color: AppColors.muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('Hasil hitungan per satuan:',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.ink, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Menjadi Rp 85.000/kg',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // HPP DASAR BUTTON
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
            ),
            child: Row(
              children: [
                Text('Rp 255.000 ÷ 3 kg = Rp 85.000/kg',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.brandGreen, width: 1.5),
                  ),
                  child: Text('HPP DASAR',
                      style: GoogleFonts.inter(
                          color: AppColors.brandGreen,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // KALKULASI OTOMATIS (GREEN CARD)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.brandGreen, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calculate_rounded,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text('KALKULASI OTOMATIS',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ink, width: 1.5),
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
                    border: Border.all(color: AppColors.ink, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('HARGA SATUAN TERKECIL',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.brandGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppColors.brandGreen, width: 1),
                            ),
                            child: Text('Per Gram',
                                style: GoogleFonts.inter(
                                    color: AppColors.brandGreen,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Rp 85 / gram',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text('Rp 85.000 ÷ 1.000 gr = Rp 85/gr',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                    'Dihitung otomatis oleh sistem saat kamu memasukkan harga beli. Nilai ini akan otomatis dipakai untuk hitung HPP di Resep Menu.',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SUPPLIER (OPSIONAL)
          Text('SUPPLIER (OPSIONAL)',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
            ),
            child: TextField(
              controller: controller.supplierController,
              style:
                  GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Contoh: Koperasi Gayo',
                hintStyle:
                    GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
                suffixIcon: const Icon(Icons.store_rounded,
                    color: AppColors.primary, size: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // AKTIF DIGUNAKAN
          Container(
            padding: const EdgeInsets.all(14),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('Bahan akan muncul di daftar distribusi',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Obx(() => GestureDetector(
                      onTap: () =>
                          controller.toggleAktifForm(!controller.aktif.value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 32,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: controller.aktif.value
                              ? AppColors.brandGreen
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                          border: appBorder(1.5),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: controller.aktif.value
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // FOOTER BRANDING
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
              onPressed: controller.simpanBahan,
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
                  Text('Simpan Bahan',
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

// Helper untuk button kategori
  Widget _buildCategoryButton(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B4513) : AppColors.appWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

// Helper untuk input stok dengan unit badge
  Widget _buildStokInputWithUnit(
      TextEditingController textController, String value) {
    return Obx(() => Container(
          height: 52,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(12),
            border: appBorder(),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller:
                      textController, // ✅ Gunakan textController di sini
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w800),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withOpacity(0.3),
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(12)),
                ),
                child: Center(
                  // ✅ Sekarang 'controller' merujuk ke BahanBakuController, bukan TextEditingController
                  child: Text(controller.unit.value,
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ));
  }
}

// ============================================================
// SHEET DETAIL BAHAN (restock + hapus) - BRUTALISM STYLE
// ============================================================
class _DetailBahanSheet extends StatefulWidget {
  final Map<String, dynamic> bahan;

  const _DetailBahanSheet({required this.bahan});

  @override
  State<_DetailBahanSheet> createState() => _DetailBahanSheetState();
}

class _DetailBahanSheetState extends State<_DetailBahanSheet> {
  final _restockController = TextEditingController();

  @override
  void dispose() {
    _restockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BahanBakuController>();
    final b = widget.bahan;
    final status = c.statusBahan(b);
    final color = status == 'Aman'
        ? AppColors.brandGreen
        : status == 'Menipis'
            ? const Color(0xFFFFB800)
            : const Color(0xFFD32F2F);

    return Container(
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.ink,
                    width: 2,
                  ),
                ),
                child: Icon(c.iconKategori(b['kategori'] as String),
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((b['nama'] as String),
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text('${b['kategori']} · ${b['unit']}',
                        style: GoogleFonts.inter(
                            color: AppColors.muted, fontSize: 10)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color, width: 2),
                ),
                child: Text(status,
                    style: GoogleFonts.inter(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _infoRow('Stok saat ini',
              '${c.formatStok((b['stok'] as num).toDouble())} ${b['unit']}'),
          _infoRow('Stok minimum',
              '${c.formatStok((b['stokMin'] as num).toDouble())} ${b['unit']}'),
          _infoRow(
              'Harga', 'Rp ${c.formatRupiah(b['harga'] as int)}/${b['unit']}'),
          _infoRow('Supplier', '${b['supplier']}'),
          const SizedBox(height: 16),

          // RESTOCK CEPAT
          Text('Restock cepat',
              style:
                  GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
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
                  ),
                  child: TextField(
                    controller: _restockController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(7),
                    ],
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isCollapsed: true,
                      hintText: 'Jumlah tambah stok',
                      hintStyle: GoogleFonts.inter(
                          color: AppColors.muted, fontSize: 11),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_restockController.text.isEmpty) return;
                  c.restockBahan(b, double.parse(_restockController.text));
                  Get.back();
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(1.5),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: Center(
                    child: Text('+ Stok',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // HAPUS
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => c.hapusBahan(b),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD32F2F),
                side: const BorderSide(
                    color: const Color(0xFFD32F2F), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delete_outline_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text('Hapus Bahan',
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
          Text(value,
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
