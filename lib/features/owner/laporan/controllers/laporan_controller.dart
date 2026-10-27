import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_dialogs.dart';

class LaporanController extends GetxController {
  final periode = 'Harian'.obs;
  final tanggalRange = '10 - 16 Sep'.obs;

  final Map<String, Map<String, String>> summaries = {
    'Harian': {
      'lababersih': 'Rp 1.89jt',
      'omzet': 'Rp 3.15jt',
      'cost': 'Rp 1.26jt',
      'transaksi': '100 transaksi • Rp 31rb/trans',
      'trend': '+8% vs kemarin',
    },
    'Mingguan': {
      'lababersih': 'Rp 12.4jt',
      'omzet': 'Rp 21.0jt',
      'cost': 'Rp 8.6jt',
      'transaksi': '640 transaksi • Rp 32rb/trans',
      'trend': '+12% vs minggu lalu',
    },
    'Bulanan': {
      'lababersih': 'Rp 48.2jt',
      'omzet': 'Rp 82.5jt',
      'cost': 'Rp 34.3jt',
      'transaksi': '2.6k transaksi • Rp 31rb/trans',
      'trend': '+5% vs bulan lalu',
    },
  };

  Map<String, String> get summary => summaries[periode.value]!;

  final laporanList = <Map<String, dynamic>>[
    {
      'judul': 'Penjualan',
      'desc': 'Grafik harian & performa penjualan per menu',
      'icon': Icons.bar_chart_rounded,
      'warna': const Color(0xFFEF2B7C),
      'badge': 12,
    },
    {
      'judul': 'Keuangan',
      'desc': 'Rekap modal, pengeluaran & laba bersih',
      'icon': Icons.account_balance_wallet_rounded,
      'warna': const Color(0xFF2D7A4F),
      'badge': 4,
    },
    {
      'judul': 'Stok',
      'desc': 'Validasi stok, adjustment & bahan kritis',
      'icon': Icons.inventory_2_rounded,
      'warna': const Color(0xFFFFB800),
      'badge': 3,
    },
    {
      'judul': 'Operasional & Audit',
      'desc': 'Absensi karyawan & hasil audit harian',
      'icon': Icons.verified_user_rounded,
      'warna': const Color(0xFF2D7A4F),
      'badge': 5,
    },
    {
      'judul': 'Analitik Lokasi',
      'desc': 'Persebaran penjualan per titik rombong',
      'icon': Icons.place_rounded,
      'warna': const Color(0xFFFFB800),
      'badge': 2,
    },
    {
      'judul': 'Log Aktivitas',
      'desc': 'Catatan tindakan sistem & owner',
      'icon': Icons.history_rounded,
      'warna': const Color(0xFF3A3A3A),
      'badge': 8,
    },
  ].obs;

  void pilihPeriode(String p) => periode.value = p;

  void bukaRincian(Map l) => AppDialogs.showCustomSnackbar(
        title: l['judul'] as String,
        message: 'Detail laporan segera hadir.',
        type: SnackbarType.info,
      );

  void unduhLaporan() => AppDialogs.showCustomSnackbar(
        title: 'Unduh Laporan',
        message: 'Laporan PDF sedang disiapkan.',
        type: SnackbarType.info,
      );

  void kirimInvestor() => AppDialogs.showCustomSnackbar(
        title: 'Berhasil',
        message: 'Laporan terkirim ke 2 investor.',
        type: SnackbarType.success,
      );
}
