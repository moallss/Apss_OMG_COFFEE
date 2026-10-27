// PATH FILE: lib/features/karyawan/karyawan_dashboard/views/karyawan_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/karyawan_dashboard_controller.dart';
import '../../notifikasi/views/notifikasi_karyawan_view.dart';
import '../../notifikasi/bindings/notifikasi_karyawan_binding.dart';

class KaryawanDashboardView extends GetView<KaryawanDashboardController> {
  const KaryawanDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // 1. HEADER PINK FIXED
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + 130,
            child: Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: topPad + 18,
                bottom: 60,
              ),
              child: Row(
                children: [
                  Obx(() => _buildProfileAvatar(
                        controller.karyawanPhotoUrl.value.isEmpty
                            ? null
                            : controller.karyawanPhotoUrl.value,
                        controller.userName.value,
                        20,
                        bgColor: AppColors.appWhite,
                        textColor: AppColors.primary,
                      )),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                              'Halo, ${controller.userName.value}',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                shadows: const [
                                  Shadow(
                                      color: Colors.black, offset: Offset(2, 2))
                                ],
                              ),
                            )),
                        const SizedBox(height: 2),
                        Obx(() => Text(
                              '${controller.shiftLabel.value} • ${controller.rombongLabel.value} • ${controller.tanggalLabel.value}',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(
                            () => const NotifikasiKaryawanView(),
                            binding: NotifikasiKaryawanBinding()),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            shape: BoxShape.circle,
                            border: appBorder(),
                            boxShadow: AppShadows.hard(2),
                          ),
                          child: const Icon(Icons.notifications_rounded,
                              color: AppColors.ink, size: 18),
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. CONTENT
          Positioned(
            top: topPad + 78,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Obx(() {
                        if (controller.isLoadingCheckIn.value) {
                          return _buildSkeletonCard();
                        }
                        return controller.isCheckedIn.value
                            ? _buildActiveCard()
                            : _buildCheckInCard();
                      }),
                      const SizedBox(height: 18),
                      _buildQuickInfo(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 44),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. PERFORMA HARI INI
                          _cardPerforma(),
                          const SizedBox(height: 16),

                          // 2. STOK KRITIS (Hanya muncul jika check-in aktif)
                          Obx(() => controller.isCheckedIn.value
                              ? Column(
                                  children: [
                                    _cardStok(),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              : const SizedBox.shrink()),

                          // 3. DISTRIBUSI DITERIMA
                          _cardDistribusi(),
                          const SizedBox(height: 16),

                          // 4. JADWAL HARI INI
                          _buildJadwalCard(),
                          const SizedBox(height: 16),

                          // 5. CLOSING SHIFT
                          _cardClosing(),

                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'OMG COFFEE • COFFEE KELILING',
                              style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CARD CHECK-IN (KUNING - BELUM CHECK-IN)
  Widget _buildCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC94D),
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _pill(Icons.schedule_rounded, 'BELUM CHECK-IN',
                  AppColors.appWhite, AppColors.ink),
              const Spacer(),
              Obx(() => _timePill('Jam ${controller.currentTime.value}')),
            ],
          ),
          const SizedBox(height: 12),
          Text('Mulai harimu di sini!',
              style: GoogleFonts.outfit(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('Check-in wajib selfie wajah + lokasi sebagai bukti kehadiran',
              style: GoogleFonts.inter(
                  color: AppColors.ink.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _openCheckInSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.ink, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_camera_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text('Mulai Check-In',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('1x per periode operasional • DV-07',
                style: GoogleFonts.inter(
                    color: AppColors.ink.withOpacity(0.6),
                    fontSize: 8,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // BOTTOM SHEET CHECK-IN 3 STEP
  void _openCheckInSheet() {
    Get.bottomSheet(
      _buildCheckInSheet(),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildCheckInSheet() {
    final bottomPad = MediaQuery.of(Get.context!).padding.bottom;

    return Container(
      height: Get.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 12),
      child: _CheckInSheetContent(
        shiftLabel: controller.shiftLabel.value,
        rombongLabel: controller.rombongLabel.value,
        currentTime: controller.currentTime.value,
        ruteLabel: controller.ruteLabel.value,
      ),
    );
  }

  Widget _buildQuickInfo() {
    return Row(
      children: [
        Expanded(
          child: _quickTile(
            Icons.point_of_sale_rounded,
            'KASIR',
            AppColors.primary,
            Colors.white,
            () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickTile(
            Icons.inventory_2_rounded,
            'STOK',
            AppColors.appWhite,
            AppColors.ink,
            () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickTile(
            Icons.schedule_rounded,
            'JADWAL',
            const Color(0xFFFFC94D),
            AppColors.ink,
            () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickTile(
            Icons.person_rounded,
            'PROFIL',
            const Color(0xFF2D7A4F),
            Colors.white,
            () {},
          ),
        ),
      ],
    );
  }

  Widget _quickTile(
      IconData icon, String label, Color bg, Color fg, VoidCallback onTap) {
    return BrutalTap(
        shadowOffset: 3,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 74,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg, size: 20),
                const SizedBox(height: 6),
                Text(label,
                    style: GoogleFonts.inter(
                        color: fg,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
        ));
  }

  Widget _pill(IconData icon, String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
        border: appBorder(1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: 12),
          const SizedBox(width: 6),
          Text(text,
              style: GoogleFonts.inter(
                  color: fg, fontSize: 8, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _timePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(8),
        border: appBorder(1),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              color: AppColors.ink,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1)),
    );
  }

  Widget _buildActiveCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D7A4F),
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC94D),
                  borderRadius: BorderRadius.circular(50),
                  border: appBorder(1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.ink, size: 12),
                    const SizedBox(width: 6),
                    Obx(() => Text(
                        'SUDAH CHECK-IN ${controller.checkInTime.value}',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 8,
                            fontWeight: FontWeight.w900))),
                  ],
                ),
              ),
              const Spacer(),
              Obx(() => _timePill('Jam ${controller.currentTime.value}')),
            ],
          ),
          const SizedBox(height: 12),
          Text('Check-in berhasil, selamat berjualan!',
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(
              'Shift aktif, rombong & logistik terverifikasi — silakan mulai catat transaksi',
              style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _verifyPill('SELFIE')),
              const SizedBox(width: 8),
              Expanded(child: _verifyPill('LOKASI')),
              const SizedBox(width: 8),
              Expanded(child: _verifyPill('LOGISTIK')),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('1x per periode operasional • DV-07',
                style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 8,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _verifyPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(50),
        border: appBorder(1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_rounded,
              color: AppColors.brandGreen, size: 10),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.brandGreen,
                  fontSize: 8,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildJadwalCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('JADWAL HARI INI',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w900)),
              const Spacer(),
              Obx(() => Text(
                  controller.isCheckedIn.value
                      ? 'Shift Aktif'
                      : 'Belum Dimulai',
                  style: GoogleFonts.inter(
                      color: controller.isCheckedIn.value
                          ? AppColors.brandGreen
                          : AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => _jadwalRow(
                Icons.wb_sunny_rounded,
                const Color(0xFFFFB800),
                '${controller.shiftLabel.value} ${controller.shiftJam.value}',
                'Waktu persiapan operasional 15 mnt',
                null,
                null,
              )),
          const SizedBox(height: 8),
          Obx(() => _jadwalRow(
                Icons.shopping_cart_rounded,
                AppColors.primary,
                controller.rombongLabel.value,
                controller.partnerLabel.value,
                controller.isCheckedIn.value ? 'BEROPERASI' : 'SIAP JALAN',
                AppColors.brandGreen,
              )),
          const SizedBox(height: 8),
          Obx(() => _jadwalRow(
                Icons.place_rounded,
                const Color(0xFFFFB800),
                controller.ruteCount.value,
                controller.ruteLabel.value,
                controller.isCheckedIn.value
                    ? 'SEDANG DIJALAN'
                    : 'BELUM DIMULAI',
                controller.isCheckedIn.value
                    ? AppColors.brandGreen
                    : const Color(0xFFFFB800),
                onTap: _showRuteSheet,
              )),
        ],
      ),
    );
  }

  // ===== CARD BAGIAN BAWAH (putih, border hitam/abu, aksen kecil) =====
  Widget _cardPerforma() {
    return Obx(() {
      final live = controller.isCheckedIn.value;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(live ? 'PERFORMA HARI INI' : 'PERFORMA KEMARIN',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
                const SizedBox(width: 6),
                Text(live ? 'Live' : controller.performaDate.value,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(50),
                    border: appBorder(1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color:
                                live ? AppColors.brandGreen : AppColors.muted,
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(live ? 'AKTIF' : 'TERVERIFIKASI',
                          style: GoogleFonts.inter(
                              color:
                                  live ? AppColors.brandGreen : AppColors.muted,
                              fontSize: 7,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _perfItem(
                      live
                          ? '${controller.jumlahTransaksi.value}'
                          : '${controller.performaTransaksi.value}',
                      'TRANSAKSI',
                      AppColors.ink)),
                ),
                _dashDivider(),
                Expanded(
                  child: Obx(() => _perfItem(
                      live
                          ? controller.jumlahPenjualan.value
                          : controller.performaOmzet.value,
                      'OMZET',
                      AppColors.ink)),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _cardDistribusi() {
    return Obx(() {
      final done = controller.isCheckedIn.value;
      return GestureDetector(
        onTap: _openDistribusiDetail,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(16),
            border: appBorder(),
            boxShadow: AppShadows.hard(2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: const Icon(Icons.inventory_2_rounded,
                    color: AppColors.brandGreen, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                              done
                                  ? 'Distribusi diterima ${controller.distribusiConfirmedTime.value}'
                                  : 'Distribusi menunggu konfirmasi',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: done
                                ? AppColors.brandGreen
                                : const Color(0xFFFFB800),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                        '${controller.distribusiBahan.value} bahan & ${controller.distribusiBarang.value} barang',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(6),
                  border: appBorder(1.5),
                ),
                child: Text(done ? 'TERKONFIRMASI' : 'LIHAT',
                    style: GoogleFonts.inter(
                        color: done ? AppColors.brandGreen : AppColors.ink,
                        fontSize: 7,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.ink, size: 18),
            ],
          ),
        ),
      );
    });
  }

  void _openDistribusiDetail() {
    Get.bottomSheet(
      _buildDistribusiSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildDistribusiSheet() {
    final done = controller.isCheckedIn.value;
    // TODO(backend): ganti list dummy ini dengan fetch surat jalan real.
    const isi = <Map<String, dynamic>>[
      {
        'ikon': Icons.inventory_2_rounded,
        'nama': 'Kopi Bubuk Arabica',
        'qty': '2',
        'unit': 'kg'
      },
      {
        'ikon': Icons.water_drop_rounded,
        'nama': 'Susu UHT Full Cream',
        'qty': '5',
        'unit': 'L'
      },
      {
        'ikon': Icons.coffee_rounded,
        'nama': 'Gula Aren Cair',
        'qty': '3',
        'unit': 'L'
      },
      {
        'ikon': Icons.local_drink_rounded,
        'nama': 'Cup 16oz',
        'qty': '20',
        'unit': 'pcs'
      },
    ];
    return Container(
      constraints: BoxConstraints(maxHeight: Get.height * 0.7),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.muted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(done ? 'Distribusi Diterima' : 'Distribusi Menunggu',
                        style: GoogleFonts.outfit(
                            color: AppColors.ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(
                        done
                            ? 'Dikonfirmasi ${controller.distribusiConfirmedTime.value}'
                            : 'Belum dikonfirmasi — cek fisik lalu konfirmasi',
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    shape: BoxShape.circle,
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.ink, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final it in isi)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: appBorder(1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.appWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: appBorder(1.5),
                          ),
                          child: Icon(it['ikon'] as IconData,
                              color: AppColors.ink, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(it['nama'] as String,
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Text('${it['qty']} ${it['unit']}',
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!done) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _openCheckInSheet();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.ink, width: 2),
                  ),
                ),
                child: Text('Konfirmasi Sekarang',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cardClosing() {
    return Obx(() {
      final checked = controller.isCheckedIn.value;
      final available = controller.isClosingAvailable.value;
      final enabled = checked && available;
      final String title = enabled ? 'Mulai Closing Shift' : 'Closing Shift';
      final String hint = !checked
          ? 'Aktif setelah check-in & pukul ${controller.closingTime.value}'
          : (available
              ? 'Shift selesai, silakan tutup kasir'
              : 'Terbuka otomatis pukul ${controller.closingTime.value}');
      final String statusLabel =
          enabled ? 'AKTIF' : (checked ? 'MENUNGGU' : 'TERKUNCI');
      return GestureDetector(
        onTap: enabled ? controller.closing : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(16),
            border: appBorder(),
            boxShadow: AppShadows.hard(2),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Icon(
                  enabled
                      ? Icons.lock_open_rounded
                      : Icons.lock_outline_rounded,
                  color: enabled ? AppColors.brandGreen : AppColors.muted,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(hint,
                        style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: enabled ? AppColors.brandGreen : AppColors.appWhite,
                  borderRadius: BorderRadius.circular(50),
                  border: appBorder(1.5),
                ),
                child: Text(statusLabel,
                    style: GoogleFonts.inter(
                        color: enabled ? Colors.white : AppColors.muted,
                        fontSize: 7,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _cardStok() {
    return GestureDetector(
      onTap: controller.bukaStok,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(10),
                border: appBorder(1.5),
              ),
              child: const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFFFB800), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('2 stok kritis di gerobakmu',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text('Susu UHT & Cup 16oz - cek tab STOK',
                      style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.ink, size: 18),
          ],
        ),
      ),
    );
  }

  // Tap baris rute di beranda -> semua titik, nama utuh, nomor rata-atas
  void _showRuteSheet() {
    final pts = controller.ruteLabel.value
        .split('•')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (pts.isEmpty) pts.add(controller.ruteLabel.value);
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.ink, width: 2),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.route_rounded, color: AppColors.ink, size: 16),
                const SizedBox(width: 6),
                Text('SEMUA TITIK RUTE',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                const Spacer(),
                Text('${pts.length} TITIK',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < pts.length; i++)
                    _ruteRowDash(i, pts[i], i == 0, i == pts.length - 1),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _ruteRowDash(int i, String name, bool isStart, bool isFinish) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              shape: BoxShape.circle,
              border: appBorder(1),
            ),
            child: Center(
              child: Text('${i + 1}',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 8,
                      fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name,
                style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 6),
          if (isStart)
            Text('START',
                style: GoogleFonts.inter(
                    color: AppColors.brandGreen,
                    fontSize: 7,
                    fontWeight: FontWeight.w900)),
          if (isFinish)
            Text('FINISH',
                style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 7,
                    fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
        ),
      ),
    );
  }

  Widget _jadwalRow(IconData icon, Color iconColor, String title,
      String subtitle, String? badge, Color? badgeColor,
      {VoidCallback? onTap}) {
    final row = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(12),
        border: appBorder(1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              shape: BoxShape.circle,
              border: appBorder(1.5),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(6),
                border: appBorder(1.5),
              ),
              child: Text(badge,
                  style: GoogleFonts.inter(
                      color: badgeColor ?? AppColors.ink,
                      fontSize: 7,
                      fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
    if (onTap == null) return row;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }

  Widget _perfItem(String value, String label, Color color) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value,
              style: GoogleFonts.outfit(
                  color: color, fontSize: 16, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1)),
      ],
    );
  }

  Widget _dashDivider() {
    return SizedBox(
      width: 24,
      height: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          3,
          (_) => Container(
            width: 1.5,
            height: 8,
            color: AppColors.ink.withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String? imageUrl, String name, double radius,
      {Color? bgColor, Color? textColor}) {
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'K';
    final bg = bgColor ?? AppColors.yellow;
    final txtColor = textColor ?? AppColors.ink;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackAvatar(firstLetter, radius, bg, txtColor);
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            _buildFallbackAvatar(firstLetter, radius, bg, txtColor),
        errorWidget: (context, url, error) =>
            _buildFallbackAvatar(firstLetter, radius, bg, txtColor),
      ),
    );
  }

  Widget _buildFallbackAvatar(
      String letter, double radius, Color bg, Color txtColor) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: appBorder(1.5),
      ),
      child: Center(
        child: Text(letter,
            style: GoogleFonts.inter(
                color: txtColor,
                fontWeight: FontWeight.w900,
                fontSize: radius * 0.9)),
      ),
    );
  }
}

// PAINTER BORDER PUTUS-PUTUS
class _DashedRRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final rrect =
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = distance + 6;
        canvas.drawPath(
            metric.extractPath(
                distance, end > metric.length ? metric.length : end),
            paint);
        distance = end + 5;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// WIDGET TERPISAH UNTUK BOTTOM SHEET CONTENT
class _CheckInSheetContent extends StatefulWidget {
  final String shiftLabel;
  final String rombongLabel;
  final String currentTime;
  final String ruteLabel;

  const _CheckInSheetContent({
    required this.shiftLabel,
    required this.rombongLabel,
    required this.currentTime,
    required this.ruteLabel,
  });

  @override
  State<_CheckInSheetContent> createState() => _CheckInSheetContentState();
}

class _CheckInSheetContentState extends State<_CheckInSheetContent> {
  int currentStep = 1;
  bool selfieTaken = false;
  bool locationVerified = false;
  bool logisticsConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Check-In Operasional',
            style: GoogleFonts.outfit(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text('${widget.shiftLabel} (07:00) • ${widget.rombongLabel} • DV-07',
            style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Row(
          children: [
            _stepPill(1, '1. Selfie'),
            const SizedBox(width: 8),
            _stepPill(2, '2. Lokasi'),
            const SizedBox(width: 8),
            _stepPill(3, '3. Logistik'),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: currentStep == 1
              ? _buildStep1Selfie()
              : currentStep == 2
                  ? _buildStep2Lokasi()
                  : _buildStep3Logistik(),
        ),
      ],
    );
  }

  Widget _stepPill(int step, String label) {
    final isActive = step == currentStep;
    final isDone = step < currentStep;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (step <= currentStep) {
            setState(() => currentStep = step);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : (isDone
                    ? AppColors.brandGreen.withOpacity(0.12)
                    : AppColors.appWhite),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isActive || isDone
                  ? AppColors.ink
                  : AppColors.ink.withOpacity(0.2),
              width: isActive ? 2 : 1.5,
            ),
            boxShadow: isActive ? AppShadows.hard(2) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isDone) ...[
                const Icon(Icons.check_rounded,
                    color: AppColors.brandGreen, size: 10),
                const SizedBox(width: 4),
              ],
              Text(label,
                  style: GoogleFonts.inter(
                      color: isActive
                          ? Colors.white
                          : (isDone ? AppColors.brandGreen : AppColors.muted),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1Selfie() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(16),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: Text('STEP 1 - VERIFIKASI WAJAH',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC94D),
                        borderRadius: BorderRadius.circular(8),
                        border: appBorder(1.5),
                        boxShadow: AppShadows.hard(1),
                      ),
                      child: Text('WAJIB',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _DashedRRectPainter(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Center(
                        child: _buildAvatarIllustration(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (selfieTaken)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EEE5),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: AppColors.brandGreen.withOpacity(0.4),
                            width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_rounded,
                              color: AppColors.brandGreen, size: 13),
                          const SizedBox(width: 6),
                          Text('Wajah Terdeteksi & Cocok',
                              style: GoogleFonts.inter(
                                  color: AppColors.brandGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                if (selfieTaken) const SizedBox(height: 12),
                if (selfieTaken)
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => selfieTaken = false),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.appWhite,
                        side: const BorderSide(color: AppColors.ink, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppColors.ink, size: 14),
                      label: Text('Ambil Ulang Foto',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => selfieTaken = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: AppColors.ink, width: 2),
                        ),
                      ),
                      icon: const Icon(Icons.photo_camera_rounded,
                          color: Colors.white, size: 14),
                      label: Text('Ambil Foto Selfie',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                      selfieTaken
                          ? 'Waktu pengambilan foto: ${widget.currentTime} WIB'
                          : 'Foto belum diambil',
                      style: GoogleFonts.inter(
                          color: selfieTaken ? AppColors.ink : AppColors.muted,
                          fontSize: 9,
                          fontWeight:
                              selfieTaken ? FontWeight.w900 : FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(12),
              border: appBorder(1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC94D),
                    borderRadius: BorderRadius.circular(8),
                    border: appBorder(1.5),
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppColors.ink, size: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                      'Pastikan wajah terlihat jelas tanpa masker dan di tempat yang cukup terang untuk verifikasi presensi.',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 9,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  selfieTaken ? () => setState(() => currentStep = 2) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selfieTaken ? AppColors.primary : Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.ink, width: 2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lanjut: Validasi Lokasi',
                      style: GoogleFonts.inter(
                          color: selfieTaken ? Colors.white : Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: selfieTaken ? Colors.white : Colors.grey[500],
                      size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Langkah 1 dari 3 • Verifikasi Face Match',
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAvatarIllustration() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        shape: BoxShape.circle,
        border: appBorder(2.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 16,
            child: Container(
              width: 74,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF2D7A4F),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                border: appBorder(1.5),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC94D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('OMG',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32,
            child: Container(
              width: 62,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0BD),
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 20,
                      left: 14,
                      child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              color: AppColors.ink, shape: BoxShape.circle))),
                  Positioned(
                      top: 20,
                      right: 14,
                      child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              color: AppColors.ink, shape: BoxShape.circle))),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 18,
                        height: 9,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: AppColors.ink, width: 2)),
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 24,
            child: Container(
              width: 78,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF2D3436),
                borderRadius: BorderRadius.circular(9),
                border: appBorder(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Lokasi() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(16),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: appBorder(1.5),
                        boxShadow: AppShadows.hard(2),
                      ),
                      child: Text('STEP 2 - VALIDASI LOKASI GPS',
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EEE5),
                        borderRadius: BorderRadius.circular(8),
                        border: appBorder(1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                color: AppColors.brandGreen,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Text('AKURAT (5m)',
                              style: GoogleFonts.inter(
                                  color: AppColors.brandGreen,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildMapsVisual(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EEE5),
                        borderRadius: BorderRadius.circular(8),
                        border: appBorder(1.5),
                      ),
                      child: const Icon(Icons.place_rounded,
                          color: AppColors.brandGreen, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TITIK PENUGASAN RESMI',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5)),
                          const SizedBox(height: 2),
                          Text('Alun-Alun Kota (Titik Start Rombong 01)',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // RUTE PERJALANAN HARI INI (maks 3 tampil, sisanya di sheet)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: appBorder(1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.route_rounded,
                              color: AppColors.ink, size: 14),
                          const SizedBox(width: 6),
                          Text('RUTE PERJALANAN HARI INI',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5)),
                          const Spacer(),
                          Text(
                              '${widget.ruteLabel.split('•').where((e) => e.trim().isNotEmpty).length} TITIK',
                              style: GoogleFonts.inter(
                                  color: AppColors.muted,
                                  fontSize: 7,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...(() {
                        final pts = widget.ruteLabel
                            .split('•')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();
                        if (pts.isEmpty) pts.add(widget.ruteLabel);
                        final shown = pts.take(3).toList();
                        final extra = pts.length - shown.length;
                        return <Widget>[
                          for (int i = 0; i < shown.length; i++)
                            _ruteRow(i, shown[i], i == 0, i == pts.length - 1),
                          if (extra > 0)
                            GestureDetector(
                              onTap: () => _showRuteSheet(pts),
                              child: Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.appWhite,
                                  borderRadius: BorderRadius.circular(50),
                                  border: appBorder(1.5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('+$extra titik lagi',
                                        style: GoogleFonts.inter(
                                            color: AppColors.primary,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.expand_more_rounded,
                                        color: AppColors.primary, size: 14),
                                  ],
                                ),
                              ),
                            ),
                        ];
                      })(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EEE5),
                          borderRadius: BorderRadius.circular(10),
                          border: appBorder(1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_rounded,
                                color: AppColors.brandGreen, size: 12),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text('Posisi Sesuai Titik Rombong',
                                  style: GoogleFonts.inter(
                                      color: AppColors.brandGreen,
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.appWhite,
                        side:
                            const BorderSide(color: AppColors.ink, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.refresh_rounded,
                              color: AppColors.ink, size: 12),
                          const SizedBox(width: 4),
                          Text('Refresh\nGPS',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () => setState(() => currentStep = 1),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.appWhite,
                    side: const BorderSide(color: AppColors.ink, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chevron_left_rounded,
                          color: AppColors.ink, size: 14),
                      const SizedBox(width: 4),
                      Text('Kembali',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => setState(() => currentStep = 3),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              const BorderSide(color: AppColors.ink, width: 2)),
                    ),
                    child: Text('Lanjut: Konfirmasi Logistik',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Langkah 2 dari 3 • Verifikasi Radius Rombong',
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMapsVisual() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EBE3),
        borderRadius: BorderRadius.circular(12),
        border: appBorder(1.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            left: -24,
            top: -18,
            child: Container(
              width: 130,
              height: 95,
              decoration: BoxDecoration(
                color: const Color(0xFFC9E4BC),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 14,
            child: Text('Taman Kota',
                style: GoogleFonts.inter(
                    color: const Color(0xFF7A9B6D),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700)),
          ),
          Positioned(
            right: -34,
            bottom: -46,
            child: Container(
              width: 150,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFAFD8F2),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              top: 46,
              child: Container(height: 7, color: Colors.white)),
          Positioned(
              top: 0,
              bottom: 0,
              left: 64,
              child: Container(width: 9, color: Colors.white)),
          Positioned(
              top: 0,
              bottom: 0,
              right: 52,
              child: Container(width: 7, color: Colors.white)),
          Positioned(
              left: 0,
              right: 0,
              bottom: 58,
              child: Container(height: 7, color: Colors.white)),
          Positioned(
            left: 0,
            right: 0,
            top: 104,
            child: Container(
              height: 16,
              color: Colors.white,
              child: Center(
                child: Container(height: 10, color: const Color(0xFFF7E3A2)),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 107,
            child: Text('Jl. Alun-Alun Timur',
                style: GoogleFonts.inter(
                    color: const Color(0xFF9AA0A6),
                    fontSize: 7,
                    fontWeight: FontWeight.w600)),
          ),
          Positioned(
            top: 62,
            right: 14,
            child: Text('ALUN-ALUN\nKOTA PUSAT',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: const Color(0xFF9AA0A6),
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1)),
          ),
          Positioned(
            left: 34,
            bottom: 74,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4).withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 58,
            child: Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.ink, size: 40),
                      const Icon(Icons.location_on_rounded,
                          color: Color(0xFFEA4335), size: 34),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: appBorder(1),
                      boxShadow: AppShadows.hard(1),
                    ),
                    child: Text('Rombong 01',
                        style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5),
                boxShadow: AppShadows.hard(1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: AppColors.brandGreen, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('GPS',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 8,
                          fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 64,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5),
                boxShadow: AppShadows.hard(1),
              ),
              child: const Icon(Icons.my_location_rounded,
                  color: Color(0xFF4285F4), size: 15),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 26,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5),
                boxShadow: AppShadows.hard(1),
              ),
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: 26,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add_rounded,
                        color: AppColors.ink, size: 15),
                  ),
                  Container(
                      height: 1.5,
                      width: 20,
                      color: AppColors.ink.withOpacity(0.2)),
                  Container(
                    width: 30,
                    height: 26,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove_rounded,
                        color: AppColors.ink, size: 15),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 4,
            child: Text('Map data ©2026 OMG Coffee',
                style: GoogleFonts.inter(
                    color: AppColors.ink.withOpacity(0.45),
                    fontSize: 6.5,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _ruteRow(int i, String name, bool isStart, bool isFinish) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              shape: BoxShape.circle,
              border: appBorder(1),
            ),
            child: Center(
              child: Text('${i + 1}',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 8,
                      fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name,
                style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ),
          if (isStart)
            Text('START',
                style: GoogleFonts.inter(
                    color: AppColors.brandGreen,
                    fontSize: 7,
                    fontWeight: FontWeight.w900)),
          if (isFinish)
            Text('FINISH',
                style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 7,
                    fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  void _showRuteSheet(List<String> pts) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.ink, width: 2),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.muted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.route_rounded, color: AppColors.ink, size: 16),
                const SizedBox(width: 6),
                Text('SEMUA TITIK RUTE',
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5)),
                const Spacer(),
                Text('${pts.length} TITIK',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (int i = 0; i < pts.length; i++)
                    _ruteRow(i, pts[i], i == 0, i == pts.length - 1),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildStep3Logistik() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.circular(16),
              border: appBorder(),
              boxShadow: AppShadows.hard(3),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC94D),
                          borderRadius: BorderRadius.circular(8),
                          border: appBorder(1.5),
                          boxShadow: AppShadows.hard(2),
                        ),
                        child: Text('STEP 3 - KONFIRMASI LOGISTIK (FR-09)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 7.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.2)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EEE5),
                        borderRadius: BorderRadius.circular(8),
                        border: appBorder(1.5),
                      ),
                      child: Text('SURAT JALAN VALID',
                          style: GoogleFonts.inter(
                              color: AppColors.brandGreen,
                              fontSize: 7,
                              fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                    'Verifikasi muatan fisik rombong sebelum membuka sesi penjualan.',
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _logistikItem(
                    Icons.inventory_2_rounded,
                    const Color(0xFFFFF3D6),
                    'Kopi Bubuk Arabica',
                    'Stok: 2 kg',
                    '2',
                    'kg'),
                const SizedBox(height: 8),
                _logistikItem(Icons.water_drop_rounded, const Color(0xFFFFF3D6),
                    'Susu UHT Full Cream', 'Stok: 5 L', '5', 'L'),
                const SizedBox(height: 8),
                _logistikItem(Icons.coffee_rounded, const Color(0xFFFFE1EE),
                    'Gula Aren Cair', 'Stok: 3 L', '3', 'L'),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () =>
                      setState(() => logisticsConfirmed = !logisticsConfirmed),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC94D),
                      borderRadius: BorderRadius.circular(12),
                      border: appBorder(1.5),
                      boxShadow: AppShadows.hard(1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: logisticsConfirmed
                                ? AppColors.primary
                                : AppColors.appWhite,
                            shape: BoxShape.circle,
                            border: appBorder(1.5),
                          ),
                          child: logisticsConfirmed
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                              'Saya telah menghitung fisik barang dan jumlah sesuai dengan surat jalan owner.',
                              style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () => setState(() => currentStep = 2),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.appWhite,
                    side: const BorderSide(color: AppColors.ink, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chevron_left_rounded,
                          color: AppColors.ink, size: 14),
                      const SizedBox(width: 4),
                      Text('Kembali',
                          style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: logisticsConfirmed
                        ? () {
                            final c = Get.find<KaryawanDashboardController>();
                            c.isCheckedIn.value = true;
                            c.checkInTime.value = c.currentTime.value;
                            c.distribusiConfirmedTime.value =
                                c.currentTime.value;
                            Get.back();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: logisticsConfirmed
                          ? AppColors.primary
                          : Colors.grey[300],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              const BorderSide(color: AppColors.ink, width: 2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: logisticsConfirmed
                                ? Colors.white
                                : Colors.grey[500],
                            size: 14),
                        const SizedBox(width: 6),
                        Text('Selesaikan Check-In & Buka Kasir',
                            style: GoogleFonts.inter(
                                color: logisticsConfirmed
                                    ? Colors.white
                                    : Colors.grey[500],
                                fontSize: 10,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Langkah 3 dari 3 • Konfirmasi Muatan',
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _logistikItem(IconData icon, Color tint, String nama, String detail,
      String qty, String unit) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(12),
          border: appBorder(1.5)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5)),
            child: Icon(icon, color: AppColors.ink, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(detail,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(qty,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
                const SizedBox(width: 5),
                Text(unit,
                    style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
