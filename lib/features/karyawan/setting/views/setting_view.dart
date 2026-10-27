import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/setting_controller.dart';

// Palet Brutalism Standard
const Color _ink = Color(0xFF1A1A1A);
const Color _paper = Color(0xFFFFFFFF);
const Color _cream = Color(0xFFFAF9F6);
const Color _pink = Color(0xFFEF2B7C);
const Color _green = Color(0xFF2D7A4F);
const Color _red = Color(0xFFD32F2F);
const Color _yellow = Color(0xFFFFC94D); // Untuk aksen warning/sunlight

Border _bdr([double w = 2]) => Border.all(color: _ink, width: w);
List<BoxShadow> _hard([double o = 4]) =>
    [BoxShadow(color: _ink, offset: Offset(o, o), blurRadius: 0)];

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // topPad tidak lagi dibutuhkan karena menggunakan SafeArea dan header fixed
    final navGap = 104.0 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // HEADER SEDERHANA (TANPA PINK BLOCK BESAR)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: _pink, // ✅ Header jadi Pink Solid
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _paper,
                        borderRadius: BorderRadius.circular(8),
                        border: _bdr(2),
                        boxShadow: _hard(2),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: _ink, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('PENGATURAN',
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)), // ✅ Teks jadi Putih Kontras
                ],
              ),
            ),

            // ==========================================
            // KONTEN UTAMA
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, navGap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SECTION 1: AKUN SAYA (PRIORITAS TERATAS)
                    _buildSectionCard(
                      title: 'AKUN SAYA',
                      icon: Icons.person_rounded,
                      children: [
                        _buildMenuTile(Icons.edit_note_rounded, 'Edit Profil',
                            'Nama, Foto, Kontak'),
                        _divider(),
                        _buildMenuTile(Icons.lock_outline_rounded,
                            'Ganti Password', 'Keamanan Akun'),
                        _divider(),
                        _buildMenuTile(Icons.location_on_rounded,
                            'Alamat Domisili', 'Untuk Logistik/Gaji'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // SECTION 2: TAMPILAN LAYAR (FITUR SPESIFIK)
                    _buildSectionCard(
                      title: 'TAMPILAN LAYAR',
                      icon: Icons.visibility_rounded,
                      children: [
                        // 1. Sunlight / Outdoor Mode
                        _buildBrutalSwitchTile(
                          label: 'SUNLIGHT MODE',
                          desc:
                              'Optimalkan visibilitas di bawah matahari terik.',
                          value: controller
                              .outdoorMode, // reuse var or create new one if needed
                          onChanged: (val) => controller.toggleOutdoorMode(val),
                          accentColor: _yellow,
                        ),
                        const SizedBox(height: 8),

                        // 2. High Contrast Mode
                        _buildBrutalSwitchTile(
                          label: 'HIGH CONTRAST',
                          desc:
                              'Hitam pekat & putih murni untuk keterbacaan maksimal.',
                          value: controller
                              .highContrast, // Pastikan ada di Controller
                          onChanged: (val) =>
                              controller.toggleHighContrast(val),
                          accentColor: _ink,
                        ),
                        const SizedBox(height: 8),

                        // 3. Sunlight-Friendly UI
                        _buildBrutalSwitchTile(
                          label: 'SUNLIGHT-FRIENDLY UI',
                          desc: 'Perbesar elemen tombol & teks utama.',
                          value: controller
                              .sunlightUi, // Pastikan ada di Controller
                          onChanged: (val) => controller.toggleSunlightUi(val),
                          accentColor: _pink,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // SECTION 3: SUARA & GETARAN
                    _buildSectionCard(
                      title: 'SUARA & GETARAN',
                      icon: Icons.volume_up_rounded,
                      children: [
                        _buildBrutalSwitchTile(
                          label: 'SUARA PEMBAYARAN',
                          desc: 'Bunyi "Ting!" saat QRIS lunas.',
                          value: controller.soundEnabled,
                          onChanged: (val) => controller.toggleSound(val),
                          accentColor: _green,
                        ),
                        const SizedBox(height: 8),
                        _buildBrutalSwitchTile(
                          label: 'GETARAN HAPTIC',
                          desc: 'HP bergetar saat transaksi sukses.',
                          value: controller.vibrationEnabled,
                          onChanged: (val) => controller.toggleVibration(val),
                          accentColor: _pink,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // SECTION 4: SISTEM & SINKRONISASI
                    _buildSectionCard(
                      title: 'SISTEM & DATA',
                      icon: Icons.sync_rounded,
                      children: [
                        _buildSyncStatusTile(),
                        const SizedBox(height: 8),
                        _buildMenuTile(Icons.cleaning_services_rounded,
                            'Bersihkan Cache', 'Hapus gambar menu lama'),
                        _divider(),
                        _buildInfoTile(Icons.info_outline_rounded,
                            'Versi Aplikasi', 'v1.0.0-beta'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // SECTION 5: LOGOUT
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET HELPERS (UPDATED STYLE)
  // ==========================================

  Widget _buildSectionCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(6),
                  border: _bdr(1),
                ),
                child: Icon(icon, size: 16, color: _ink),
              ),
              const SizedBox(width: 10),
              Text(title.toUpperCase(),
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: _ink,
                      letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // ✅ SWITCH TILE DENGAN BORDER HITAM TEBAK (BRUTAL STYLE)
  Widget _buildBrutalSwitchTile({
    required String label,
    required String desc,
    required RxBool value,
    required Function(bool) onChanged,
    required Color accentColor,
  }) {
    return Obx(() {
      final isOn = value.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          // ✅ Background tetap Putih/Krem terang agar teks terbaca jelas
          color: isOn ? _paper : _cream,
          borderRadius: BorderRadius.circular(10),
          // ✅ Border berubah warna menjadi aksen saat aktif untuk feedback visual
          border: Border.all(
            color: isOn ? accentColor : _ink,
            width: isOn ? 2.5 : 1.5,
          ),
          boxShadow: isOn ? _hard(2) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label.toUpperCase(),
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: _ink)),
                  const SizedBox(height: 2),
                  Text(desc,
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ],
              ),
            ),
            // Custom Switch Visual Brutal
            GestureDetector(
              onTap: () => onChanged(!isOn),
              child: Container(
                width: 44,
                height: 24,
                decoration: BoxDecoration(
                  color: isOn ? accentColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: _bdr(1.5), // Border hitam mengelilingi track switch
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment:
                      isOn ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _paper,
                      shape: BoxShape.circle,
                      border: _bdr(1), // Thumb juga punya border hitam tipis
                      boxShadow: _hard(1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: _ink),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _ink)),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusTile() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEE5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_done_rounded, color: _green, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TERSENCRON',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: _green)),
                Text('Terakhir: 2 menit lalu',
                    style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600])),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('SYNC NOW',
                style: GoogleFonts.inter(
                    fontSize: 9, fontWeight: FontWeight.w900, color: _green)),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[600])),
          ),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w800, color: _ink)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: _ink.withOpacity(0.1));
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        // Panggil dialog konfirmasi dari controller jika perlu
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _red,
          borderRadius: BorderRadius.circular(14),
          border: _bdr(2),
          boxShadow: _hard(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('KELUAR DARI AKUN',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}
