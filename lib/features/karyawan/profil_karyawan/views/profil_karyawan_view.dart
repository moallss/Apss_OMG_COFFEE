import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/profil_karyawan_controller.dart';

// --- PALET BRUTALISME OMG COFFEE (KONSISTEN) ---
const Color _ink = Color(0xFF1A1A1A); // Hitam Pekat (Ink)
const Color _paper = Color(0xFFFFFFFF); // Putih Kertas
const Color _cream = Color(0xFFFAF9F6); // Krem Latar Belakang Page
const Color _pink = Color(0xFFEF2B7C); // Pink Neon (Primary Accent)
const Color _yellow = Color(0xFFFFC94D); // Kuning Emas (Warning/Accent)
const Color _green = Color(0xFF2D7A4F); // Hijau Tua (Success/Status)
const Color _red = Color(0xFFD32F2F); // Merah Darah (Danger)

Border _bdr([double w = 2]) => Border.all(color: _ink, width: w);
List<BoxShadow> _hard([double o = 4]) =>
    [BoxShadow(color: _ink, offset: Offset(o, o), blurRadius: 0)];

class ProfilKaryawanView extends GetView<ProfilKaryawanController> {
  const ProfilKaryawanView({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final navGap = 104.0 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          // ============ 1. HEADER PINK SOLID ============
          Positioned(
            top: 0, left: 0, right: 0,
            height: topPad + 100, // Header sedikit diperpendek
            child: Container(
              color: _pink,
              padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROFIL',
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text('IDENTITAS KASIR',
                          style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                    ],
                  ),
                  GestureDetector(
                    onTap: controller.bukaPengaturan,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _paper,
                        borderRadius: BorderRadius.circular(8),
                        border: _bdr(2),
                        boxShadow: _hard(2),
                      ),
                      child: const Icon(Icons.settings_rounded,
                          color: _ink, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============ 2. KONTEN UTAMA ============
          Positioned(
            top: topPad + 70,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, navGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---- SECTION 1: KARTU IDENTITAS (AVATAR BULAT & INFO POLOS) ----
                  _buildIdentityCardCompact(),
                  const SizedBox(height: 16), // Jarak antar section dikurangi

                  // ---- SECTION 2: DATA DIRI TERPADU (1 CARD BIG) ----
                  _buildUnifiedContactCard(),
                  const SizedBox(height: 16),

                  // ---- SECTION 3: OPERASIONAL HARI INI (HEADER INSIDE CARD) ----
                  _buildOperationalCardWithHeader(),
                  const SizedBox(height: 16),

                  // ---- SECTION 4: INFO BRAND (HEADER INSIDE CARD) ----
                  _buildBusinessInfoCardWithHeader(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // WIDGET HELPERS (OPTIMIZED SPACE)
  // ==========================================

  // CARD 1: IDENTITAS KOMPAK
  Widget _buildIdentityCardCompact() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(14),
        border: _bdr(2),
        boxShadow: _hard(4),
      ),
      child: Row(
        children: [
          // Avatar Bulat
          Obx(() => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // ✅ BULAT SESUAI SARAN
                  color: _yellow,
                  border: _bdr(2),
                  image: controller.fotoUrl.value.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(controller.fotoUrl.value),
                          fit: BoxFit.cover)
                      : null,
                ),
                child: controller.fotoUrl.value.isEmpty
                    ? Center(
                        child: Text(controller.initial.value,
                            style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: _ink)))
                    : null,
              )),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama
                Obx(() => Text(controller.nama.value.toUpperCase(),
                    style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: _ink))),

                const SizedBox(height: 4),

                // Badge Role & Status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _pink,
                        borderRadius: BorderRadius.circular(4),
                        border: _bdr(1),
                      ),
                      child: Text(controller.role.value.toUpperCase(),
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: _green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Obx(() => Text(controller.status.value.toUpperCase(),
                        style: GoogleFonts.inter(
                            color: _green,
                            fontSize: 8,
                            fontWeight: FontWeight.w900))),
                  ],
                ),

