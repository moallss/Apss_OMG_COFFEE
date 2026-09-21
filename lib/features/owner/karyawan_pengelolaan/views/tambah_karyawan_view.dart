import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/tambah_karyawan_controller.dart';

class TambahKaryawanView extends GetView<TambahKaryawanController> {
  const TambahKaryawanView({super.key});

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
              controller: controller.pageController,
              onPageChanged: (index) =>
                  controller.selectedTabIndex.value = index,
              children: [
                RepaintBoundary(child: _buildTambahKaryawan(context)),
                RepaintBoundary(child: _buildDaftarKaryawan()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HEADER
  // ==========================================
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
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.ink,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelola Karyawan',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        shadows: const [
                          Shadow(color: Colors.black, offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kelola hak akses & penugasan tim',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

  // ==========================================
  // TABS
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
          SizedBox(width: 140, child: _tabButton(0, 'TAMBAH KARYAWAN')),
          const SizedBox(width: 4),
          SizedBox(width: 140, child: _tabButton(1, 'DAFTAR KARYAWAN')),
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
              color: active ? AppColors.ink : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: active ? Colors.white : AppColors.primary,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    });
  }

  // ==========================================
  // TAB 1: TAMBAH KARYAWAN
  // ==========================================
  Widget _buildTambahKaryawan(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                _buildAccordionInfo(),
                const SizedBox(height: 14),
                _buildSectionCard(
                  index: 0,
                  title: 'DATA DIRI & FOTO',
                  subtitle: 'Foto selfie, nama, alamat, nomor WA',
                  badgeText: 'LENGKAP',
                  badgeColor: AppColors.brandGreen,
                  content: _buildDataDiriContent(),
                ),
                _buildSectionCard(
                  index: 1,
                  title: 'AKUN APLIKASI',
                  subtitle: 'Kredensial akses aplikasi POS kasir',
                  badgeText: 'ROLE: KARYAWAN',
                  badgeColor: AppColors.brandGreen,
                  badgeIcon: Icons.engineering_rounded,
                  content: _buildAkunContent(),
                ),
                _buildSectionCard(
                  index: 2,
                  title: 'PENUGASAN ROMBONG',
                  subtitle: 'Tempat tugas & unit gerobak',
                  badgeText: 'WAJIB',
                  badgeColor: AppColors.primary,
                  content: _buildRombongContent(),
                ),
                _buildSectionCard(
                  index: 3,
                  title: 'JADWAL & HAK AKSES',
                  subtitle: 'Hari kerja, shift & akses aplikasi',
                  badgeText: 'TERKONFIGURASI',
                  badgeColor: AppColors.brandGreen,
                  content: _buildJadwalContent(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'OMG COFFEE · COFFEE KELILING',
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
        _buildBottomBar(context),
      ],
    );
  }

  // ==========================================
  // TAB 2: DAFTAR KARYAWAN
  // ==========================================
  Widget _buildDaftarKaryawan() {
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
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.ink,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Cari karyawan...',
                            hintStyle: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: EdgeInsets.zero,
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  '${controller.daftarKaryawan.length}',
                  'TOTAL',
                  AppColors.primary,
                  Icons.group_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatusCard(
                  '${controller.jumlahAktif}',
                  'AKTIF',
                  AppColors.brandGreen,
                  Icons.check_circle_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatusCard(
                  '${controller.jumlahCuti}',
                  'CUTI',
                  const Color(0xFFFFB800),
                  Icons.event_busy_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'TIM KARYAWAN',
                style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${controller.daftarKaryawan.length} orang',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: controller.daftarKaryawan
                .map((k) => _buildKaryawanCard(k))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.muted, width: 1.5),
                ),
                child: const Icon(
                  Icons.touch_app_rounded,
                  color: AppColors.muted,
                  size: 10,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Tap card untuk lihat detail & absensi',
                style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'OMG COFFEE · COFFEE KELILING',
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
    );
  }

