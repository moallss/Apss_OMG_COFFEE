// PATH FILE: lib/features/dashboard/karyawan_dashboard/views/karyawan_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/karyawan_dashboard_controller.dart';

class KaryawanDashboardView extends GetView<KaryawanDashboardController> {
  const KaryawanDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEF2B7C),
      body: Stack(
        children: [
          Container(color: const Color(0xFFEF2B7C)),

          // ============================================
          // LAYER 2: HEADER & CARD STATUS KERJA
          // ============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Obx(() => _buildProfileAvatar(
                            controller.karyawanPhotoUrl.value.isEmpty
                                ? null
                                : controller.karyawanPhotoUrl.value,
                            controller.userName.value,
                            22,
                            bgColor: Colors.white.withOpacity(0.2),
                            textColor: Colors.white,
                          )),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(controller.greeting.value,
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500))),
                            Obx(() => Text(controller.userName.value,
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.notifications_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ==========================================
                  // CARD STATUS KERJA (Conditional)
                  // ==========================================
                  Obx(() {
                    if (controller.isLoadingCheckIn.value) {
                      return _buildSkeletonStatusCard();
                    } else if (!controller.isCheckedIn.value) {
                      return _buildStatusCardBelumCheckIn();
                    } else {
                      return _buildStatusCardSudahCheckIn();
                    }
                  }),
                ],
              ),
            ),
          ),

          // ============================================
          // LAYER 3: CONTAINER CREAM
          // ============================================
          Positioned(
            top: screenHeight * 0.45,
            left: 0,
            right: 0,
            bottom: 50,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F6),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                border: Border.all(color: const Color(0xFFD6336C), width: 2),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                child: Column(
                  children: [
                    Obx(() {
                      if (!controller.isCheckedIn.value) {
                        return _buildKontenBelumCheckIn();
                      } else {
                        return _buildKontenSudahCheckIn();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ============================================
          // LAYER 4: BUTTON CEPAT
          // ============================================
          Positioned(
            top: screenHeight * 0.45 - 35,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3E9B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6336C), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickMenu(Icons.local_shipping_rounded, 'DISTRIBUSI'),
                  _buildQuickMenu(Icons.assignment_rounded, 'AUDIT'),
                  _buildQuickMenu(Icons.history_rounded, 'RIWAYAT'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SKELETON STATUS CARD
  // ==========================================
  Widget _buildSkeletonStatusCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 120, height: 18, color: Colors.white),
              const SizedBox(height: 6),
              Container(width: 160, height: 12, color: Colors.white)
            ]),
            Container(
                width: 90,
                height: 24,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12))),
          ]),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(width: 50, height: 12, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 40, height: 28, color: Colors.white)
                ])),
            Container(width: 1, height: 50, color: Colors.grey[300]),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(width: 50, height: 12, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 40, height: 28, color: Colors.white)
                ])),
          ]),
        ]),
      ),
    );
  }

  // ==========================================
  // STATUS CARD: BELUM CHECK-IN
  // ==========================================
  Widget _buildStatusCardBelumCheckIn() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Status Kerja',
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Jam kerja belum di mulai',
                style:
                    GoogleFonts.inter(color: Colors.grey[600], fontSize: 12)),
          ]),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFB800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('Belum Check-In',
                  style: GoogleFonts.inter(
                      color: const Color(0xFFFFB800),
                      fontSize: 10,
                      fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Colors.grey),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('BAHAN',
                    style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Obx(() => Text(controller.jumlahBahan.value.toString(),
                    style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)))
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(width: 1, height: 50, color: Colors.grey[300])),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('BARANG',
                    style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Obx(() => Text(controller.jumlahBarang.value.toString(),
                    style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)))
              ])),
        ]),
      ]),
    );
  }

  // ==========================================
  // STATUS CARD: SUDAH CHECK-IN
  // ==========================================
  Widget _buildStatusCardSudahCheckIn() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Status Kerja',
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Obx(() => Text(
                'Distribusi dikonfirmasi ${controller.distribusiConfirmedTime.value}',
                style:
                    GoogleFonts.inter(color: Colors.grey[600], fontSize: 12))),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Obx(() => Text(
                'Sudah Check-In ${controller.checkInTime.value}',
                style: GoogleFonts.inter(
                    color: AppColors.brandGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold))),
          ),
        ]),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Colors.grey),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('TRANSAKSI',
                    style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Obx(() => Text(controller.jumlahTransaksi.value.toString(),
                    style: GoogleFonts.outfit(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold))),
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(width: 1, height: 50, color: Colors.grey[300])),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('PENJUALAN',
                    style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Obx(() => FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(controller.jumlahPenjualan.value,
                          style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    )),
              ])),
        ]),
      ]),
    );
  }

  // ==========================================
  // KONTEN BELUM CHECK-IN
  // ==========================================
  Widget _buildKontenBelumCheckIn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Mulai Operasional',
            style: GoogleFonts.outfit(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isLoadingCheckIn.value ||
                        controller.isCheckedIn.value
                    ? null
                    : controller.checkIn,
                style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isCheckedIn.value
                        ? Colors.grey[400]
                        : const Color(0xFFFF3E9B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                            color: Color(0xFFD6336C),
                            width: 2))), // Added border
                child: controller.isLoadingCheckIn.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white))
                    : Text(
                        controller.isCheckedIn.value
                            ? 'Sudah Check-In'
                            : 'Chek-In dan Konfirmasi Distribusi',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
              ),
            )),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Container()),
          Text('Aktif setelah Check-In dan Konfirmasi Distribusi',
              style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
          Expanded(child: Container())
        ]),
      ]),
    );
  }

  // ==========================================
  // KONTEN SUDAH CHECK-IN
  // ==========================================
  Widget _buildKontenSudahCheckIn() {
    return Column(
      children: [
        // Draft Aktif
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Draft Aktif',
                style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color(0xFFD6336C), width: 1.5)),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF3E9B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.bookmark_rounded,
                        color: Color(0xFFFF3E9B), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                              '${controller.draftAktifCount.value} Draft Aktif',
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold))),
                          const SizedBox(height: 2),
                          Text('Transaksi tertunda',
                              style: GoogleFonts.inter(
                                  color: Colors.grey[500], fontSize: 11)),
                        ]),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF3E9B),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('LANJUTKAN',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ]),
        ),

        const SizedBox(height: 28),

        // Sisa Stok Distribusi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sisa Stok Distribusi',
                style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.sisaStokDistribusi.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = controller.sisaStokDistribusi[index];
                  final status = item['status'] as String? ?? 'Unknown';
                  final isHabis = status == 'Habis';
                  return Container(
                    width: 180,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFD6336C), width: 1.5)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['nama'] as String? ?? 'Unknown',
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(item['stok'] as String? ?? 'Unknown',
                                    style: GoogleFonts.inter(
                                        color: Colors.grey[500], fontSize: 11)),
                              ]),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: isHabis
                                    ? const Color(0xFFFF3E9B).withOpacity(0.1)
                                    : const Color(0xFFFFB800).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(status,
                                style: GoogleFonts.inter(
                                    color: isHabis
                                        ? const Color(0xFFFF3E9B)
                                        : const Color(0xFFFFB800),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  );
                },
              ),
            ),
          ]),
        ),

        const SizedBox(height: 28),

        // Closing Operasional
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Closing Operasional',
                style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Obx(() {
              final isAvailable = controller.isClosingAvailable.value;
              return SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isAvailable ? controller.closing : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable
                        ? const Color(0xFFFF3E9B)
                        : Colors.grey[300],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Mulai Closing',
                    style: GoogleFonts.inter(
                      color: isAvailable ? Colors.white : Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                        'Aktif setelah penjualan selesai (tutup ${controller.closingTime.value})',
                        style: GoogleFonts.inter(
                            color: Colors.grey[500], fontSize: 11),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    // Diperbaiki agar konsisten menggunakan AppDialogs
                    AppDialogs.showCustomSnackbar(
                      title: 'Segera Hadir',
                      message: 'Fitur tutup lebih awal akan segera tersedia.',
                      type: SnackbarType.info,
                    );
                  },
                  child: Text('Tutup Lebih Awal ?',
                      style: GoogleFonts.inter(
                          color: const Color(0xFFFF3E9B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ]),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildProfileAvatar(String? imageUrl, String name, double radius,
      {Color? bgColor, Color? textColor}) {
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'K';
    final bg = bgColor ?? const Color(0xFFFF3E9B).withOpacity(0.1);
    final txtColor = textColor ?? const Color(0xFFFF3E9B);
    if (imageUrl == null || imageUrl.isEmpty)
      return _buildFallbackAvatar(firstLetter, radius, bg, txtColor);
    return ClipOval(
        child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                _buildFallbackAvatar(firstLetter, radius, bg, txtColor),
            errorWidget: (context, url, error) =>
                _buildFallbackAvatar(firstLetter, radius, bg, txtColor)));
  }

  Widget _buildFallbackAvatar(
      String letter, double radius, Color bg, Color txtColor) {
    return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Center(
            child: Text(letter,
                style: TextStyle(
                    color: txtColor,
                    fontWeight: FontWeight.bold,
                    fontSize: radius * 0.9))));
  }

  Widget _buildQuickMenu(IconData icon, String label) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25), shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 22)),
      const SizedBox(height: 6),
      Text(label,
          style: GoogleFonts.inter(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
    ]);
  }
}
