// PATH FILE: lib/features/owner/menu/views/menu_view.dart
import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/menu_controller.dart';

class MenuView extends GetView<MenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========== HEADER PINK (SAMA PERSIS DISTRIBUSI) ==========
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
                        Text('Menu',
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                shadows: const [
                                  Shadow(
                                      color: Colors.black, offset: Offset(2, 2))
                                ])),
                        const SizedBox(height: 2),
                        Text('Kelola daftar menu & harga',
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

            // ========== TAB MENGAMBANG (SAMA PERSIS DISTRIBUSI) ==========
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
                              width: double.infinity,
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
                                child: Text('Buat Menu',
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
                              width: double.infinity,
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
                                child: Text('Lihat Menu',
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

            // ========== KONTEN BERDASARKAN TAB ==========
            Obx(() => controller.selectedTabIndex.value == 0
                ? _buildBuatMenu()
                : _buildLihatMenu()),
          ],
        ),
      ),
    );
  }

  // ========== TAB BUAT MENU ==========
  Widget _buildBuatMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. UPLOAD CARD (HORIZONTAL: bingkai kiri, teks kanan)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: appBorder(),
                  boxShadow: AppShadows.hard(3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDE3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                          style: BorderStyle.solid),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: appBorder(2),
                              boxShadow: AppShadows.hard(2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_rounded,
                                    color: AppColors.primary, size: 24),
                                const SizedBox(height: 4),
                                Text('FOTO\nMENU',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        color: AppColors.ink,
                                        fontSize: 7,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tap untuk upload',
                                    style: GoogleFonts.inter(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 6),
                                Text('JPG / PNG / WEBP',
                                    style: GoogleFonts.inter(
                                        color: AppColors.muted,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text('maks 2MB • rasio 1:1',
                                    style: GoogleFonts.inter(
                                        color: AppColors.muted,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -8,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(6),
                    border: appBorder(1),
                  ),
                  child: Text('NEW!',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _label('NAMA MENU'),
          const SizedBox(height: 6),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.namaController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Es Kopi Susu Aren',
                      hintStyle: TextStyle(
                          color: AppColors.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Icon(Icons.edit_rounded,
                    color: AppColors.primary, size: 14),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _label('KATEGORI'),
          const SizedBox(height: 6),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _kategoriChip(
                      'Kopi',
                      Icons.coffee_rounded,
                      controller.kategori.value == 'Kopi',
                      const Color(0xFFD32F2F)),
                  _kategoriChip(
                      'Non-Kopi',
                      Icons.emoji_food_beverage_rounded,
                      controller.kategori.value == 'Non-Kopi',
                      AppColors.appWhite),
                  _kategoriChip('Snack', Icons.cookie_rounded,
                      controller.kategori.value == 'Snack', AppColors.appWhite),
                  _kategoriChip(
                      'Makanan',
                      Icons.restaurant_rounded,
                      controller.kategori.value == 'Makanan',
                      AppColors.appWhite),
                ],
              )),
          const SizedBox(height: 14),
          Row(
            children: [
              _label('HARGA JUAL AWAL'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(50),
                  border: appBorder(1),
                ),
                child: Text('BELUM VALIDASI BPP',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 7,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5),
              ),
              child: Row(
                children: [
                  Text('Rp',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.hargaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '18.000',
                        hintStyle: TextStyle(
                            color: AppColors.ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text('Validasi harga otomatis • akan diverifikasi admin',
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          _label('DESKRIPSI (OPSIONAL)'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: TextField(
              controller: controller.deskripsiController,
              minLines: 3,
              maxLines: 3,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText:
                    'Perpaduan espresso kental dengan susu segar berkualitas dan manisnya sirup gula aren murni.',
                hintStyle: TextStyle(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text('0/100 karakter',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 7,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D7A4F),
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                      ),
                      child: const Icon(Icons.restaurant_menu_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Resep belum disusun',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('Wajib disusun sebelum harga bisa divalidasi',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                    boxShadow: AppShadows.hard(2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.description_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text('Susun Resep Sekarang',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.schedule_rounded,
                          color: AppColors.ink, size: 14),
                      const SizedBox(width: 6),
                      Text('Susun Resep Nanti',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.muted, size: 12),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          'Susun Nanti: menu tersimpan dengan chip BELUM VALIDASI HPP dan divalidasi otomatis saat resep disusun di halaman Resep Menu',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                              height: 1.3)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7ECC9),
              borderRadius: BorderRadius.circular(12),
              border: appBorder(),
              boxShadow: AppShadows.hard(2),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(8),
                    border: appBorder(1),
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppColors.ink, size: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      'Menu akan disimpan dengan status BELUM VALIDASI HPP',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 9,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7A4F),
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Menu Aktif',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(width: 4),
                          const Icon(Icons.info_outline_rounded,
                              color: AppColors.muted, size: 12),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Menu akan muncul di aplikasi pelanggan',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Obx(() => Switch(
                      value: controller.menuAktif.value,
                      activeColor: const Color(0xFF2D7A4F),
                      activeTrackColor:
                          const Color(0xFF2D7A4F).withOpacity(0.3),
                      onChanged: (v) => controller.toggleAktifForm(v),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(() => GestureDetector(
                onTap: controller.isSaving.value ? null : controller.simpanMenu,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(),
                    boxShadow: AppShadows.hard(3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isSaving.value)
                        const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                      else
                        const Icon(Icons.save_rounded,
                            color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                          controller.isSaving.value
                              ? 'Menyimpan...'
                              : 'Simpan Menu',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              )),
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

  Widget _label(String text) => Text(text,
      style: GoogleFonts.inter(
          color: AppColors.ink,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8));

  Widget _kategoriChip(String label, IconData icon, bool aktif, Color bgColor) {
    return GestureDetector(
      onTap: () => controller.selectKategori(label),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: aktif ? const Color(0xFFD32F2F) : bgColor,
          borderRadius: BorderRadius.circular(50),
          border: appBorder(1.5),
          boxShadow: aktif ? AppShadows.hard(2) : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: aktif ? Colors.white : AppColors.ink, size: 10),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.inter(
                    color: aktif ? Colors.white : AppColors.ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  // ========== TAB LIHAT MENU ==========
  Widget _buildLihatMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search + Filter Button
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
                            fillColor: AppColors.appWhite,
                            filled: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Cari menu...',
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
              Obx(() => GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(12),
                        border: appBorder(),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(Icons.filter_list_rounded,
                                color: AppColors.ink, size: 20),
                          ),
                          if (controller.filterKategori.value != 'Semua')
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.ink, width: 1),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 20),

          // Header Section
          Row(
            children: [
              Expanded(
                child: Text('MENU TERSEDIA',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(50),
                  border: appBorder(1.5),
                ),
                child: Obx(() => Text('${controller.menuList.length} MENU',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 8,
                        fontWeight: FontWeight.w900))),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List Menu
          Obx(() {
            final filtered = controller.filteredMenu;
            if (filtered.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: appBorder(),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          color: AppColors.muted, size: 48),
                      const SizedBox(height: 12),
                      Text('Menu tidak ditemukan',
                          style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (var menu in filtered) _menuCard(menu),
              ],
            );
          }),
          const SizedBox(height: 16),

          // Footer Text
          Center(
            child: Text('Geser untuk lihat lebih banyak',
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

  // ========== FILTER CHIP ==========
  Widget _filterChip(String label, IconData icon, bool aktif) {
    return GestureDetector(
      onTap: () => controller.filterKategori.value = label,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: aktif ? AppColors.ink : AppColors.appWhite,
          borderRadius: BorderRadius.circular(50),
          border: appBorder(1.5),
          boxShadow: aktif ? AppShadows.hard(2) : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: aktif ? Colors.white : AppColors.ink, size: 10),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.inter(
                    color: aktif ? Colors.white : AppColors.ink,
                    fontSize: 9,
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  // ========== MENU CARD ==========
  Widget _menuCard(Map<String, dynamic> menu) {
    final isAktif = menu['aktif'] as bool;
    final kategori = menu['kategori'] as String;
    final warnaKategori = kategori == 'Kopi'
        ? const Color(0xFFD32F2F)
        : kategori == 'Non-Kopi'
            ? const Color(0xFF2D7A4F)
            : kategori == 'Snack'
                ? const Color(0xFFFFB800)
                : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Row(
        children: [
          // Foto Menu dengan Badge Full Lebar di Bawah
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: appBorder(1.5),
            ),
            child: Stack(
              children: [
                // Foto/Icon di atas (80% tinggi)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 14, // Sisakan space untuk badge (20%)
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(9)),
                    child: menu['fotoPath'] != null
                        ? Image.network(
                            menu['fotoPath'] as String,
                            width: 70,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.muted.withOpacity(0.1),
                              child: const Icon(Icons.broken_image_rounded,
                                  color: AppColors.muted, size: 20),
                            ),
                          )
                        : Container(
                            color: AppColors.muted.withOpacity(0.1),
                            child: const Icon(Icons.coffee_rounded,
                                color: AppColors.muted, size: 20),
                          ),
                  ),
                ),
                // Badge Kategori Full Lebar di Bawah (20% tinggi)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: warnaKategori,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(9)),
                      border: Border.all(color: AppColors.ink, width: 1),
                    ),
                    child: Center(
                      child: Text(kategori,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 6,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Info Menu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu['nama'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Rp ${controller.formatRupiah(menu['harga'] as int)}',
                        style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: warnaKategori.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: warnaKategori, width: 1),
                      ),
                      child: Text(kategori,
                          style: GoogleFonts.inter(
                              color: warnaKategori,
                              fontSize: 7,
                              fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(menu['deskripsi'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Toggle Switch dengan Border pada button
          Column(
            children: [
              GestureDetector(
                onTap: () => controller.toggleAktifMenu(menu),
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color:
                        isAktif ? const Color(0xFFE8F5E9) : AppColors.appWhite,
                    borderRadius: BorderRadius.circular(15),
                    border: appBorder(1.5),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(2),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color:
                              isAktif ? const Color(0xFF2D7A4F) : Colors.grey,
                          shape: BoxShape.circle,
                          border: appBorder(1),
                        ),
                        transform: Matrix4.translationValues(
                          isAktif ? 18 : 0,
                          0,
                          0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(isAktif ? 'Aktif' : 'Nonaktif',
                  style: GoogleFonts.inter(
                      color:
                          isAktif ? const Color(0xFF2D7A4F) : AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
  
  // ========== DIALOG FILTER ==========
  void _showFilterDialog() {
    Get.dialog(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Filter',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: appBorder(1),
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.ink, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Kategori Menu',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _filterChipDialog(
                        'Semua', controller.filterKategori.value == 'Semua'),
                    _filterChipDialog(
                        'Kopi', controller.filterKategori.value == 'Kopi'),
                    _filterChipDialog('Non-Kopi',
                        controller.filterKategori.value == 'Non-Kopi'),
                    _filterChipDialog(
                        'Snack', controller.filterKategori.value == 'Snack'),
                    _filterChipDialog('Makanan',
                        controller.filterKategori.value == 'Makanan'),
                  ],
                )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.filterKategori.value = 'Semua';
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                      ),
                      child: const Center(
                        child: Text('Reset',
                            style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 10,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: const Center(
                        child: Text('Terapkan',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900)),
                      ),
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

  Widget _filterChipDialog(String label, bool aktif) {
    return GestureDetector(
      onTap: () => controller.filterKategori.value = label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: aktif ? AppColors.ink : AppColors.appWhite,
          borderRadius: BorderRadius.circular(50),
          border: appBorder(1.5),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                color: aktif ? Colors.white : AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w900)),
      ),
    );
  }
  
  // ========== BOTTOM SHEET FILTER (seperti distribusi) ==========
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
            Text('Filter Kategori',
                style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: ['Semua', 'Kopi', 'Non-Kopi', 'Snack', 'Makanan']
                      .map((s) => GestureDetector(
                            onTap: () {
                              controller.filterKategori.value = s;
                              Get.back();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: controller.filterKategori.value == s
                                    ? AppColors.primary
                                    : AppColors.appWhite,
                                borderRadius: BorderRadius.circular(14),
                                border: appBorder(),
                                boxShadow: controller.filterKategori.value == s
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
                                              controller.filterKategori.value ==
                                                      s
                                                  ? Colors.white
                                                  : AppColors.ink,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800)),
                                  if (controller.filterKategori.value == s)
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
}