  Widget _buildStatusCard(
    String value,
    String label,
    Color bgColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: appBorder(1.5),
        boxShadow: AppShadows.hard(2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KARYAWAN CARD — dengan navigasi ke detail
  // ==========================================
  Widget _buildKaryawanCard(Map<String, dynamic> karyawan) {
    final status = karyawan['status'] as String;
    final statusColor =
        status == 'aktif' ? AppColors.brandGreen : const Color(0xFFFFB800);
    final roleColor = karyawan['roleColor'] as Color;

    return GestureDetector(
      onTap: () {
        // ✅ NAVIGASI ke halaman detail (di file yang sama)
        Get.to(() => DetailKaryawanView(karyawan: karyawan));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(14),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: karyawan['avatarColor'] as Color,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: Center(
                child: Text(
                  (karyawan['nama'] as String).substring(0, 1),
                  style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          karyawan['nama'] as String,
                          style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: roleColor, width: 1.5),
                        ),
                        child: Text(
                          karyawan['role'] as String,
                          style: GoogleFonts.inter(
                            color: roleColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${karyawan['rombong']} • Shift ${karyawan['shift']}',
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Text(
                status.toUpperCase(),
                style: GoogleFonts.inter(
                  color: statusColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.ink,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordionInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(12),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE1EE),
              borderRadius: BorderRadius.circular(8),
              border: appBorder(1.5),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Accordion Mode',
                  style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Buka bagian yang ingin disunting',
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.brandGreen, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.brandGreen,
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${controller.terbukaCount}/4 TERBUKA',
                    style: GoogleFonts.inter(
                      color: AppColors.brandGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required int index,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    IconData? badgeIcon,
    required Widget content,
  }) {
    return Obx(() {
      final isOpen = controller.openSections[index];

      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(16),
          border: appBorder(),
          boxShadow: AppShadows.hard(2),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.toggleSection(index),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: appBorder(1.5),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: badgeColor, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (badgeIcon != null) ...[
                            Icon(badgeIcon, color: badgeColor, size: 10),
                            const SizedBox(width: 3),
                          ] else if (badgeText != 'WAJIB') ...[
                            Icon(
                              Icons.check_rounded,
                              color: badgeColor,
                              size: 10,
                            ),
                            const SizedBox(width: 3),
                          ],
                          Text(
                            badgeText,
                            style: GoogleFonts.inter(
                              color: badgeColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        shape: BoxShape.circle,
                        border: appBorder(1.5),
                      ),
                      child: Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.ink,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                heightFactor: isOpen ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: content,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDataDiriContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3D6),
            borderRadius: BorderRadius.circular(12),
            border: appBorder(1.5),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE1EE),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: -8,
                    left: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(6),
                        border: appBorder(1),
                      ),
                      child: Text(
                        'WAJIB',
                        style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.appWhite,
                        borderRadius: BorderRadius.circular(6),
                        border: appBorder(1),
                      ),
                      child: Text(
                        '+ FOTO',
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foto Wajah Karyawan',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(text: 'Acuan sistem '),
                          TextSpan(
                            text: 'Face Match',
                            style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const TextSpan(
                            text: ' saat absen selfie check-in GPS rombong.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildInputField(
          label: 'NAMA LENGKAP',
          badgeText: 'WAJIB',
          badgeColor: AppColors.primary,
          textController: controller.namaLengkap,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          label: 'ALAMAT LENGKAP',
          textController: controller.alamatLengkap,
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          label: 'NO. TELEPON / WHATSAPP',
          badgeText: 'WA AKTIF',
          badgeColor: AppColors.brandGreen,
          textController: controller.noTelepon,
          icon: Icons.phone_rounded,
          prefixChip: 'WA',
          prefixChipColor: AppColors.brandGreen,
        ),
      ],
    );
  }

  Widget _buildAkunContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE3EEE5),
            borderRadius: BorderRadius.circular(12),
            border: appBorder(1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.brandGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'LOG STATUS VERIFIKASI',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.brandGreen,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'LOG SUKSES',
                      style: GoogleFonts.inter(
                        color: AppColors.brandGreen,
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Row(
                  children: [
                    _stepItem('Data\nLengkap'),
                    _stepConnector(),
                    _stepItem('Link\nTerkirim'),
                    _stepConnector(),
                    _stepItem('Terverifikasi'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.appWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.brandGreen,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Email terverifikasi',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(10:42 WIB)',
                      style: GoogleFonts.inter(
                        color: AppColors.brandGreen,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildInputField(
          label: 'USERNAME',
          badgeText: 'WAJIB',
          badgeColor: AppColors.primary,
          textController: controller.username,
          icon: Icons.person_outline_rounded,
          iconLeft: true,
          suffixBadgeText: 'TERSEDIA',
          suffixBadgeColor: AppColors.brandGreen,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          label: 'EMAIL',
          badgeText: 'WAJIB',
          badgeColor: AppColors.primary,
          textController: controller.email,
          icon: Icons.mail_outline_rounded,
          iconLeft: true,
        ),
        const SizedBox(height: 10),
        _buildPasswordField(),
        const SizedBox(height: 4),
        Text(
          'Kombinasi huruf & angka disarankan (min. 8 karakter)',
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFE3EEE5),
              side: const BorderSide(
                color: AppColors.brandGreen,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.brandGreen,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'KIRIM ULANG LINK VERIFIKASI',
                  style: GoogleFonts.inter(
                    color: AppColors.brandGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Link verifikasi telah dikirim ke email karyawan. Klik tombol ini jika perlu mengirim ulang link verifikasi.',
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'KREDENSIAL SIAP DIKIRIM',
              style: GoogleFonts.inter(
                color: AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.brandGreen, width: 1.5),
              ),
              child: Text(
                'TERBUKA',
                style: GoogleFonts.inter(
                  color: AppColors.brandGreen,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.ink, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'KIRIM VIA WHATSAPP',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 40,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.appWhite,
                    side: const BorderSide(color: AppColors.ink, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.content_copy_rounded,
                        color: AppColors.ink,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SALIN DATA AKUN',
                        style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Menyalin/mengirim: username, email, dan password sementara',
          style: GoogleFonts.inter(
            color: AppColors.muted,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.ink,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Verifikasi email berhasil membuka pengiriman kredensial',
                  style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRombongContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3D6),
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.store_rounded, color: AppColors.ink, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => Text(
                    'Rombong: ${controller.rombong.value}',
                    style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              _ubahButton(() {}),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    controller.unit.value,
                    style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.brandGreen, width: 1.5),
                ),
                child: Text(
                  'TERPILIH',
                  style: GoogleFonts.inter(
                    color: AppColors.brandGreen,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJadwalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3EEE5),
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    controller.jadwalRingkas.value,
                    style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              _ubahButton(() {}),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _chip('SEN, RAB, JUM, SAB', Icons.calendar_today_rounded),
            _chip('07:00 - 15:00', Icons.schedule_rounded),
            _chip('POS + Stok', Icons.point_of_sale_rounded),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: AppColors.brandGreen,
                size: 14,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Validasi Absensi Pintar',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Karyawan check-in otomatis memverifikasi Face Match foto profil dan radius GPS gerobak keliling.',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    String? badgeText,
    Color? badgeColor,
    required TextEditingController textController,
    required IconData icon,
    String? prefixChip,
    Color? prefixChipColor,
    bool obscure = false,
    bool iconLeft = false,
    String? suffixBadgeText,
    Color? suffixBadgeColor,
    Widget? suffixWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? AppColors.primary).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: badgeColor ?? AppColors.primary,
                    width: 1,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    color: badgeColor ?? AppColors.primary,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(10),
            border: appBorder(),
            boxShadow: AppShadows.hard(2),
          ),
          child: Row(
            children: [
              if (iconLeft) ...[
                Icon(icon, color: AppColors.ink, size: 16),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  controller: textController,
                  obscureText: obscure,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              if (suffixBadgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: (suffixBadgeColor ?? AppColors.brandGreen)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: suffixBadgeColor ?? AppColors.brandGreen,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: suffixBadgeColor ?? AppColors.brandGreen,
                        size: 8,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        suffixBadgeText,
                        style: GoogleFonts.inter(
                          color: suffixBadgeColor ?? AppColors.brandGreen,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (suffixWidget != null) suffixWidget,
              if (prefixChip != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: prefixChipColor ?? AppColors.brandGreen,
                    borderRadius: BorderRadius.circular(6),
                    border: appBorder(1),
                  ),
                  child: Text(
                    prefixChip,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (!iconLeft) Icon(icon, color: AppColors.primary, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'PASSWORD',
              style: GoogleFonts.inter(
                color: AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Text(
                'WAJIB',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(10),
            border: appBorder(),
            boxShadow: AppShadows.hard(2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.ink,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => TextField(
                    controller: controller.password,
                    obscureText: !controller.showPassword.value,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () => controller.showPassword.value =
                      !controller.showPassword.value,
                  child: Icon(
                    controller.showPassword.value
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: AppColors.muted,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepItem(String label) {
    return SizedBox(
      width: 62,
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.brandGreen,
              shape: BoxShape.circle,
              border: appBorder(1),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.inter(
              color: AppColors.ink,
              fontSize: 7,
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepConnector() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18, left: 2, right: 2),
        child: SizedBox(
          height: 2,
          child: Row(
            children: List.generate(
              8,
              (i) => Expanded(
                child: Container(
                  height: 2,
                  color: i % 2 == 0 ? AppColors.brandGreen : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(50),
        border: appBorder(1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.ink, size: 10),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.ink,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ubahButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(50),
          border: appBorder(1.5),
        ),
        child: Text(
          'Ubah',
          style: GoogleFonts.inter(
            color: AppColors.ink,
            fontSize: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 12),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(
          top: BorderSide(color: AppColors.ink, width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.brandGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Status Kelengkapan:',
                style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Text(
                  '2/4 Bagian Terisi',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.simpanKaryawan,
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
                  const Icon(
                    Icons.person_add_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SIMPAN KARYAWAN',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HALAMAN DETAIL KARYAWAN (Smart Accordion Mode)
// ═══════════════════════════════════════════════════════════════════════════
class DetailKaryawanView extends StatefulWidget {
  final Map<String, dynamic> karyawan;
  const DetailKaryawanView({super.key, required this.karyawan});

  @override
  State<DetailKaryawanView> createState() => _DetailKaryawanViewState();
}

class _DetailKaryawanViewState extends State<DetailKaryawanView> {
  // State accordion (5 section, 1 & 3 terbuka default)
  final List<bool> _openSections = [true, false, true, false, false];

  // Penugasan rombong
  int _selectedRombong = 0;

  // Akses aplikasi
  bool _aksesPos = true;
  bool _aksesStok = true;
  bool _aksesLaporan = false;

  // Jadwal kerja
  final List<Map<String, dynamic>> _jadwalHari = [
    {'label': 'SEN', 'active': true},
    {'label': 'SEL', 'active': false},
    {'label': 'RAB', 'active': true},
    {'label': 'KAM', 'active': false},
    {'label': 'JUM', 'active': true},
    {'label': 'SAB', 'active': true},
    {'label': 'MIN', 'active': false},
  ];

  String get _nama => widget.karyawan['nama'] as String? ?? 'Andi Saputra';
  String get _initial => _nama.isNotEmpty ? _nama.substring(0, 1) : 'A';
  String get _role => widget.karyawan['role'] as String? ?? 'Barista';
  String get _rombongLabel =>
      widget.karyawan['rombong'] as String? ?? 'Rombong 01';
  String get _statusLabel =>
      ((widget.karyawan['status'] as String?) ?? 'aktif').toUpperCase();
  Color get _avatarColor =>
      (widget.karyawan['avatarColor'] as Color?) ?? const Color(0xFFFFE1EE);

  int get _jumlahHari => _jadwalHari.where((h) => h['active'] == true).length;

  void _toggleSection(int i) =>
      setState(() => _openSections[i] = !_openSections[i]);

  // ───────────────────────────────────────────
  // BUILD
  // ───────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                children: [
                  _buildSectionCard(
                    index: 0,
                    title: 'PROFIL & KINERJA',
                    subtitle: 'Identitas, status & performa hari ini',
                    badgeText: _statusLabel,
                    badgeColor: AppColors.brandGreen,
                    content: _profilKinerjaContent(),
                  ),
                  _buildSectionCard(
                    index: 1,
                    title: 'DATA PRIBADI & LOKASI',
                    subtitle: 'Kontak, alamat & tracking live',
                    badgeText: 'LENGKAP',
                    badgeColor: AppColors.brandGreen,
                    content: _dataLokasiContent(),
                  ),
                  _buildSectionCard(
                    index: 2,
                    title: 'PENUGASAN & ABSEN',
                    subtitle: 'Rombong aktif & validasi check-in',
                    badgeText: '1 AKTIF',
                    badgeColor: AppColors.brandGreen,
                    content: _penugasanAbsenContent(),
                  ),
                  _buildSectionCard(
                    index: 3,
                    title: 'JADWAL & AKSES APLIKASI',
                    subtitle: 'Hari kerja, shift & hak akses',
                    badgeText: '$_jumlahHari HARI',
                    badgeColor: const Color(0xFFFFB800),
                    badgeIcon: Icons.calendar_today_rounded,
                    content: _jadwalAksesContent(),
                  ),
                  _buildSectionCard(
                    index: 4,
                    title: 'ZONA BERBAHAYA',
                    subtitle: 'Tindakan berisiko tinggi',
                    badgeText: '!',
                    badgeColor: const Color(0xFFD32F2F),
                    badgeIcon: Icons.priority_high_rounded,
                    content: _zonaBerbahayaContent(),
                  ),
                  Center(
                    child: Text(
                      'OMG COFFEE · COFFEE KELILING',
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
          _buildBottomBar(context),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // HEADER
  // ───────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 18),
      child: Row(
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
          Expanded(
            child: Column(
              children: [
                Text(
                  'Detail Karyawan',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(color: Colors.black, offset: Offset(2, 2))
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 56,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                shape: BoxShape.circle,
                border: appBorder(),
                boxShadow: AppShadows.hard(2),
              ),
              child: const Icon(Icons.edit_rounded,
                  color: AppColors.ink, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // SECTION CARD ACCORDION
  // ───────────────────────────────────────────
  Widget _buildSectionCard({
    required int index,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    IconData? badgeIcon,
    required Widget content,
  }) {
    final isOpen = _openSections[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(16),
        border: appBorder(),
        boxShadow: AppShadows.hard(2),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleSection(index),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: appBorder(1.5),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: badgeColor, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (badgeIcon != null) ...[
                          Icon(badgeIcon, color: badgeColor, size: 10),
                          const SizedBox(width: 3),
                        ] else ...[
                          Icon(Icons.check_rounded,
                              color: badgeColor, size: 10),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          badgeText,
                          style: GoogleFonts.inter(
                            color: badgeColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      shape: BoxShape.circle,
                      border: appBorder(1.5),
                    ),
                    child: Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.ink,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              heightFactor: isOpen ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  // SECTION 1: PROFIL & KINERJA
  // ───────────────────────────────────────────
  Widget _profilKinerjaContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(12),
            border: appBorder(1.5),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _avatarColor,
                          shape: BoxShape.circle,
                          border: appBorder(1.5),
                        ),
                        child: Center(
                          child: Text(
                            _initial,
                            style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.brandGreen,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.appWhite, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _nama,
                                style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            _badge(_statusLabel, AppColors.brandGreen),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _badge(_role, AppColors.primary),
                            _badge(_rombongLabel, const Color(0xFFFFB800)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bergabung Mar 2025',
                          style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () =>
                            _snack('WhatsApp', 'Membuka chat WA ke $_nama...'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: AppColors.ink, width: 1.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone_rounded,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text('WhatsApp',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        onPressed: () => _snack(
                            'Riwayat Kerja', 'Halaman riwayat segera hadir.'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.appWhite,
                          side: const BorderSide(
                              color: AppColors.ink, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.history_rounded,
                                color: AppColors.ink, size: 14),
                            const SizedBox(width: 6),
                            Text('Riwayat Kerja',
                                style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(12),
            border: appBorder(1.5),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text('KINERJA HARI INI',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      )),
                  const Spacer(),
                  _badge('Shift Aktif', AppColors.brandGreen,
                      icon: Icons.bolt_rounded),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _kinerjaItem(Icons.punch_clock_rounded, '08:02', 'CHECK-IN',
                      const Color(0xFFFFB800)),
                  _verticalDivider(),
                  _kinerjaItem(Icons.receipt_long_rounded, '32', 'TRANSAKSI',
                      AppColors.primary),
                  _verticalDivider(),
                  _kinerjaItem(Icons.bar_chart_rounded, '480rb',
                      'OMZET HARI INI', AppColors.brandGreen),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  // SECTION 2: DATA PRIBADI & LOKASI
  // ───────────────────────────────────────────
  Widget _dataLokasiContent() {
    return Column(
      children: [
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
                  Text('DATA PRIBADI',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      )),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      shape: BoxShape.circle,
                      border: appBorder(1.5),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: AppColors.ink, size: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE1EE),
                      borderRadius: BorderRadius.circular(10),
                      border: appBorder(1.5),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: AppColors.ink, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NAMA LENGKAP',
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                            )),
                        Text(_nama,
                            style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            )),
                        const SizedBox(height: 6),
                        Text('ALAMAT',
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                            )),
                        Text('Jl. Melati No. 5, Bandung',
                            style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 6),
                        Text('NO. TELEPON',
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                            )),
                        Row(
                          children: [
                            Text('0812-3456-7890',
                                style: GoogleFonts.inter(
                                  color: AppColors.ink,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                )),
                            const SizedBox(width: 6),
                            _badge('WA', AppColors.brandGreen),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
                  Text('LOKASI LIVE',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      )),
                  const Spacer(),
                  _badge('LIVE', AppColors.brandGreen, icon: Icons.circle),
                ],
              ),
              const SizedBox(height: 2),
              Text('Diperbarui 2 menit lalu',
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 8),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EEE5),
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 24,
                      right: 48,
                      top: 76,
                      child: Container(
                        height: 3,
                        color: AppColors.brandGreen.withOpacity(0.6),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('$_nama • $_rombongLabel',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                    const Positioned(
                      right: 34,
                      top: 48,
                      child: Icon(Icons.location_on_rounded,
                          color: Color(0xFFD32F2F), size: 28),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.brandGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('Start 07:00',
                              style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 7,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.ink, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alun-Alun Kota (sisi utara)',
                            style: GoogleFonts.inter(
                              color: AppColors.ink,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            )),
                        Text('± 1.2 km dari titik awal rute',
                            style: GoogleFonts.inter(
                              color: AppColors.muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () =>
                            _snack('Rute', 'Membuka peta rute gerobak...'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: AppColors.ink, width: 1.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.navigation_rounded,
                                color: Colors.white, size: 12),
                            const SizedBox(width: 6),
                            Text('Lihat Rute Hari Ini',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () => _snack('Refresh', 'Lokasi diperbarui.'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.appWhite,
                        side:
                            const BorderSide(color: AppColors.ink, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.refresh_rounded,
                              color: AppColors.ink, size: 12),
                          const SizedBox(width: 4),
                          Text('Segarkan',
                              style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.shield_rounded,
                      color: AppColors.muted, size: 12),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tracking aktif hanya selama jam kerja & atas persetujuan karyawan',
                      style: GoogleFonts.inter(
                        color: AppColors.muted,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  // SECTION 3: PENUGASAN & ABSEN
  // ───────────────────────────────────────────
  Widget _penugasanAbsenContent() {
    return Column(
      children: [
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
                  Text('PENUGASAN ROMBONG',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      )),
                  const Spacer(),
                  _badge('1 ROMBONG AKTIF', AppColors.brandGreen),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                  'Pilih unit rombong keliling yang ditugaskan kepada karyawan ini',
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 8),
              _rombongOption(
                  0, 'Rombong 01', 'Rute Sisi Utara (Alun-Alun)', null),
              const SizedBox(height: 8),
              _rombongOption(
                  1, 'Rombong 02', 'Rute Stasiun Barat • Budi', null),
              const SizedBox(height: 8),
              _rombongOption(
                  2, 'Rombong 03', 'Standby di Gudang Pusat', 'TERSEDIA'),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
                  Text('ABSEN CHECK-IN',
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      )),
                  const Spacer(),
                  _badge('WAJIB', AppColors.brandGreen),
                ],
              ),
              const SizedBox(height: 2),
              Text('Karyawan harus foto wajah + lokasi saat check-in',
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(10),
                  border: appBorder(1.5),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE1EE),
                            borderRadius: BorderRadius.circular(8),
                            border: appBorder(1.5),
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.ink, size: 22),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.brandGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hari ini · 08:02',
                              style: GoogleFonts.inter(
                                color: AppColors.ink,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              )),
                          Text('Lokasi sesuai titik rute',
                              style: GoogleFonts.inter(
                                color: AppColors.muted,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                    _badge('WAJAH COCOK', AppColors.brandGreen),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text('RIWAYAT MINGGU INI',
                  style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 6),
              Row(
                children: [
                  _absenDay('SEN', '07:58'),
                  const SizedBox(width: 8),
                  _absenDay('RAB', '08:01'),
                  const SizedBox(width: 8),
                  _absenDay('JUM', '07:55'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  // SECTION 4: JADWAL & AKSES APLIKASI
  // ───────────────────────────────────────────
  Widget _jadwalAksesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('JADWAL KERJA',
                style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                )),
            const Spacer(),
            Text('$_jumlahHari Hari / Minggu',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _jadwalHari.map((h) {
            final active = h['active'] as bool;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.appWhite,
                borderRadius: BorderRadius.circular(8),
                border: appBorder(1.5),
              ),
              child: Text(h['label'] as String,
                  style: GoogleFonts.inter(
                    color: active ? Colors.white : AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  )),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3D6),
            borderRadius: BorderRadius.circular(10),
            border: appBorder(1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC94D),
                  borderRadius: BorderRadius.circular(8),
                  border: appBorder(1.5),
                ),
                child: const Icon(Icons.wb_sunny_rounded,
                    color: AppColors.ink, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shift Pagi (Gerobak Keliling)',
                        style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        )),
                    Text('07:00 - 15:00 WIB',
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
              _badge('8 Jam / Hari', const Color(0xFFFFB800)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text('AKSES APLIKASI',
            style: GoogleFonts.inter(
              color: AppColors.ink,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(12),
            border: appBorder(1.5),
          ),
          child: Column(
            children: [
              _aksesToggle(
                Icons.point_of_sale_rounded,
                const Color(0xFFFFE1EE),
                'Aplikasi POS (Kasir)',
                'Input pesanan & proses pembayaran',
                _aksesPos,
                (v) => setState(() => _aksesPos = v),
              ),
              Divider(
                  height: 12,
                  thickness: 1,
                  color: AppColors.ink.withOpacity(0.1)),
              _aksesToggle(
                Icons.inventory_2_rounded,
                const Color(0xFFFFF3D6),
                'Input Stok Harian',
                'Cek sisa bahan & barang gerobak',
                _aksesStok,
                (v) => setState(() => _aksesStok = v),
              ),
              Divider(
                  height: 12,
                  thickness: 1,
                  color: AppColors.ink.withOpacity(0.1)),
              _aksesToggle(
                Icons.bar_chart_rounded,
                const Color(0xFFE3EEE5),
                'Lihat Laporan Keuangan',
                'Hanya dapat diakses owner & investor',
                _aksesLaporan,
                (v) => setState(() => _aksesLaporan = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  // SECTION 5: ZONA BERBAHAYA
  // ───────────────────────────────────────────
  Widget _zonaBerbahayaContent() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton(
            onPressed: () => _snack('Info', '$_nama dinonaktifkan sementara.'),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF3D6),
              side: const BorderSide(color: AppColors.ink, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.block_rounded, color: AppColors.ink, size: 14),
                const SizedBox(width: 6),
                Text('Nonaktifkan Sementara',
                    style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Hapus Karyawan?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content:
                      Text('Data $_nama akan dihapus permanen dari sistem.'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(); // Tutup dialog
                        Get.back(); // Kembali ke halaman sebelumnya
                        _snack('Terhapus', 'Karyawan telah dihapus.');
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFFFE1EE),
              side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFD32F2F), size: 14),
                const SizedBox(width: 6),
                Text('Hapus Karyawan',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFD32F2F),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  // HELPER WIDGETS
  // ───────────────────────────────────────────
  Widget _badge(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 8),
            const SizedBox(width: 3),
          ],
          Text(text,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 7,
                fontWeight: FontWeight.w800,
              )),
        ],
      ),
    );
  }

  Widget _kinerjaItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.outfit(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              )),
          Text(label,
              style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: 7,
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
        width: 1,
        height: 36,
        color: AppColors.ink.withOpacity(0.15),
      );

  Widget _rombongOption(
      int index, String title, String subtitle, String? badge) {
    final selected = _selectedRombong == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedRombong = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6B4F3A) : AppColors.appWhite,
          borderRadius: BorderRadius.circular(10),
          border: appBorder(1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.15)
                    : AppColors.appWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected ? Colors.white : AppColors.ink,
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.storefront_rounded,
                  color: selected ? Colors.white : AppColors.ink, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: GoogleFonts.inter(
                            color: selected ? Colors.white : AppColors.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          )),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white.withOpacity(0.2)
                                : AppColors.muted.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(badge,
                              style: GoogleFonts.inter(
                                color:
                                    selected ? Colors.white : AppColors.muted,
                                fontSize: 6,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                        color: selected ? Colors.white70 : AppColors.muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                shape: BoxShape.circle,
                border: appBorder(1.5),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.brandGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _absenDay(String day, String time) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3D6),
            borderRadius: BorderRadius.circular(8),
            border: appBorder(1.5),
          ),
          child: Stack(
            children: [
              const Center(
                child:
                    Icon(Icons.person_rounded, color: AppColors.ink, size: 18),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('$day $time',
            style: GoogleFonts.inter(
              color: AppColors.muted,
              fontSize: 7,
              fontWeight: FontWeight.w700,
            )),
      ],
    );
  }

  Widget _aksesToggle(
    IconData icon,
    Color tint,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(8),
              border: appBorder(1.5),
            ),
            child: Icon(icon, color: AppColors.ink, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    )),
                Text(subtitle,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.brandGreen,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 12),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Get.snackbar('Berhasil', 'Perubahan data karyawan disimpan!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP);
          },
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
              const Icon(Icons.save_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('SIMPAN PERUBAHAN',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(String title, String msg) {
    Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);
  }
}
