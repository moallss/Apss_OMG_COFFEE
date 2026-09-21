// PATH FILE: lib/features/owner/menu/views/menu_view.dart
import 'dart:io';

import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/menu_controller.dart';

const double kPhotoAspect = 16 / 9;

List<double> buildColorMatrix({
  double brightness = 1.0,
  double contrast = 1.0,
  double saturation = 1.0,
}) {
  const lumR = 0.2126;
  const lumG = 0.7152;
  const lumB = 0.0722;

  final sr = (1 - saturation) * lumR;
  final sg = (1 - saturation) * lumG;
  final sb = (1 - saturation) * lumB;
  final t = (1.0 - contrast) * 0.5 * 255;

  return [
    saturation * contrast + sr,
    sg,
    sb,
    0,
    brightness * contrast * t + t,
    sr,
    saturation * contrast + sg,
    sb,
    0,
    brightness * contrast * t + t,
    sr,
    sg,
    saturation * contrast + sb,
    0,
    brightness * contrast * t + t,
    0,
    0,
    0,
    1,
    0,
  ];
}

class MenuView extends GetView<MenuController> {
  const MenuView({super.key});

  static const Map<String, Color> _kategoriColor = {
    'Kopi': Color(0xFF8B4513),
    'Non-Kopi': Color(0xFF1A1A1A),
    'Snack': Color(0xFFFFD400),
    'Makanan': Color(0xFFFF8C00),
  };