                const SizedBox(height: 6),

                // ✅ INFO POLOS TANPA BACKGROUND BUNGKUSAN
                Obx(() => Text(
                    'ID: ${controller.idKaryawan.value} • ${controller.bergabung.value}',
                    style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600]))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CARD 2: DATA DIRI TERPADU (GRID DALAM SATU CARD)
  Widget _buildUnifiedContactCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(14),
        border: _bdr(2),
        boxShadow: _hard(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section Di Dalam Card
          Text('DATA DIRI',
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: _ink,
                  letterSpacing: 1)),

          const SizedBox(height: 12),

          // Grid Kontak
          Column(
            children: [
              // Baris 1: WA & Email (Side by Side)
              Row(
                children: [
                  Expanded(
                    child: _miniContactItem(Icons.phone_android_rounded,
                        'WHATSAPP', controller.telepon.value, _green),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _miniContactItem(Icons.email_rounded, 'EMAIL',
                        controller.email.value, _pink),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Baris 2: Domisili (Full Width)
              _miniContactItem(Icons.location_on_rounded, 'DOMISILI',
                  controller.alamat.value, _yellow,
                  fullWidth: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniContactItem(
      IconData icon, String label, String value, Color accentColor,
      {bool fullWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _cream, // Background subtile untuk membedakan dari card utama
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _ink.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, size: 14, color: accentColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[500])),
                const SizedBox(height: 2),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CARD 3: OPERASIONAL DENGAN HEADER INTERNAL
  Widget _buildOperationalCardWithHeader() {
    return Container(
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(14),
        border: _bdr(2),
        boxShadow: _hard(4),
      ),
      child: Column(
        children: [
          // Header Internal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _ink.withOpacity(
                  0.03), // Sedikit abu-abu very light untuk pemisah visual
              border: Border(bottom: BorderSide(color: _ink.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment_ind_outlined,
                    size: 14, color: _ink),
                const SizedBox(width: 6),
                Text('OPERASIONAL HARI INI',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: _ink,
                        letterSpacing: 0.5)),
              ],
            ),
          ),

          // List Item
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: [
                _opRowSimple(Icons.local_shipping_rounded, 'ROMBONG',
                    controller.rombong.value),
                _dividerThin(),
                _opRowSimple(Icons.schedule_rounded, 'SHIFT KERJA',
                    '${controller.shift.value} • ${controller.jamShift.value}'),
                _dividerThin(),
                _opRowSimple(Icons.map_rounded, 'RUTE JUALAN',
                    controller.ruteDetail.value,
                    multiline: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _opRowSimple(IconData icon, String label, String value,
      {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[500])),
                const SizedBox(height: 1),
                Text(value,
                    maxLines: multiline ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerThin() {
    return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: _ink.withOpacity(0.05));
  }

  // CARD 4: BUSINESS INFO DENGAN HEADER INTERNAL
  Widget _buildBusinessInfoCardWithHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.circular(14),
        border: _bdr(2),
        boxShadow: _hard(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Internal
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    color: _pink,
                    borderRadius: BorderRadius.circular(6),
                    border: _bdr(1)),
                child: const Icon(Icons.coffee_rounded,
                    color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text('INFO BRAND',
                  style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.w900, color: _ink)),
            ],
          ),

          const SizedBox(height: 10),

          Text('OMG COFFEE - Kopi Keliling Premium Sejak 2024.',
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  height: 1.3)),

          const SizedBox(height: 12),

          // Social Links Compact
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _socialChipSmall(Icons.language_rounded, 'omgcoffee.id'),
              _socialChipSmall(Icons.camera_alt_rounded, '@omg.coffee'),
              _socialChipSmall(Icons.music_note_rounded, '@omgcoffeekeliling'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialChipSmall(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _ink.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: _ink),
          const SizedBox(width: 3),
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 8, fontWeight: FontWeight.w700, color: _ink)),
        ],
      ),
    );
  }
}
