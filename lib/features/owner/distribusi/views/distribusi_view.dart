// PATH FILE: lib/features/owner/distribusi/views/distribusi_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/distribusi_controller.dart';

class DistribusiView extends GetView<DistribusiController> {
  const DistribusiView({super.key});

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
                RepaintBoundary(child: _buildRiwayat()),
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
                    Text('Distribusi',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(color: Colors.black, offset: Offset(2, 2))
                            ])),
                    const SizedBox(height: 2),
                    Text('Catat & rekap serah terima barang',
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
          SizedBox(width: 140, child: _tabButton(0, 'Buat Distribusi')),
          const SizedBox(width: 4),
          SizedBox(width: 140, child: _tabButton(1, 'Riwayat')),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKaryawanCard(),
          const SizedBox(height: 12),
          _buildTanggalCard(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Item Distribusi',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: appBorder(1.5),
                    ),
                    child: Text('${controller.distribusiItems.length} item',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800)),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Column(
                children: List.generate(
                    controller.distribusiItems.length,
                    (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildItemCard(i),
                        )),
              )),
          _buildTambahItem(),
          const SizedBox(height: 16),
          Text('CATATAN (OPSIONAL)',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
            ),
            child: TextField(
              controller: controller.catatanController,
              maxLines: 2,
              style: GoogleFonts.inter(fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                hintText: 'Contoh: Susu nya jangan lupa di tutup',
                hintStyle:
                    GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.simpanDistribusi,
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
                  Text('Simpan Distribusi',
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

  Widget _buildKaryawanCard() {
    return Obx(() {
      final k = controller.karyawanList[controller.selectedKaryawanIndex.value];
      final nama = (k['nama'] ?? 'U').toString();
      final role = (k['role'] ?? 'Driver').toString();
      final detail = (k['detail'] ?? 'Gerobak 01 · ID #DST-01').toString();

      return GestureDetector(
        onTap: _showKaryawanSheet,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(16),
            border: appBorder(),
            boxShadow: AppShadows.hard(4),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                  border: appBorder(),
                ),
                child: Center(
                  child: Text(nama.isNotEmpty ? nama[0].toUpperCase() : 'U',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(nama,
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.brandGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.brandGreen, width: 1),
                          ),
                          child: Text(role,
                              style: GoogleFonts.inter(
                                  color: AppColors.brandGreen,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(detail,
                        style: GoogleFonts.inter(
                            color: AppColors.muted, fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.ink, size: 22),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTanggalCard() {
    return GestureDetector(
      onTap: controller.pickTanggal,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(4),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: appBorder(1.5),
              ),
              child: const Icon(Icons.calendar_month_rounded,
                  color: AppColors.brandGreen, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TANGGAL DISTRIBUSI',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Obx(() => Text(controller.tanggalFormatted,
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(int i) {
    return Obx(() {
      final item = controller.distribusiItems[i]['item'] as String;
      final unit = controller.distribusiItems[i]['unit'] as String;
      final kategori = controller.getKategori(item);
      final kategoriColor = controller.getKategoriColor(kategori);

      return Container(
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(4),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kategoriColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: appBorder(1.5),
                    ),
                    child: Icon(controller.getKategoriIcon(kategori),
                        color: kategoriColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: kategoriColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kategoriColor, width: 1),
                          ),
                          child: Text(kategori.toUpperCase(),
                              style: GoogleFonts.inter(
                                  color: kategoriColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 4),
                        Text(item,
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.hapusItem(i),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: const Icon(Icons.delete_outline_rounded,
                          color: AppColors.primary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 10,
                child: CustomPaint(
                  painter:
                      _DashedHLinePainter(AppColors.muted.withOpacity(0.4)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Satuan: $unit',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.decrementQty(i),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: const Icon(Icons.remove_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: Center(
                        child: TextField(
                          controller: controller.distribusiItems[i]
                              ['qtyController'] as TextEditingController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [_RibuanFormatter()],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              height: 1.0),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            hintText: '0',
                            hintStyle:
                                TextStyle(color: Colors.grey, height: 1.0),
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.incrementQty(i),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTambahItem() {
    return GestureDetector(
      onTap: _showTambahItemSheet,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6D3),
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
        ),
        child: CustomPaint(
          painter: _DashedRRectPainter(AppColors.ink, 12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    shape: BoxShape.circle,
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: AppColors.ink, size: 18),
                ),
                const SizedBox(width: 8),
                Text('Tambah Item',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            hintText: 'Cari karyawan...',
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
              GestureDetector(
                onTap: _showFilterSheet,
                child: Obx(() {
                  final active = controller.filterStatus.value != 'Semua';
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: active ? AppColors.yellow : AppColors.appWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: appBorder(),
                      boxShadow: active ? AppShadows.hard(3) : [],
                    ),
                    child: Icon(Icons.filter_list_rounded,
                        color: active ? AppColors.ink : AppColors.primary,
                        size: 22),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Obx(() {
            final list = controller.filteredRiwayat;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text('Riwayat tidak ditemukan',
                        style: GoogleFonts.inter(
                            color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final r = list[i];
                final label = controller.tanggalLabel(r['tanggal'] as DateTime);
                final prevLabel = i == 0
                    ? null
                    : controller
                        .tanggalLabel(list[i - 1]['tanggal'] as DateTime);
                final showHeader = label != prevLabel;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) ...[
                      Text(label,
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 10),
                    ],
                    _buildRiwayatCard(r),
                    const SizedBox(height: 14),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRiwayatCard(Map<String, dynamic> r) {
    final status = r['status'] as String;
    final statusColor = status == 'Sukses'
        ? AppColors.brandGreen
        : status == 'Proses'
            ? AppColors.yellow
            : AppColors.primary;

    return GestureDetector(
      onTap: () => _showDetailSheet(r),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(4),
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
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                    border: appBorder(),
                  ),
                  child: Center(
                    child: Text(
                        ((r['nama'] ?? 'U').toString().isNotEmpty
                                ? (r['nama'] as String)[0]
                                : 'U')
                            .toUpperCase(),
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text((r['nama'] ?? '').toString(),
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: statusColor, width: 1.5),
                            ),
                            child: Text(status,
                                style: GoogleFonts.inter(
                                    color: statusColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded,
                              color: AppColors.muted, size: 12),
                          const SizedBox(width: 4),
                          Text((r['waktu'] ?? '').toString(),
                              style: GoogleFonts.inter(
                                  color: AppColors.muted, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.ink, size: 22),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (r['items'] as List)
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.ink, width: 1),
                        ),
                        child: Text(e.toString(),
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w700)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showKaryawanSheet() {
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
            Text('Pilih Karyawan',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: List.generate(controller.karyawanList.length, (i) {
                    final k = controller.karyawanList[i];
                    final active = controller.selectedKaryawanIndex.value == i;
                    return GestureDetector(
                      onTap: () => controller.selectKaryawan(i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              active ? AppColors.primary : AppColors.appWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: appBorder(),
                          boxShadow: active ? AppShadows.hard(2) : [],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                                border: appBorder(),
                              ),
                              child: Center(
                                child: Text(
                                    ((k['nama'] ?? 'U').toString().isNotEmpty
                                            ? (k['nama'] as String)[0]
                                            : 'U')
                                        .toUpperCase(),
                                    style: GoogleFonts.inter(
                                        color: AppColors.ink,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(k['nama'] ?? '',
                                  style: GoogleFonts.inter(
                                      color:
                                          active ? Colors.white : AppColors.ink,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800)),
                            ),
                            if (active)
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                )),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
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
            Text('Filter Status',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: ['Semua', 'Sukses', 'Proses']
                      .map((s) => GestureDetector(
                            onTap: () => controller.setFilterStatus(s),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: controller.filterStatus.value == s
                                    ? AppColors.primary
                                    : AppColors.appWhite,
                                borderRadius: BorderRadius.circular(14),
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
                                          fontSize: 13,
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
    );
  }

  void _showDetailSheet(Map<String, dynamic> r) {
    final status = r['status'] as String;
    final statusColor = status == 'Sukses'
        ? AppColors.brandGreen
        : status == 'Proses'
            ? AppColors.yellow
            : AppColors.primary;

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
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                    border: appBorder(),
                  ),
                  child: Center(
                    child: Text(
                        ((r['nama'] ?? 'U').toString().isNotEmpty
                                ? (r['nama'] as String)[0]
                                : 'U')
                            .toUpperCase(),
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((r['nama'] ?? '').toString(),
                          style: GoogleFonts.inter(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(
                          '${controller.tanggalLabel(r['tanggal'] as DateTime)} • ${r['waktu']}',
                          style: GoogleFonts.inter(
                              color: AppColors.muted, fontSize: 10)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor, width: 1.5),
                  ),
                  child: Text(status,
                      style: GoogleFonts.inter(
                          color: statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text('Item Distribusi',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (r['items'] as List)
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.ink, width: 1),
                        ),
                        child: Text(e.toString(),
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w700)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text('Catatan',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text((r['catatan'] ?? '-').toString(),
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM SHEET: TAMBAH ITEM DISTRIBUSI
  // ============================================================
  void _showTambahItemSheet() {
    Get.bottomSheet(
      Container(
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
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 5,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Header (TANPA tombol X)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Tambah Item Distribusi',
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ),

            // Tabs (Revisi 1: Pink menutup sempurna)
// Tabs - SOLUSI FINAL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(
                    4), // ✅ Jarak 4px dari border container
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: appBorder(),
                ),
                child: Row(
                  children: [
                    // Tab BAHAN BAKU (aktif)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center, // ✅ Center sempurna
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // ✅ Wrap content
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inventory_2_rounded,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text('BAHAN BAKU',
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4), // ✅ Jarak antar tab
                    // Tab BARANG OPERASIONAL (tidak aktif)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center, // ✅ Center sempurna
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // ✅ Wrap content
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.category_rounded,
                                  color: AppColors.muted, size: 14),
                              const SizedBox(width: 4),
                              Text('BARANG OPERASIONAL',
                                  style: GoogleFonts.inter(
                                      color: AppColors.muted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Text('Pilih dari master data • stok terlihat real-time',
                  style:
                      GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Cari bahan atau barang...',
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

            // Section Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Text('BAHAN BAKU • STOK MASTER DATA',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.muted.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('4 tersedia',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

            // List Items
            Container(
              constraints: const BoxConstraints(maxHeight: 350),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMasterItemCard(
                    icon: Icons.water_drop_rounded,
                    iconColor: const Color(0xFF8B4513),
                    category: 'PEMANIS',
                    name: 'Gula Aren',
                    stock: '1,8 kg',
                    unit: 'satuan gram',
                    percentage: 72,
                    status: 'Aman',
                  ),
                  const SizedBox(height: 12),
                  _buildMasterItemCard(
                    icon: Icons.ac_unit_rounded,
                    iconColor: AppColors.brandGreen,
                    category: 'TOPPING',
                    name: 'Es Batu',
                    stock: '4 kg',
                    unit: 'satuan gram',
                    percentage: 85,
                    status: 'Aman',
                  ),
                  const SizedBox(height: 12),
                  _buildMasterItemCard(
                    icon: Icons.coffee_rounded,
                    iconColor: const Color(0xFF6B4F3A),
                    category: 'TOPPING',
                    name: 'Bubuk Matcha',
                    stock: '200 g',
                    unit: 'satuan gram',
                    percentage: 20,
                    status: 'Hampir Habis',
                    isCritical: true,
                  ),
                  const SizedBox(height: 12),
                  _buildMasterItemCard(
                    icon: Icons.inventory_2_rounded,
                    iconColor: AppColors.primary,
                    category: 'KOPI',
                    name: 'Kopi Bubuk',
                    stock: '2,5 kg',
                    unit: 'satuan gram',
                    percentage: 60,
                    status: 'Tercatat',
                    isAdded: true,
                  ),
                  const SizedBox(height: 12),
                  _buildMasterItemCard(
                    icon: Icons.local_drink_rounded,
                    iconColor: const Color(0xFF1A1A1A),
                    category: 'DAIRY',
                    name: 'Susu UHT',
                    stock: '0 L',
                    unit: 'satuan liter',
                    percentage: 0,
                    status: 'Habis',
                    isEmpty: true,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Info Note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.brandGreen.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jumlah distribusi dibatasi stok sistem',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('Tidak bisa melebihi stok tersedia (DV-08)',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: AppColors.ink, width: 2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text('SELESAI MEMILIH',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800)),
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

  // ============================================================
  // MASTER ITEM CARD (untuk bottom sheet tambah item)
  // ============================================================
  Widget _buildMasterItemCard({
    required IconData icon,
    required Color iconColor,
    required String category,
    required String name,
    required String stock,
    required String unit,
    required int percentage,
    required String status,
    bool isCritical = false,
    bool isAdded = false,
    bool isEmpty = false,
  }) {
    Color getStatusColor() {
      if (isEmpty) return Colors.grey;
      if (isCritical) return const Color(0xFFFFB800);
      return AppColors.brandGreen;
    }

    return Container(
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
          // BAGIAN ATAS: Icon + Info + Tombol TAMBAH (brutalism)
          Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: appBorder(1.5),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),

              // Info (Badge kategori + Nama)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(category,
                          style: GoogleFonts.inter(
                              color: iconColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    Text(name,
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),

              // Tombol TAMBAH (Revisi 6: Style Brutalism)
// Tombol TAMBAH (dengan logic stok habis)
              if (!isAdded)
                GestureDetector(
                  onTap: isEmpty
                      ? null
                      : () {
                          // TODO: Handle add item
                          print('Tambah $name');
                        },
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isEmpty
                          ? Colors.grey[400]
                          : AppColors.primary, // ✅ Abu-abu jika habis
                      borderRadius: BorderRadius.circular(10),
                      border: appBorder(1.5),
                      boxShadow: isEmpty
                          ? []
                          : AppShadows.hard(2), // ✅ No shadow jika habis
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          isEmpty
                              ? 'HABIS'
                              : 'TAMBAH', // ✅ Text berubah jika habis
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.muted.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Sudah Ditambah',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // GARIS PUTUS-PUTUS (Revisi 5: Separator)
          CustomPaint(
            painter: _DashedHLinePainter(AppColors.muted.withOpacity(0.4)),
            child: const SizedBox(height: 2),
          ),

          const SizedBox(height: 12),

          // BAGIAN BAWAH: Sub-card cream (Revisi 2)
// BAGIAN BAWAH: Sub-card cream (tanpa overflow)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF5EC), // Warna cream
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.muted.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('STOK TERSEDIA',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                // Row 1: Stok info + Status badge
                Row(
                  children: [
                    Expanded(
                      child: Text('Stok $stock • $unit',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(status,
                          style: GoogleFonts.inter(
                              color: getStatusColor(),
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                if (!isEmpty) ...[
                  const SizedBox(height: 8),
                  // Row 2: Progress bar + Persentase
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 6,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: percentage / 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: getStatusColor(),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('$percentage%',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HELPER CLASSES (DI LUAR class DistribusiView)
// ============================================================

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

class _DashedHLinePainter extends CustomPainter {
  final Color color;
  _DashedHLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
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

class _RibuanFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), '')
        .replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final limited = digits.length > 6 ? digits.substring(0, 6) : digits;
    final formatted = limited.isEmpty
        ? ''
        : int.parse(limited).toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