  static Color _kategoriBg(String nama) =>
      _kategoriColor[nama] ?? AppColors.appWhite;

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
                RepaintBoundary(child: _buildLihatMenu()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. HEADER
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 50),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
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
          ),
          Column(
            children: [
              Text('Menu',
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(color: Colors.black, offset: Offset(2, 2))
                      ])),
              const SizedBox(height: 2),
              Text('Kelola daftar menu & harga',
                  style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: BrutalIcon(
              icon: Icons.star_rounded,
              color: AppColors.yellow,
              size: 36,
              outlineWidth: 3.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. TABS
  // ==========================================
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
          SizedBox(width: 140, child: _tabButton(0, 'Buat Menu')),
          const SizedBox(width: 4),
          SizedBox(width: 140, child: _tabButton(1, 'Lihat Menu')),
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
            child: Text(
              label,
              style: GoogleFonts.inter(
                  color: active ? Colors.white : AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      );
    });
  }

  // ==========================================
  // 3. FORM BUAT MENU
  // ==========================================
  Widget _buildForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFotoUploadArea(),
                const SizedBox(height: 20),
                Text('NAMA MENU',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _buildNamaInput(),
                const SizedBox(height: 20),
                Text('KATEGORI',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _buildKategoriPills(),
                const SizedBox(height: 20),
                Text('HARGA JUAL DASAR',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _buildHargaCard(),
                const SizedBox(height: 20),
                Text('DESKRIPSI (OPSIONAL)',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _buildDeskripsiArea(),
                const SizedBox(height: 20),
                _buildMenuAktifRow(),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            border: Border(
                top: BorderSide(
                    color: AppColors.muted.withOpacity(0.3), width: 1)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.simpanMenu,
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
                  Text('Simpan Menu',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFotoUploadArea() {
    return Obx(() {
      final path = controller.fotoPath.value;
      if (path == null) {
        return GestureDetector(
          onTap: _pickFoto,
          child: AspectRatio(
            aspectRatio: kPhotoAspect,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(18),
                border: appBorder(),
                boxShadow: AppShadows.hard(4),
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomPaint(
                  painter: _DashedRRectPainter(AppColors.primary, 12),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(8),
                            border: appBorder(1),
                          ),
                          child: Text('NEW!',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.appWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: appBorder(1.5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.coffee_rounded,
                                      color: AppColors.primary, size: 32),
                                  const SizedBox(height: 4),
                                  Text('KOPI SUSU\nGULA',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          color: AppColors.ink,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                                children: [
                                  const TextSpan(text: 'Tap untuk '),
                                  TextSpan(
                                      text: 'upload',
                                      style: GoogleFonts.inter(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('JPG / PNG / WEBP • maks 2MB • kualitas asli',
                                style: GoogleFonts.inter(
                                    color: AppColors.muted, fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      final w = MediaQuery.of(Get.context!).size.width - 40;
      final h = w / kPhotoAspect;
      return Stack(
        children: [
          GestureDetector(
            onTap: _openEditor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _TransformedPhoto(
                path: path,
                zoom: controller.fotoZoom.value,
                turns: controller.fotoTurns.value,
                offsetNorm: controller.fotoOffset.value,
                flipH: controller.fotoFlipH.value,
                flipV: controller.fotoFlipV.value,
                brightness: controller.fotoBrightness.value,
                contrast: controller.fotoContrast.value,
                saturation: controller.fotoSaturation.value,
                width: w,
                height: h,
                radius: 16,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _pickFoto,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  shape: BoxShape.circle,
                  border: appBorder(),
                  boxShadow: AppShadows.hard(2),
                ),
                child: const Icon(Icons.refresh_rounded,
                    color: AppColors.primary, size: 16),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNamaInput() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.namaController,
              style:
                  GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Contoh: Es Kopi Susu',
                hintStyle:
                    GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }

  Widget _buildKategoriPills() {
    final kategoriData = [
      {'nama': 'Kopi', 'icon': Icons.coffee_rounded},
      {'nama': 'Non-Kopi', 'icon': Icons.local_cafe_rounded},
      {'nama': 'Snack', 'icon': Icons.cookie_rounded},
      {'nama': 'Makanan', 'icon': Icons.restaurant_rounded},
    ];

    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kategoriData.map((k) {
            final nama = k['nama'] as String;
            final icon = k['icon'] as IconData;
            final selected = controller.kategori.value == nama;
            final bgColor = selected ? _kategoriBg(nama) : AppColors.appWhite;
            final fgColor = selected
                ? (nama == 'Snack' ? AppColors.ink : Colors.white)
                : AppColors.ink;

            return GestureDetector(
              onTap: () => controller.selectKategori(nama),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: appBorder(),
                  boxShadow: selected ? AppShadows.hard(2) : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: fgColor, size: 16),
                    const SizedBox(width: 6),
                    Text(nama,
                        style: GoogleFonts.inter(
                            color: fgColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildHargaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(4),
      ),
      child: Row(
        children: [
          Text('Rp',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.hargaController,
              keyboardType: TextInputType.number,
              inputFormatters: [_HargaFormatter()],
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '0',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeskripsiArea() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: TextField(
        controller: controller.deskripsiController,
        maxLines: 4,
        style: GoogleFonts.inter(fontSize: 12),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText:
              'Perpaduan espresso kental dengan susu segar berkualitas dan manisnya sirup gula aren murni.',
          hintStyle: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildMenuAktifRow() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu Aktif',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('Menu akan muncul di aplikasi pelanggan',
                    style: GoogleFonts.inter(
                        color: AppColors.muted, fontSize: 10)),
              ],
            ),
          ),
          Obx(() => _buildCustomSwitch(
              value: controller.menuAktif.value,
              onChanged: controller.toggleAktifForm)),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch(
      {required bool value, required ValueChanged<bool> onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppColors.brandGreen : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: value ? const Color(0xFF2A5530) : Colors.grey[400]!,
              width: 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. LIHAT MENU
  // ==========================================
  Widget _buildLihatMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(2),
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
                            hintText: 'Cari menu...',
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
                onTap:
                    _showFilterSheet, // ✅ FIX 1: Method ini sekarang sudah didefinisikan di bawah
                child: Obx(() {
                  final active = controller.hasActiveFilter;
                  return Container(
                    width: 52,
                    height: 52,
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Semua', null),
                const SizedBox(width: 8),
                _filterChip('Kopi', Icons.coffee_rounded),
                const SizedBox(width: 8),
                _filterChip('Non-Kopi', Icons.local_cafe_rounded),
                const SizedBox(width: 8),
                _filterChip('Snack', Icons.cookie_rounded),
                const SizedBox(width: 8),
                _filterChip('Makanan', Icons.restaurant_rounded),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text('MENU TERSEDIA',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Text('${controller.menuList.length} MENU',
                        style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            final list = controller.filteredMenu;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.no_meals_outlined,
                        size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Text('Menu tidak ditemukan',
                        style: GoogleFonts.inter(
                            color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _buildMenuCard(list[i]),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: Column(
              children: [
                Text('Geser untuk lihat lebih banyak',
                    style: GoogleFonts.inter(
                        color: AppColors.muted, fontSize: 10)),
                const SizedBox(height: 8),
                Text('OMG COFFEE · COFFEE KELILING',
                    // ✅ FIX 2: Menggunakan GoogleFonts langsung agar konsisten dan tidak perlu import tambahan yang error
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, IconData? icon) {
    return Obx(() {
      final selected = controller.filterKategori.value == label ||
          (label == 'Semua' && controller.filterKategori.value == 'Semua');
      final bgColor = selected
          ? _kategoriBg(label == 'Semua' ? 'Kopi' : label)
          : AppColors.appWhite;
      final fgColor = selected
          ? (label == 'Snack' ? AppColors.ink : Colors.white)
          : AppColors.ink;

      return GestureDetector(
        onTap: () => controller.filterKategori.value = label,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: appBorder(),
            boxShadow: selected ? AppShadows.hard(2) : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: fgColor, size: 14),
                const SizedBox(width: 4)
              ],
              Text(label,
                  style: GoogleFonts.inter(
                      color: fgColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenuCard(Map<String, dynamic> m) {
    final aktif = m['aktif'] as bool;
    final kategori = m['kategori'] as String;
    final bgColor = _kategoriBg(kategori);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(4),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                color: bgColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: appBorder()),
            child: m['fotoPath'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _TransformedPhoto(
                      path: m['fotoPath'] as String,
                      zoom: (m['fotoZoom'] as double?) ?? 1.0,
                      turns: (m['fotoTurns'] as int?) ?? 0,
                      offsetNorm: (m['fotoOffset'] as Offset?) ?? Offset.zero,
                      flipH: (m['fotoFlipH'] as bool?) ?? false,
                      flipV: (m['fotoFlipV'] as bool?) ?? false,
                      brightness: (m['fotoBrightness'] as double?) ?? 1.0,
                      contrast: (m['fotoContrast'] as double?) ?? 1.0,
                      saturation: (m['fotoSaturation'] as double?) ?? 1.0,
                      width: 70,
                      height: 70,
                      radius: 12,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_rounded,
                          color: AppColors.muted, size: 24),
                      const SizedBox(height: 2),
                      Text('img',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m['nama'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Rp ${controller.formatRupiah(m['harga'] as int)}',
                        style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: appBorder(1)),
                      child: Text(kategori,
                          style: GoogleFonts.inter(
                              color: kategori == 'Snack'
                                  ? AppColors.ink
                                  : Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(m['deskripsi'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.muted, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              _buildCustomSwitch(
                  value: aktif,
                  onChanged: (_) => controller.toggleAktifMenu(m)),
              const SizedBox(height: 4),
              Text(aktif ? 'Aktif' : 'Nonaktif',
                  style: GoogleFonts.inter(
                      color: aktif ? AppColors.brandGreen : AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ FIX 1: Method _showFilterSheet ditambahkan di sini
  void _showFilterSheet() {
    final kategoriOpts = ['Semua', 'Kopi', 'Non-Kopi', 'Snack', 'Makanan'];
    final statusOpts = ['Semua', 'Aktif', 'Nonaktif'];

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAF9F6),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28)),
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
                        borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 12),
            Text('Filter Menu',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Kategori',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.bold)),
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
                          border: appBorder(),
                          boxShadow: selected ? AppShadows.hard(2) : [],
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
            const SizedBox(height: 16),
            Text('Status',
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.bold)),
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
                          border: appBorder(),
                          boxShadow: selected ? AppShadows.hard(2) : [],
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.filterKategori.value = 'Semua';
                      controller.filterStatus.value = 'Semua';
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
                            fontSize: 13, fontWeight: FontWeight.bold)),
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
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Terapkan',
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
    );
  }

  Future<void> _pickFoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final err = await controller.validateFoto(file);
    if (err != null) {
      AppDialogs.showCustomSnackbar(
          title: 'Foto Ditolak', message: err, type: SnackbarType.warning);
      return;
    }

    Get.bottomSheet(
      _FotoEditorSheet(
        path: file.path,
        onPickNewFoto: () async => null,
        onSave: (r) => controller.setFoto(file.path, r),
      ),
      isScrollControlled: true,
    );
  }

  void _openEditor() {
    // TODO: Implement editor
  }
}

// ====================================================
// HELPER CLASSES (DI LUAR class MenuView)
// ====================================================

class _TransformedPhoto extends StatelessWidget {
  final String path;
  final double zoom;
  final int turns;
  final Offset offsetNorm;
  final bool flipH;
  final bool flipV;
  final double brightness;
  final double contrast;
  final double saturation;
  final double width;
  final double height;
  final double radius;

  const _TransformedPhoto({
    required this.path,
    required this.zoom,
    required this.turns,
    required this.offsetNorm,
    required this.flipH,
    required this.flipV,
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Image.file(File(path),
        width: width, height: height, fit: BoxFit.cover);
  }
}

class _FotoEditorSheet extends StatelessWidget {
  final String path;
  final void Function(dynamic result) onSave;
  final Future<String?> Function() onPickNewFoto;

  const _FotoEditorSheet(
      {required this.path, required this.onSave, required this.onPickNewFoto});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
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

class _HargaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), '')
        .replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final limited = digits.length > 8 ? digits.substring(0, 8) : digits;
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
