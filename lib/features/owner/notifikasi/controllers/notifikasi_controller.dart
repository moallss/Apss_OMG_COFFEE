// PATH FILE: lib/features/owner/notifikasi/controllers/notifikasi_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_dialogs.dart';

class NotifikasiController extends GetxController {
  final filterAktif = 'Semua'.obs;

  final notifikasiList = <Map<String, dynamic>>[
    {
      'id': 'n1',
      'judul': 'Audit: Operasional Tidak Sesuai',
      'deskripsi': 'Selisih cash Rp 15.000 vs sistem — perlu verifikasi closing',
      'waktu': '06:58',
      'kategori': 'AUDIT',
      'icon': Icons.verified_user_rounded,
      'warna': const Color(0xFFD32F2F),
      'unread': true,
      'butuhAksi': true,
      'hari': 'today',
    },
    {
      'id': 'n2',
      'judul': 'Kopi Bubuk Habis',
      'deskripsi': 'Stok mencapai 0 pcs — segera restock bahan baku',
      'waktu': '07:32',
      'kategori': 'STOK',
      'icon': Icons.inventory_2_rounded,
      'warna': const Color(0xFFD32F2F),
      'unread': true,
      'butuhAksi': false,
      'hari': 'today',
    },
    {
      'id': 'n3',
      'judul': 'Rina belum Check-In',
      'deskripsi': 'Shift pagi 07:00 belum melakukan check-in',
      'waktu': '07:05',
      'kategori': 'OPERASIONAL',
      'icon': Icons.group_rounded,
      'warna': const Color(0xFFEF2B7C),
      'unread': true,
      'butuhAksi': false,
      'hari': 'today',
    },
    {
      'id': 'n4',
      'judul': 'Stock Adjustment oleh Andi',
      'deskripsi': 'Susu UHT -500ml karena tumpah, foto bukti tersedia',
      'waktu': '14:22',
      'kategori': 'OPERASIONAL',
      'icon': Icons.inventory_2_rounded,
      'warna': const Color(0xFFFFB800),
      'unread': false,
      'butuhAksi': false,
      'hari': 'yesterday',
    },
    {
      'id': 'n5',
      'judul': 'Target harian tercapai',
      'deskripsi': 'Omzet Rp 1.250.000 melewati target Rp 1.000.000',
      'waktu': '11:00',
      'kategori': 'KEUANGAN',
      'icon': Icons.trending_up_rounded,
      'warna': const Color(0xFF2D7A4F),
      'unread': false,
      'butuhAksi': false,
      'hari': 'yesterday',
    },
    {
      'id': 'n6',
      'judul': 'Sinkronisasi gagal',
      'deskripsi': '3 transaksi pending, retry otomatis berjalan',
      'waktu': '19:40',
      'kategori': 'SISTEM',
      'icon': Icons.sync_problem_rounded,
      'warna': const Color(0xFFD32F2F),
      'unread': false,
      'butuhAksi': false,
      'hari': 'yesterday',
    },
    {
      'id': 'n7',
      'judul': 'Backup otomatis berhasil',
      'deskripsi': 'Backup harian tersimpan aman',
      'waktu': '23:00',
      'kategori': 'SISTEM',
      'icon': Icons.cloud_done_rounded,
      'warna': const Color(0xFF2D7A4F),
      'unread': false,
      'butuhAksi': false,
      'hari': 'yesterday',
    },
  ].obs;

  // ==========================================
  // COMPUTED
  // ==========================================
  int get belumDibacaCount =>
      notifikasiList.where((n) => n['unread'] == true).length;

  List<Map<String, dynamic>> get _filtered =>
      notifikasiList.where((n) {
        if (filterAktif.value == 'Semua') return true;
        if (filterAktif.value == 'Belum Dibaca') return n['unread'] == true;
        return n['kategori'] == filterAktif.value.toUpperCase();
      }).toList();

  List<Map<String, dynamic>> get hariIni =>
      _filtered.where((n) => n['hari'] == 'today').toList();

  List<Map<String, dynamic>> get kemarin =>
      _filtered.where((n) => n['hari'] == 'yesterday').toList();

  int get baruHariIni =>
      hariIni.where((n) => n['unread'] == true).length;

  // ==========================================
  // ACTIONS
  // ==========================================
  void pilihFilter(String f) => filterAktif.value = f;

  void tandaiBaca(Map n) {
    n['unread'] = false;
    notifikasiList.refresh();
  }

  void hapusNotifikasi(Map n) {
    notifikasiList.removeWhere((x) => x['id'] == n['id']);
    AppDialogs.showCustomSnackbar(
      title: 'Notifikasi Dihapus',
      message: '${n['judul']} telah dihapus.',
      type: SnackbarType.success,
    );
  }

  void tandaiSemuaBaca() {
    if (belumDibacaCount == 0) {
      AppDialogs.showCustomSnackbar(
        title: 'Notifikasi',
        message: 'Semua notifikasi sudah dibaca.',
        type: SnackbarType.info,
      );
      return;
    }
    for (final n in notifikasiList) {
      n['unread'] = false;
    }
    notifikasiList.refresh();
    AppDialogs.showCustomSnackbar(
      title: 'Berhasil',
      message: 'Semua notifikasi ditandai dibaca.',
      type: SnackbarType.success,
    );
  }

  void hapusSemua() {
    if (notifikasiList.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Notifikasi',
        message: 'Tidak ada notifikasi untuk dihapus.',
        type: SnackbarType.info,
      );
      return;
    }
    AppDialogs.showConfirmDialog(
      title: 'Hapus Semua Notifikasi',
      message:
          '${notifikasiList.length} notifikasi akan dihapus permanen.',
      confirmText: 'Ya, Hapus',
      cancelText: 'Batal',
      onConfirm: () {
        notifikasiList.clear();
        AppDialogs.showCustomSnackbar(
          title: 'Berhasil',
          message: 'Semua notifikasi telah dihapus.',
          type: SnackbarType.success,
        );
      },
    );
  }
}
