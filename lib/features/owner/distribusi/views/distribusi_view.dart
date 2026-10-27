// PATH FILE: lib/features/owner/distribusi/views/distribusi_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            offset: const Offset(0, -20),
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

  Widget _buildAvatar(String? fotoUrl, String name, double size,
      {Color? bgColor, Color? textColor}) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final bg = bgColor ?? AppColors.appWhite;
    final fg = textColor ?? AppColors.ink;

    final fallback = Center(
      child: Text(
        letter,
        style: GoogleFonts.inter(
          color: fg,
          fontSize: size * 0.42,
          fontWeight: FontWeight.w900,
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: appBorder(),
      ),
      child: ClipOval(
        child: (fotoUrl == null || fotoUrl.isEmpty)
            ? fallback
            : CachedNetworkImage(
                imageUrl: fotoUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback,
                errorWidget: (_, __, ___) => fallback,
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 42),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Get.back();
                }
              },
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
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
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
            Expanded(child: _tabButton(0, 'Buat Distribusi')),
            const SizedBox(width: 6),
            Expanded(child: _tabButton(1, 'Riwayat')),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(int index, String label) {
    return Obx(() {
      final active = controller.selectedTabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.appWhite,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: active ? AppColors.ink : Colors.transparent, width: 2),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : AppColors.primary,
                    fontSize: 12,
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
          const SizedBox(height: 12),
          Obx(() {
            final bahanBakuIndices = <int>[];
            final operasionalIndices = <int>[];

            for (int i = 0; i < controller.distribusiItems.length; i++) {
              final it = controller.distribusiItems[i];
              final kat = (it['kategori'] as String?)?.toUpperCase() ??
                  controller.getKategoriKelompok(it['item'] as String);
              if (kat == 'BARANG OPERASIONAL' ||
                  kat == 'KEMASAN' ||
                  kat == 'OPERASIONAL') {
                operasionalIndices.add(i);
              } else {
                bahanBakuIndices.add(i);
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: BAHAN BAKU
                _buildSectionHeader('BAHAN BAKU', bahanBakuIndices.length),
                const SizedBox(height: 8),
                if (bahanBakuIndices.isEmpty)
                  _buildEmptySection('Belum ada bahan baku ditambahkan')
                else
                  ...bahanBakuIndices.map((i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildItemCard(i),
                      )),
                const SizedBox(height: 8),

                // Section 2: BARANG OPERASIONAL
                _buildSectionHeader(
                    'BARANG OPERASIONAL', operasionalIndices.length),
                const SizedBox(height: 8),
                if (operasionalIndices.isEmpty)
                  _buildEmptySection('Belum ada barang operasional ditambahkan')
                else
                  ...operasionalIndices.map((i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildItemCard(i),
                      )),
                const SizedBox(height: 4),
              ],
            );
          }),
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
      final fotoUrl = k['fotoUrl'] as String?;
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
              _buildAvatar(fotoUrl, nama, 48,
                  bgColor: AppColors.yellow, textColor: AppColors.ink),
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
                          decoration: const InputDecoration(
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
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFFFB800), // AppColors.yellow
          borderRadius: BorderRadius.circular(14),
          border: appBorder(),
          boxShadow: AppShadows.hard(3),
        ),
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
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(title,
            style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.muted.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('$count',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }

  Widget _buildEmptySection(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(12),
          border: appBorder(1),
        ),
        child: Text(message,
            style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  String _formatSectionDate(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(d.year, d.month, d.day);
    final dayStr = d.day.toString().padLeft(2, '0');
    final monthStr = DistribusiController.bulan[d.month - 1].toUpperCase();
    final yearStr = d.year.toString();
    final dateSuffix = '$dayStr $monthStr $yearStr';

    if (target == today) {
      return 'HARI INI, $dateSuffix';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'KEMARIN, $dateSuffix';
    } else {
      final dayName = DistribusiController.hari[d.weekday % 7].toUpperCase();
      return '$dayName, $dateSuffix';
    }
  }

  Widget _buildRiwayat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. BARIS SEARCH: field search + button filter PERSEGI KUNING SOLID (0xFFFFB800, border hitam, icon filter hitam)
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
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: AppColors.muted, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: controller.onSearchChanged,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.ink),
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
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800),
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2.5),
                  ),
                  child: const Icon(Icons.filter_list_rounded,
                      color: AppColors.ink, size: 22),
                ),
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
                final d = r['tanggal'] as DateTime;
                final label = _formatSectionDate(d);
                final prevLabel = i == 0
                    ? null
                    : _formatSectionDate(list[i - 1]['tanggal'] as DateTime);
                final showHeader = label != prevLabel;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. JUDUL SECTION: format "HARI INI, 04 SEPTEMBER 2026" / "KEMARIN, 03 SEPTEMBER 2026" — uppercase, muted, fontSize 9
                    if (showHeader) ...[
                      Padding(
                        padding:
                            EdgeInsets.only(top: i == 0 ? 0 : 8, bottom: 8),
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                    _buildRiwayatCard(r),
                    const SizedBox(height: 12),
                  ],
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // 3. CARD RIWAYAT (struktur wajib sesuai Figma)
  Widget _buildRiwayatCard(Map<String, dynamic> r) {
    final nama = (r['nama'] ?? 'U').toString();
    final fotoUrl = r['fotoUrl'] as String?;
    final waktu = (r['waktu'] ?? '').toString();
    final status = (r['status'] as String? ?? 'Proses').trim();
    final statusUpper = status.toUpperCase();
    final bool isSukses = statusUpper == 'SUKSES';
    final bool isProses = statusUpper == 'PROSES';
    final bool isGagal = statusUpper == 'GAGAL' || statusUpper == 'DIBATALKAN';

    Color statusBg;
    Color statusTextColor;
    Color statusBorderColor;

    if (isSukses) {
      statusBg = const Color(0xFFE8F5E9);
      statusTextColor = const Color(0xFF1E7E34);
      statusBorderColor = const Color(0xFF81C784);
    } else if (isProses) {
      statusBg = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFFB45309);
      statusBorderColor = const Color(0xFFFCD34D);
    } else {
      statusBg = const Color(0xFFFFEBEE);
      statusTextColor = const Color(0xFFC62828);
      statusBorderColor = const Color(0xFFEF9A9A);
    }

    final rawItems = (r['items'] as List?) ?? [];
    final itemsList = rawItems.map((e) => e.toString()).toList();
    final visibleItems = itemsList.take(2).toList();
    final extraCount = itemsList.length - 2;

    return GestureDetector(
      onTap: () => _showDetailSheet(r),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(3.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // a. Row atas: avatar lingkaran foto profile / inisial,
            // kolom: nama bold + jam dengan icon clock kecil di bawahnya,
            // pill status di kanan: SUKSES=hijau tint, PROSES=kuning tint, GAGAL=merah tint (teks uppercase kecil).
            Row(
              children: [
                _buildAvatar(fotoUrl, nama, 40,
                    bgColor: AppColors.appWhite, textColor: AppColors.ink),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.muted,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            waktu,
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusBorderColor, width: 1),
                  ),
                  child: Text(
                    statusUpper,
                    style: GoogleFonts.inter(
                      color: statusTextColor,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // b. Row chips item: warna chip selaras dengan kategori di tab buat distribusi
            // jika item >2 tampilkan chip abu "+N lainnya".
            // d. Card GAGAL: ganti baris chips dengan teks merah "Dibatalkan".
            if (isGagal)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  'Dibatalkan',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFC62828),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...visibleItems.map(
                    (itemStr) {
                      final cleanName = itemStr.split('(').first.trim();
                      final kat = controller.getKategori(cleanName);
                      final katColor = controller.getKategoriColor(kat);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: katColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: katColor, width: 1),
                        ),
                        child: Text(
                          itemStr,
                          style: GoogleFonts.inter(
                            color: katColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                  if (extraCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.ink, width: 1),
                      ),
                      child: Text(
                        '+$extraCount lainnya',
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 10),

            // Separator Garis Pemisah (Revisi 5)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                width: double.infinity,
                height: 6,
                child: CustomPaint(
                  painter:
                      _DashedHLinePainter(AppColors.muted.withOpacity(0.35)),
                ),
              ),
            ),
            const SizedBox(height: 6),

            // c. Row bawah: teks "Total: N bahan" muted di kiri + button
            // "Lihat Detail" putih border hitam radius 10 + icon chevron.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${itemsList.length} bahan',
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showDetailSheet(r),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: appBorder(1.2),
                      boxShadow: AppShadows.hard(1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Detail',
                          style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.ink,
                          size: 16,
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
                    final nama = (k['nama'] ?? '').toString();
                    final fotoUrl = k['fotoUrl'] as String?;
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
                            _buildAvatar(fotoUrl, nama, 40,
                                bgColor:
                                    active ? Colors.white : AppColors.yellow,
                                textColor:
                                    active ? AppColors.primary : AppColors.ink),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(nama,
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
    final nama = (r['nama'] ?? 'U').toString();
    final waktu = (r['waktu'] ?? '').toString();
    final status = (r['status'] as String? ?? 'Proses').trim();
    final statusUpper = status.toUpperCase();
    final bool isSukses = statusUpper == 'SUKSES';
    final bool isProses = statusUpper == 'PROSES';
    final bool isGagal = statusUpper == 'GAGAL' || statusUpper == 'DIBATALKAN';

    Color statusBg;
    Color statusTextColor;
    Color statusBorderColor;

    if (isSukses) {
      statusBg = const Color(0xFFE8F5E9);
      statusTextColor = const Color(0xFF1E7E34);
      statusBorderColor = const Color(0xFF81C784);
    } else if (isProses) {
      statusBg = const Color(0xFFFEF3C7);
      statusTextColor = const Color(0xFFB45309);
      statusBorderColor = const Color(0xFFFCD34D);
    } else {
      statusBg = const Color(0xFFFFEBEE);
      statusTextColor = const Color(0xFFC62828);
      statusBorderColor = const Color(0xFFEF9A9A);
    }

    final rawItems = (r['items'] as List?) ?? [];
    final fotoUrl = r['fotoUrl'] as String?;

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
                _buildAvatar(fotoUrl, nama, 44,
                    bgColor: AppColors.appWhite, textColor: AppColors.ink),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nama,
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: AppColors.muted, size: 12),
                          const SizedBox(width: 4),
                          Text(
                              '${_formatSectionDate(r['tanggal'] as DateTime)} • $waktu',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusBorderColor, width: 1),
                  ),
                  child: Text(statusUpper,
                      style: GoogleFonts.inter(
                          color: statusTextColor,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5)),
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
            if (isGagal)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  'Dibatalkan',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFC62828),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: rawItems.map((e) {
                  final itemStr = e.toString();
                  final cleanName = itemStr.split('(').first.trim();
                  final kat = controller.getKategori(cleanName);
                  final katColor = controller.getKategoriColor(kat);
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: katColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: katColor, width: 1),
                    ),
                    child: Text(itemStr,
                        style: GoogleFonts.inter(
                            color: katColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700)),
                  );
                }).toList(),
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
    controller.sheetTabIndex.value = 0;
    controller.sheetSearchQuery.value = '';
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

            // Header
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

            // Tabs (Bahan Baku & Barang Operasional dengan border tab aktif)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: appBorder(),
                ),
                child: Obx(() {
                  final isBahan = controller.sheetTabIndex.value == 0;
                  return Row(
                    children: [
                      // Tab BAHAN BAKU
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.sheetTabIndex.value = 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isBahan
                                  ? AppColors.primary
                                  : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: isBahan
                                  ? appBorder(2)
                                  : Border.all(
                                      color: Colors.transparent, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inventory_2_rounded,
                                    color: isBahan
                                        ? Colors.white
                                        : AppColors.muted,
                                    size: 14),
                                const SizedBox(width: 6),
                                Text('BAHAN BAKU',
                                    style: GoogleFonts.inter(
                                        color: isBahan
                                            ? Colors.white
                                            : AppColors.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Tab BARANG OPERASIONAL
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.sheetTabIndex.value = 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isBahan
                                  ? AppColors.primary
                                  : AppColors.appWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: !isBahan
                                  ? appBorder(2)
                                  : Border.all(
                                      color: Colors.transparent, width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.category_rounded,
                                    color: !isBahan
                                        ? Colors.white
                                        : AppColors.muted,
                                    size: 14),
                                const SizedBox(width: 6),
                                Text('BARANG OPERASIONAL',
                                    style: GoogleFonts.inter(
                                        color: !isBahan
                                            ? Colors.white
                                            : AppColors.muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Pilih dari master data • stok terlihat real-time',
                    style: GoogleFonts.inter(
                        color: AppColors.muted, fontSize: 11)),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: appBorder(),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: AppColors.muted, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => controller.sheetSearchQuery.value = v,
                        style: GoogleFonts.inter(fontSize: 12),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Cari bahan atau barang...',
                          hintStyle: GoogleFonts.inter(
                              color: AppColors.muted, fontSize: 12),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Obx(() {
                final isBahan = controller.sheetTabIndex.value == 0;
                final items = controller.currentMasterList;
                final title = isBahan
                    ? 'BAHAN BAKU • STOK MASTER DATA'
                    : 'BARANG OPERASIONAL • STOK MASTER DATA';
                return Row(
                  children: [
                    Text(title,
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.muted.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${items.length} tersedia',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                );
              }),
            ),

            // List Items (Perkecil card bahan atau barang)
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: Obx(() {
                final items = controller.currentMasterList;
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Tidak ada item ditemukan',
                          style: GoogleFonts.inter(
                              color: AppColors.muted, fontSize: 12)),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final isAlreadyAdded = controller.distribusiItems
                        .any((it) => it['item'] == item['name']);
                    return _buildMasterItemCard(
                      icon: item['icon'] as IconData,
                      iconColor: item['iconColor'] as Color,
                      category: item['category'] as String,
                      name: item['name'] as String,
                      stock: item['stock'] as String,
                      unit: item['unit'] as String,
                      percentage: item['percentage'] as int,
                      status: item['status'] as String,
                      isCritical: item['isCritical'] == true,
                      isAdded: isAlreadyAdded,
                      isEmpty: item['isEmpty'] == true,
                    );
                  },
                );
              }),
            ),

            // Card jumlah distribusi dibatasi stok sistem (Border hitam tebal brutalisme)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: appBorder(2),
                  boxShadow: AppShadows.hard(3),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen,
                        borderRadius: BorderRadius.circular(8),
                        border: appBorder(1.5),
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
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text('Tidak bisa melebihi stok tersedia (DV-08)',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted, fontSize: 9.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button Selesai Memilih (Border hitam tebal brutalisme)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                    border: appBorder(2),
                    boxShadow: AppShadows.hard(4),
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
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5)),
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
  // MASTER ITEM CARD (Compact version: Perkecil card bahan atau barang)
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(1.5),
        boxShadow: AppShadows.hard(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN ATAS: Icon + Info + Tombol TAMBAH
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(category,
                          style: GoogleFonts.inter(
                              color: iconColor,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 2),
                    Text(name,
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              if (!isAdded)
                GestureDetector(
                  onTap: isEmpty
                      ? null
                      : () {
                          final kat = (category == 'KEMASAN' ||
                                  category == 'OPERASIONAL')
                              ? 'BARANG OPERASIONAL'
                              : 'BAHAN BAKU';
                          final u = unit.replaceAll('satuan ', '').trim();
                          controller.tambahItem(
                              item: name, kategori: kat, unit: u);
                          Get.back();
                        },
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isEmpty ? Colors.grey[400] : AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: appBorder(1.5),
                      boxShadow: isEmpty ? [] : AppShadows.hard(1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          isEmpty ? 'HABIS' : 'TAMBAH',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.muted.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Sudah Ditambah',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          CustomPaint(
            painter: _DashedHLinePainter(AppColors.muted.withOpacity(0.3)),
            child: const SizedBox(height: 1),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF5EC),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppColors.muted.withOpacity(0.2), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('STOK TERSEDIA',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 8,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(status,
                          style: GoogleFonts.inter(
                              color: getStatusColor(),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text('Stok $stock • $unit',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700)),
                    ),
                    if (!isEmpty)
                      Text('$percentage%',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                  ],
                ),
                if (!isEmpty) ...[
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 5,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (percentage / 100).clamp(0.0, 1.0),
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
