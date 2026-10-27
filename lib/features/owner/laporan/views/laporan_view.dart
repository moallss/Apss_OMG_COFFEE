import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({super.key});

  static const Color _yellow = Color(0xFFFFC53D);
  static const Color _green = Color(0xFF2D7A4F);
  static const Color _greenTint = Color(0xFFE3EFE6);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.primary,
              padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Laporan',
                                style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    shadows: const [
                                      Shadow(
                                          color: AppColors.ink,
                                          offset: Offset(2, 2))
                                    ])),
                            const SizedBox(height: 4),
                            Text('Ringkasan performa usaha',
                                style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.unduhLaporan,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: _yellow,
                            shape: BoxShape.circle,
                            border: appBorder(),
                            boxShadow: AppShadows.hard(2),
                          ),
                          child: const Icon(Icons.download_rounded,
                              color: AppColors.ink, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => Container(
                              height: 42, // ✅ tinggi fix
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.appWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: appBorder(),
                                boxShadow: AppShadows.hard(2),
                              ),
                              child: Row(
                                children: [
                                  _segmen('Harian'),
                                  _segmen('Mingguan'),
                                  _segmen('Bulanan'),
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 42, // ✅ tinggi fix sama
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.appWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: appBorder(),
                          boxShadow: AppShadows.hard(2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                color: AppColors.ink, size: 10),
                            const SizedBox(width: 6),
                            Obx(() => Text(controller.tanggalRange.value,
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ringkasanCard(),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SEMUA LAPORAN',
                                style: GoogleFonts.inter(
                                    color: AppColors.ink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8)),
                            const SizedBox(height: 2),
                            Text('Ketuk untuk melihat detail lengkap',
                                style: GoogleFonts.inter(
                                    color: AppColors.muted,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                          border: appBorder(1.5),
                        ),
                        child: Obx(() => Text(
                            '${controller.laporanList.length} laporan',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w900))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Column(
                        children: [
                          for (var i = 0;
                              i < controller.laporanList.length;
                              i += 2)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        child: _laporanCard(
                                            controller.laporanList[i])),
                                    const SizedBox(width: 12),
                                    if (i + 1 < controller.laporanList.length)
                                      Expanded(
                                          child: _laporanCard(
                                              controller.laporanList[i + 1])),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _greenTint,
                      borderRadius: BorderRadius.circular(16),
                      border: appBorder(),
                      boxShadow: AppShadows.hard(3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _green,
                                borderRadius: BorderRadius.circular(10),
                                border: appBorder(1.5),
                              ),
                              child: const Icon(Icons.handshake_rounded,
                                  color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Paket Transparansi Investor',
                                      style: GoogleFonts.inter(
                                          color: AppColors.ink,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 2),
                                  Text(
                                      'Investor mendapat laporan otomatis tiap minggu',
                                      style: GoogleFonts.inter(
                                          color: AppColors.muted,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: controller.kirimInvestor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _green,
                              borderRadius: BorderRadius.circular(12),
                              border: appBorder(1.5),
                              boxShadow: AppShadows.hard(2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded,
                                    color: Colors.white, size: 12),
                                const SizedBox(width: 6),
                                Text('Kirim ke Investor',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _segmen(String label) {
    final active = controller.periode.value == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.pilihPeriode(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
                color: active ? AppColors.ink : Colors.transparent, width: 1.5),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: active ? Colors.white : AppColors.ink,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900)),
          ),
        ),
      ),
    );
  }

  Widget _ringkasanCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _yellow,
            borderRadius: BorderRadius.circular(16),
            border: appBorder(),
            boxShadow: AppShadows.hard(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Row 1: Judul + pill trend HIJAU (pindah ke atas)
              Row(
                children: [
                  Text('RINGKASAN KEUANGAN',
                      style: GoogleFonts.inter(
                          color: AppColors.ink,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(controller.summary['trend']!,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ✅ Row 2: Laba besar SAJA (tanpa pill hijau di sini)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL LABA BERSIH',
                      style: GoogleFonts.inter(
                          color: AppColors.ink.withOpacity(0.7),
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 2),
                  Text(controller.summary['lababersih']!,
                      style: GoogleFonts.outfit(
                          color: AppColors.ink,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1)),
                ],
              ),
              const SizedBox(height: 12),
              // ✅ Row 3: 2 mini stat
              Row(
                children: [
                  Expanded(
                      child: _miniStat('OMZET', controller.summary['omzet']!)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _miniStat(
                          'BIAYA OPERASIONAL', controller.summary['cost']!)),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _miniStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(12),
        border: appBorder(1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.muted,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8)),
          const SizedBox(height: 3),
          Text(value,
              style: GoogleFonts.inter(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _laporanCard(Map l) {
    return GestureDetector(
      onTap: () => controller.bukaRincian(l),
      child: Container(
        padding: const EdgeInsets.all(12),
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
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: l['warna'] as Color,
                    borderRadius: BorderRadius.circular(10),
                    border: appBorder(1.5),
                  ),
                  child: Icon(l['icon'] as IconData,
                      color: Colors.white, size: 16),
                ),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: appBorder(1),
                  ),
                  child: Text('${l['badge']}',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(l['judul'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Expanded(
              child: Text(l['desc'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EDE3),
                borderRadius: BorderRadius.circular(
                    10), // ✅ radius kecil = persegi panjang
                border: appBorder(1.5), // ✅ border hitam brutalisme
                boxShadow: AppShadows.hard(2), // ✅ shadow keras brutalisme
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Buka Rincian',
                      style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.primary, size: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
