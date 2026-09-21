import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/resep_menu_controller.dart';

class ResepMenuView extends GetView<ResepMenuController> {
  const ResepMenuView({super.key});

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
                    Text('Resep Menu',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(color: Colors.black, offset: Offset(2, 2))
                            ])),
                    const SizedBox(height: 2),
                    Text('Kelola resep dan HPP menu',
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
          SizedBox(width: 140, child: _tabButton(0, 'Buat Resep')),
          const SizedBox(width: 4),
          SizedBox(width: 140, child: _tabButton(1, 'Daftar Resep')),
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

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PILIH MENU',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showPilihMenuSheet,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(16),
                border: appBorder(),
                boxShadow: AppShadows.hard(3),
              ),
              child: Column(
                children: [
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          border: appBorder(1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_drink_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                  controller.selectedMenu.value.isEmpty
                                      ? 'Es Kopi Susu'
                                      : controller.selectedMenu.value,
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.white, size: 24),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          border: appBorder(),
                        ),
                        child: const Icon(Icons.image_rounded,
                            color: AppColors.muted, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text('Rp ${controller.hargaJual.value}',
                                style: GoogleFonts.inter(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800))),
                            Text('Harga per porsi',
                                style: GoogleFonts.inter(
                                    color: AppColors.muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Obx(() => Text(controller.kategoriMenu.value,
                            style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.w700))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('BAHAN BAKU',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ink, width: 1.5),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: AppColors.ink, size: 10),
              ),
              const Spacer(),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: appBorder(1.5),
                    ),
                    child: Text('${controller.bahanResepList.length} bahan',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Column(
                children: controller.bahanResepList.map((bahan) {
                  return _buildBahanCard(bahan, true);
                }).toList(),
              )),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              painter: _DashedRRectPainter(AppColors.ink, 14),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.ink, size: 20),
                    const SizedBox(width: 8),
                    Text('Tambah Bahan',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('BAHAN OPERASIONAL',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: appBorder(1.5),
                    ),
                    child: Text(
                        '${controller.barangPelengkapList.length} barang',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  )),
            ],
          ),
          Text('Bukan bahan baku — dihitung sebagai biaya per porsi',
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(() => Column(
                children: controller.barangPelengkapList.map((barang) {
                  return _buildBahanCard(barang, false);
                }).toList(),
              )),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              painter: _DashedRRectPainter(AppColors.ink, 14),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.ink, size: 20),
                    const SizedBox(width: 8),
                    Text('Tambah Barang',
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(16),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Pengaturan Biaya',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: appBorder(1.5),
                      ),
                      child: Text('OPSIONAL',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppColors.ink, size: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Sesuaikan rumus HPP dengan kebiasaan usahamu',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF1A1A1A), width: 2),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFF1A1A1A),
                                offset: Offset(3, 3),
                                blurRadius: 0)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('BUANG SISA',
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFF1A1A1A),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text('SPILL',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xFF1A1A1A),
                                          width: 2),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            '${controller.buangSisa.value}',
                                        hintStyle: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (val) {
                                        final cleanVal = val.replaceAll(
                                            RegExp(r'[^0-9]'), '');
                                        controller.buangSisa.value =
                                            cleanVal.isNotEmpty
                                                ? int.parse(cleanVal)
                                                : 0;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A6F43),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFF1A1A1A),
                                        width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('%',
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8F0),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF1A1A1A), width: 2),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFF1A1A1A),
                                offset: Offset(3, 3),
                                blurRadius: 0)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('BIAYA LAIN',
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFF1A1A1A),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text('GAS/CUP',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFC94D),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFF1A1A1A),
                                        width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Rp',
                                      style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xFF1A1A1A),
                                          width: 2),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            '${controller.biayaLain.value}',
                                        hintStyle: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                      ),
                                      onChanged: (val) {
                                        final cleanVal = val.replaceAll(
                                            RegExp(r'[^0-9]'), '');
                                        controller.biayaLain.value =
                                            cleanVal.isNotEmpty
                                                ? int.parse(cleanVal)
                                                : 0;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(16),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('TOTAL HPP RESEP',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w900)),
                    const Spacer(),
                    Container(
                      width: 22,
                      height: 22,
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
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHppRow('Bahan resep',
                            'Rp ${controller.totalBahanResep.toInt()}'),
                        _buildHppRow('Barang pelengkap',
                            'Rp ${controller.totalBarangPelengkap.toInt()}'),
                        _buildHppRow(
                            'Buang sisa ${controller.buangSisa.value}%',
                            '+ Rp ${controller.totalBuangSisa.toInt()}',
                            isPlus: true),
                        const Divider(height: 24, thickness: 1.5),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('HPP FINAL',
                                      style: GoogleFonts.inter(
                                          color: AppColors.ink,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text('per cup',
                                      style: GoogleFonts.inter(
                                          color: AppColors.muted,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Text('Rp ${controller.hppFinal.toInt()}',
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Harga Jual: Rp ${controller.hargaJual.value}',
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.brandGreen,
                                borderRadius: BorderRadius.circular(8),
                                border: appBorder(1.5),
                              ),
                              child: Text('+${controller.margin.toInt()}%',
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 12),
                Text(
                    'HPP = bahan + barang pelengkap + buang sisa + biaya lain (opsional)',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('OMG COFFEE · COFFEE KELILING',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.simpanResep,
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
                  Text('Simpan Resep Menu',
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

  // ============================================================
  // TAB 2: DAFTAR RESEP
  // ============================================================
  Widget _buildDaftar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

                    // border dan boxShadow sudah dihapus
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: AppColors.ink, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Cari nama menu...',
                            hintStyle: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC94D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
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
            ],
          ),

          ///...
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    value: '6',
                    label: 'RESEP\nTERSIMPAN',
                    valueColor: AppColors.ink,
                    icon: null,
                  ),
                ),
                Container(
                    width: 1,
                    height: 40,
                    color: AppColors.ink.withValues(alpha: 0.3)),
                Expanded(
                  child: _buildSummaryItem(
                    value: '+43%',
                    label: 'RATA-RATA\nMARGIN',
                    valueColor: AppColors.brandGreen,
                    icon: null,
                  ),
                ),
                Container(
                    width: 1,
                    height: 40,
                    color: AppColors.ink.withValues(alpha: 0.3)),
                Expanded(
                  child: _buildSummaryItem(
                    value: '2',
                    label: 'PERLU\nPERHATIAN',
                    valueColor: const Color(0xFFFFB800),
                    icon: Icons.warning_amber_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: [
              _buildRecipeCard(
                name: 'Es Kopi Susu',
                category: 'KOPI',
                variant: 'Varian Dingin • 16oz',
                bahanCount: 3,
                barangCount: 3,
                hpp: 7369,
                jual: 18000,
                margin: 59,
                marginStatus: 'normal',
              ),
              _buildRecipeCard(
                name: 'Kopi Hitam',
                category: 'KOPI',
                variant: 'Americano Panas/Dingin',
                bahanCount: 2,
                barangCount: 2,
                hpp: 3200,
                jual: 8000,
                margin: 60,
                marginStatus: 'normal',
              ),
              _buildRecipeCard(
                name: 'Es Coklat',
                category: 'NON-KOPI',
                variant: 'Coklat Premium & Creamer',
                bahanCount: 3,
                barangCount: 3,
                hpp: 6100,
                jual: 10000,
                margin: 39,
                marginStatus: 'normal',
              ),
              _buildRecipeCard(
                name: 'Matcha Latte',
                category: 'NON-KOPI',
                variant: 'Pure Uji Matcha & Fresh Milk',
                bahanCount: 3,
                barangCount: 3,
                hpp: 9400,
                jual: 12000,
                margin: 22,
                marginStatus: 'tipis',
              ),
              _buildRecipeCard(
                name: 'Es Teh Jumbo',
                category: 'NON-KOPI',
                variant: 'Teh Melati Solo 22oz',
                bahanCount: 2,
                barangCount: 2,
                hpp: 4800,
                jual: 5000,
                margin: 4,
                marginStatus: 'kritis',
              ),
              _buildRecipeCard(
                name: 'Kopi Pandan',
                category: 'KOPI',
                variant: 'Espresso, Pandan & Milk',
                bahanCount: 3,
                barangCount: 3,
                hpp: 7200,
                jual: 15000,
                margin: 52,
                marginStatus: 'normal',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFFFB800), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2 menu margin tipis',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(
                          'Pertimbangkan menaikkan harga jual atau sesuaikan takaran resep agar target profit per porsi tetap terjaga.',
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

  Widget _buildSummaryItem({
    required String value,
    required String label,
    required Color valueColor,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value,
                  style: GoogleFonts.outfit(
                      color: valueColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w900)),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, color: valueColor, size: 18),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildRecipeCard({
    required String name,
    required String category,
    required String variant,
    required int bahanCount,
    required int barangCount,
    required int hpp,
    required int jual,
    required int margin,
    required String marginStatus,
  }) {
    final marginColor = marginStatus == 'kritis'
        ? const Color(0xFFD32F2F)
        : marginStatus == 'tipis'
            ? const Color(0xFFFFB800)
            : AppColors.brandGreen;

    final marginLabel = marginStatus == 'kritis'
        ? 'KRITIS'
        : marginStatus == 'tipis'
            ? 'TIPIS'
            : null;

    final IconData menuIcon = category.toLowerCase() == 'kopi'
        ? Icons.coffee_rounded
        : Icons.local_drink_rounded;

    final Color iconColor = category.toLowerCase() == 'kopi'
        ? const Color(0xFF7F4827)
        : const Color(0xFF3A6F43);

    final Color iconTint = category.toLowerCase() == 'kopi'
        ? const Color(0xFFF1E4DA)
        : const Color(0xFFE3EEE5);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconTint,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Icon(menuIcon, color: iconColor, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: marginColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: marginColor, width: 1.5),
                ),
                child: Text(
                  marginLabel != null
                      ? '+${margin}% $marginLabel'
                      : '+${margin}%',
                  style: GoogleFonts.inter(
                      color: marginColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.primary, width: 1.2),
                ),
                child: Text(category,
                    style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 7,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(variant,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('$bahanCount bahan • $barangCount barang',
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D6),
              borderRadius: BorderRadius.circular(8),
              border: appBorder(1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('HPP',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w700)),
                Text('Rp ${_formatRupiah(hpp)}',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: appBorder(1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('JUAL',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w700)),
                Text('Rp ${_formatRupiah(jual)}',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.ink, width: 1.5),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Resep',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBahanCard(Map<String, dynamic> item, bool isBahan) {
    final kategori = item['kategori'] as String? ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF1A1A1A),
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconKategori(kategori),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sisa: ${item['sisa']}',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => isBahan
                    ? controller
                        .hapusBahan(controller.bahanResepList.indexOf(item))
                    : controller.hapusBarang(
                        controller.barangPelengkapList.indexOf(item)),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
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
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: const Color(0xFF1A1A1A), width: 1.5),
                ),
                child: Text(
                  '= Rp ${_formatRupiah(item['harga'] as int)}',
                  softWrap: false,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => controller.decrementQty(
                        isBahan
                            ? controller.bahanResepList.indexOf(item)
                            : controller.barangPelengkapList.indexOf(item),
                        isBahan,
                      ),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF1A1A1A), width: 1.5),
                        ),
                        child: const Icon(Icons.remove_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 32),
                      child: Text(
                        '${item['qty']}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1A1A1A),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.incrementQty(
                        isBahan
                            ? controller.bahanResepList.indexOf(item)
                            : controller.barangPelengkapList.indexOf(item),
                        isBahan,
                      ),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFF1A1A1A), width: 1.5),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A6F43),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF1A1A1A), width: 1.5),
                      ),
                      child: Text(
                        item['unit'] as String,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconKategori(String kategori) {
    final colors = _getChipColors(kategori);
    final icon = _getIconForKategori(kategori);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.tint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A1A1A), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF1A1A1A),
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, color: colors.icon, size: 22),
    );
  }

  _ChipColors _getChipColors(String kategori) {
    final k = kategori.toLowerCase();
    if (k.contains('kopi'))
      return const _ChipColors(
          tint: Color(0xFFF1E4DA), icon: Color(0xFF7F4827));
    if (k.contains('coklat'))
      return const _ChipColors(
          tint: Color(0xFFF1E4DA), icon: Color(0xFF7F4827));
    if (k.contains('susu') || k.contains('dairy'))
      return const _ChipColors(
          tint: Color(0xFFFFF3D6), icon: Color(0xFFF59E0B));
    if (k.contains('pemanis'))
      return const _ChipColors(
          tint: Color(0xFFF1E4DA), icon: Color(0xFF7F4827));
    if (k.contains('topping') || k.contains('bubuk'))
      return const _ChipColors(
          tint: Color(0xFFE3EEE5), icon: Color(0xFF3A6F43));
    if (k.contains('kemasan'))
      return const _ChipColors(
          tint: Color(0xFFFFE1EE), icon: Color(0xFFEF2B7C));
    if (k.contains('energi') || k.contains('bbm'))
      return const _ChipColors(
          tint: Color(0xFFFEF3C7), icon: Color(0xFFF59E0B));
    return const _ChipColors(tint: Color(0xFFE3EEE5), icon: Color(0xFF3A6F43));
  }

  IconData _getIconForKategori(String kategori) {
    final k = kategori.toLowerCase();
    if (k.contains('kopi')) return Icons.coffee_rounded;
    if (k.contains('coklat')) return Icons.cookie_rounded;
    if (k.contains('susu') || k.contains('dairy'))
      return Icons.water_drop_rounded;
    if (k.contains('pemanis')) return Icons.grain_rounded;
    if (k.contains('topping') || k.contains('bubuk')) return Icons.eco_rounded;
    if (k.contains('kemasan')) return Icons.inventory_2_rounded;
    if (k.contains('energi') || k.contains('bbm'))
      return Icons.local_fire_department_rounded;
    return Icons.category_rounded;
  }

  String _formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  Widget _buildHppRow(String label, String value, {bool isPlus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          Text(value,
              style: GoogleFonts.inter(
                  color: isPlus ? AppColors.brandGreen : AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  void _showPilihMenuSheet() {
    final daftarMenu = [
      {'nama': 'Es Kopi Susu', 'kategori': 'Kopi', 'harga': 18000},
      {'nama': 'Es Kopi Gula Aren', 'kategori': 'Kopi', 'harga': 20000},
      {'nama': 'Es Matcha Latte', 'kategori': 'Non-Kopi', 'harga': 22000},
      {'nama': 'Es Coklat', 'kategori': 'Non-Kopi', 'harga': 18000},
      {'nama': 'Es Teh Manis', 'kategori': 'Non-Kopi', 'harga': 10000},
    ];

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
            Text('Pilih Menu',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView(
                children: daftarMenu.map((menu) {
                  final isSelected =
                      controller.selectedMenu.value == menu['nama'];
                  return GestureDetector(
                    onTap: () {
                      controller.selectedMenu.value = menu['nama'] as String;
                      controller.hargaJual.value = menu['harga'] as int;
                      controller.kategoriMenu.value =
                          menu['kategori'] as String;
                      Get.back();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primary : AppColors.appWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: appBorder(1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_drink_rounded,
                              color:
                                  isSelected ? Colors.white : AppColors.primary,
                              size: 22),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(menu['nama'] as String,
                                    style: GoogleFonts.inter(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.ink,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 2),
                                Text(
                                    'Rp ${menu['harga']} · ${menu['kategori']}',
                                    style: GoogleFonts.inter(
                                        color: isSelected
                                            ? Colors.white70
                                            : AppColors.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _ChipColors {
  final Color tint;
  final Color icon;
  const _ChipColors({required this.tint, required this.icon});
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
