// PATH FILE: lib/features/owner/profil/views/profil_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // ============================================
          // 1. HEADER PINK
          // ============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + 130,
            child: _buildHeader(context),
          ),

          // ============================================
          // 2. CONTENT
          // ============================================
          Positioned(
            top: topPad + 78,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfilCard(),
                  const SizedBox(height: 12),
                  _buildKontakSingkatCard(),
                  const SizedBox(height: 12),
                  _buildProfilUsahaCard(),
                  const SizedBox(height: 12),
                  _buildKontakDetailCard(),
                  const SizedBox(height: 12),
                  _buildFooterInfo(),
                  const SizedBox(height: 14),
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
          ),
        ],
      ),
    );
  }

  // ========== HEADER ==========
  Widget _buildHeader(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: topPad + 18,
        bottom: 60,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('Profil',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(color: Colors.black, offset: Offset(2, 2))
                    ])),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                shape: BoxShape.circle,
                border: appBorder(),
                boxShadow: AppShadows.hard(2),
              ),
              child: const Icon(Icons.settings_rounded,
                  color: AppColors.ink, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ========== CARD PROFIL OWNER ==========
  Widget _buildProfilCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Row(
        children: [
          // Foto Profile Orang
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5E5),
              shape: BoxShape.circle,
              border: appBorder(1.5),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/150?u=bages',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFFFD93D),
                  child: Center(
                    child: Text('B',
                        style: GoogleFonts.outfit(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(controller.namaOwner.value,
                    style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900))),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: appBorder(1),
                  ),
                  child: Obx(() => Text(controller.roleOwner.value,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== CARD KONTAK SINGKAT ==========
  Widget _buildKontakSingkatCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Row(
        children: [
          Expanded(
            child: _kontakItem(
                Icons.phone_rounded, 'Telepon', controller.telepon.value,
                iconColor: const Color(0xFFE74C3C),
                bgColor: const Color(0xFFFFEBE5)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _kontakItem(
                Icons.email_rounded, 'Email', controller.email.value,
                iconColor: const Color(0xFFFFD93D),
                bgColor: const Color(0xFFFFF9E5)),
          ),
        ],
      ),
    );
  }

  Widget _kontakItem(IconData icon, String label, String value,
      {required Color iconColor, required Color bgColor}) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: appBorder(1),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }

  // ========== CARD PROFIL USAHA ==========
  Widget _buildProfilUsahaCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('PROFIL USAHA',
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen,
                  borderRadius: BorderRadius.circular(6),
                  border: appBorder(1),
                ),
                child: Text('Identitas Bisnis',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.ink, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          _usahaItem(
              Icons.business_rounded, 'Nama usaha', controller.namaUsaha.value,
              iconColor: const Color(0xFF8B4513),
              bgColor: const Color(0xFFF5E6D3)),
          const SizedBox(height: 10),
          _usahaItem(Icons.location_on_rounded, 'Lokasi usaha',
              controller.lokasiUsaha.value,
              iconColor: const Color(0xFFE74C3C),
              bgColor: const Color(0xFFFFEBE5)),
          const SizedBox(height: 10),
          _usahaItem(Icons.access_time_rounded, 'Jam operasional',
              controller.jamOperasional.value,
              iconColor: const Color(0xFF3498DB),
              bgColor: const Color(0xFFE8F4F8)),
        ],
      ),
    );
  }

  Widget _usahaItem(IconData icon, String label, String value,
      {required Color iconColor, required Color bgColor}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: appBorder(1),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.inter(
                      color: AppColors.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }

  // ========== CARD KONTAK DETAIL (TANPA EMAIL BISNIS) ==========
  Widget _buildKontakDetailCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(14),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INFORMASI KONTAK',
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _kontakDetailItem(
                    Icons.email_rounded, 'Email', controller.emailPribadi.value,
                    iconColor: const Color(0xFFE74C3C),
                    bgColor: const Color(0xFFFFEBE5)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _kontakDetailItem(Icons.phone_rounded, 'Telepon',
                    controller.teleponBisnis.value,
                    iconColor: const Color(0xFF27AE60),
                    bgColor: const Color(0xFFE8F8F0)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _kontakDetailItem(
                    Icons.language_rounded, 'Website', controller.website.value,
                    iconColor: const Color(0xFF3498DB),
                    bgColor: const Color(0xFFE8F4F8)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _kontakDetailItem(Icons.camera_alt_rounded, 'Instagram',
                    controller.instagram.value,
                    iconColor: const Color(0xFFE1306C),
                    bgColor: const Color(0xFFFFF0F5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kontakDetailItem(IconData icon, String label, String value,
      {required Color iconColor, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: appBorder(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // ========== FOOTER INFO ==========
  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E5),
        borderRadius: BorderRadius.circular(12),
        border: appBorder(1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.muted, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                'Data ini dipakai otomatis di struk, laporan investor dan notifikasi merchant CMS.',
                style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    height: 1.3)),
          ),
        ],
      ),
    );
  }
}
