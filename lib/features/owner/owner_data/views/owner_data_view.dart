import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../controllers/owner_data_controller.dart';

class OwnerDataView extends GetView<OwnerDataController> {
  const OwnerDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildContent(),
            const SizedBox(height: 24),
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
      ),
    );
  }

  // ==========================================
  // HEADER PINK (AMAN: hanya Container + Column)
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul 1 baris (tidak enter)
          Text('MASTER DATA',
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  shadows: const [
                    Shadow(color: Colors.black, offset: Offset(2, 2))
                  ])),
          const SizedBox(height: 4),
          Text('Kelola katalog, stok, armada & tim',
              style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),

          // Carousel
          SizedBox(
            height: 172,
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onCarouselChanged,
              children: [
                _buildSlideMenu(),
                _buildSlideStok(),
                _buildSlideTim(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dots indicator
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final active = controller.carouselIndex.value == i;
                  return GestureDetector(
                    onTap: () => controller.goToSlide(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              )),
        ],
      ),
    );
  }

  // ==========================================
  // KONTEN CREAM
  // ==========================================
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            icon: Icons.local_shipping_rounded,
            iconColor: AppColors.primary,
            title: 'Distribusi',
            subtitle: 'Catat & rekap serah terima barang',
            onTap: () => Get.toNamed(Routes.distribusi),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSquareCard(
                  icon: Icons.coffee_rounded,
                  iconColor: AppColors.yellow,
                  title: 'Menu',
                  subtitle: 'Daftar jual & harga',
                  onTap: () => Get.toNamed(Routes.menu),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSquareCard(
                  icon: Icons.water_drop_rounded,
                  iconColor: const Color(0xFF2D7A4F),
                  title: 'Bahan Baku',
                  subtitle: 'Kopi, susu, gula, dll.',
                  onTap: () => Get.toNamed(Routes.bahanBaku),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSquareCard(
                  icon: Icons.menu_book_rounded,
                  iconColor: AppColors.primary,
                  title: 'Resep Menu',
                  subtitle: 'Standar takaran per menu',
                  onTap: () => Get.toNamed(Routes.resepMenu),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSquareCard(
                  icon: Icons.inventory_2_rounded,
                  iconColor: Colors.orange,
                  title: 'Barang Operasional',
                  subtitle: 'Cup, sedotan, tisu, dll.',
                  onTap: () =>
                      Get.toNamed(Routes.tambahBarang), // ✅ TAMBAHKAN INI
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Card Pengguna ---
          _buildCard(
            icon: Icons.group_rounded,
            iconColor: const Color(0xFF2D7A4F),
            title: 'Pengguna',
            subtitle: '4 karyawan & 2 investor',
            onTap: () => Get.toNamed(Routes.pengguna), // ✅ TAMBAHKAN INI
          ),
          const SizedBox(height: 16),

          // --- Card Rombong ---
          _buildRombongCard(),
        ],
      ),
    );
  }

  // ==========================================
  // SLIDE CAROUSEL (AMAN: tanpa widget custom)
  // ==========================================
  Widget _buildSlideMenu() {
    return Obx(() => _slideShell(
          icon: Icons.coffee_rounded,
          accent: AppColors.primary,
          title: 'RINGKASAN MENU',
          bigText: '${controller.totalMenu.value} Menu Aktif',
          smallText: 'Kopi, Non-Kopi, Snack, Makanan',
          chipText: '${controller.totalKategori.value} Kategori',
        ));
  }

  Widget _buildSlideStok() {
    return Obx(() => _slideShell(
          icon: Icons.warning_amber_rounded,
          accent: const Color(0xFFFFB800),
          title: 'STOK KRITIS',
          bigText: '${controller.stokKritis.length} Bahan Kritis',
          smallText: controller.stokKritis.join(', '),
          chipText: 'Restock!',
        ));
  }

  Widget _buildSlideTim() {
    return Obx(() => _slideShell(
          icon: Icons.group_rounded,
          accent: const Color(0xFF2D7A4F),
          title: 'TIM ANDA',
          bigText:
              '${controller.jumlahKaryawan.value} Karyawan & ${controller.jumlahInvestor.value} Investor',
          smallText:
              '${controller.sudahCheckIn.value} karyawan sudah check-in hari ini',
          chipText: 'Hari Ini',
        ));
  }

  Widget _slideShell({
    required IconData icon,
    required Color accent,
    required String title,
    required String bigText,
    required String smallText,
    required String chipText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
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
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Icon(icon, color: accent, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent, width: 1.5),
                ),
                child: Text(chipText,
                    style: GoogleFonts.inter(
                        color: accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(bigText,
              style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          // Dashed line sederhana
          SizedBox(
            height: 2,
            child: Row(
              children: List.generate(
                  30,
                  (i) => Expanded(
                        child: Container(
                          color: i % 2 == 0
                              ? AppColors.muted.withOpacity(0.5)
                              : Colors.transparent,
                          height: 2,
                        ),
                      )),
            ),
          ),
          const SizedBox(height: 8),
          Text(smallText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
        ],
      ),
    );
  }

  // ==========================================
  // KARTU KOTAK (AMAN: tanpa widget custom)
  // ==========================================
  Widget _buildSquareCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () => AppDialogs.showCustomSnackbar(
                title: 'Segera Hadir',
                message: 'Halaman $title sedang dalam pengembangan.',
                type: SnackbarType.info,
              ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.black, size: 18),
              ],
            ),
            const SizedBox(height: 14),
            Text(title,
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(subtitle,
                style:
                    GoogleFonts.inter(color: AppColors.muted, fontSize: 9.5)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // KARTU LEBAR (AMAN: tanpa widget custom)
  // ==========================================
  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () => AppDialogs.showCustomSnackbar(
                title: 'Segera Hadir',
                message: 'Halaman $title sedang dalam pengembangan.',
                type: SnackbarType.info,
              ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          color: AppColors.muted, fontSize: 10)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.black, size: 22),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // CARD ROMBONG (armada, rute & titik jualan)
  // ==========================================
  Widget _buildRombongCard() {
    return GestureDetector(
      onTap: () => AppDialogs.showCustomSnackbar(
        title: 'Segera Hadir',
        message: 'Halaman Rombong sedang dalam pengembangan.',
        type: SnackbarType.info,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon chip kiri (coklat muda + icon cart)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF1E4DA), // coklat muda
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.shopping_cart_rounded,
                  color: const Color(0xFF6B4F3A), size: 22),
            ),
            const SizedBox(width: 12),

            // Teks tengah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rombong',
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('Armada, rute & titik jualan',
                      style: GoogleFonts.inter(
                          color: AppColors.muted, fontSize: 10)),
                ],
              ),
            ),

            // Chevron kanan
            const Icon(Icons.chevron_right_rounded,
                color: Colors.black, size: 22),
          ],
        ),
      ),
    );
  }
}
