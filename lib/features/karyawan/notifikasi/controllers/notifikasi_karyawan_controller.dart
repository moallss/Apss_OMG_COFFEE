import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifikasiKaryawanController extends GetxController {
  // ===== DATA ASLI (tidak diubah strukturnya) =====
  final notifikasiList = <Map<String, dynamic>>[
    {
      'id': 1,
      'tipe': 'distribusi',
      'icon': 'inventory_2_rounded',
      'judul': 'Distribusi Bahan Baku Tiba',
      'pesan':
          'Kopi Arabica 5kg & Susu UHT 10L sudah di gerobak. Segera konfirmasi.',
      'waktu': '10 menit lalu',
      'read': false,
    },
    {
      'id': 2,
      'tipe': 'stok',
      'icon': 'warning_amber_rounded',
      'judul': 'Stok Kritis: Cup 16oz',
      'pesan':
          'Stok cup 16oz tersisa 12 pcs. Segera lapor ke owner untuk restock.',
      'waktu': '1 jam lalu',
      'read': false,
    },
    {
      'id': 3,
      'tipe': 'closing',
      'icon': 'lock_clock_rounded',
      'judul': 'Closing Shift Dimulai',
      'pesan':
          'Shift malam sudah waktunya closing. Silakan tutup kasir sekarang.',
      'waktu': '2 jam lalu',
      'read': true,
    },
    {
      'id': 4,
      'tipe': 'info',
      'icon': 'info_rounded',
      'judul': 'Rombong 01 Beroperasi',
      'pesan':
          'Check-in berhasil. Rombong 01 siap beroperasi di rute Alun-Alun Utara.',
      'waktu': 'Kemarin',
      'read': true,
    },
    {
      'id': 5,
      'tipe': 'promo',
      'icon': 'local_offer_rounded',
      'judul': 'Promo Spesial Hari Ini',
      'pesan': 'Diskon 20% untuk semua menu kopi. Aktif sampai pukul 12:00.',
      'waktu': 'Kemarin',
      'read': true,
    },
  ].obs;

  // ===== FILTER (dibutuhkan view) =====
  final filterAktif = 'Semua'.obs;

  void pilihFilter(String f) {
    filterAktif.value = f;
    notifikasiList.refresh();
  }

  // ===== PROYEKSI: Map mentah -> shape yang dibaca view owner =====
  Map<String, dynamic> _projeksi(Map<String, dynamic> raw) {
    final read = raw['read'] as bool? ?? false;
    final tipe = (raw['tipe'] as String? ?? 'info');
    return {
      'id': raw['id'],
      'unread': !read,
      'butuhAksi': tipe == 'distribusi' || tipe == 'stok',
      'warna': _warnaTipe(tipe),
      'icon': _ikonTipe(raw['icon'] as String?),
      'judul': raw['judul'] as String? ?? '',
      'waktu': raw['waktu'] as String? ?? '',
      'deskripsi': raw['pesan'] as String? ?? '',
      'kategori': tipe.toUpperCase(),
    };
  }

  Color _warnaTipe(String tipe) {
    switch (tipe) {
      case 'distribusi':
        return const Color(0xFFFFB800);
      case 'stok':
        return const Color(0xFFD32F2F);
      case 'closing':
        return const Color(0xFF7C4DFF);
      case 'promo':
        return const Color(0xFFEF2B7C);
      default:
        return const Color(0xFF2D7A4F);
    }
  }

  IconData _ikonTipe(String? key) {
    switch (key) {
      case 'inventory_2_rounded':
        return Icons.inventory_2_rounded;
      case 'warning_amber_rounded':
        return Icons.warning_amber_rounded;
      case 'lock_clock_rounded':
        return Icons.lock_clock_rounded;
      case 'local_offer_rounded':
        return Icons.local_offer_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  List<Map<String, dynamic>> _terfilter() {
    final src = notifikasiList.toList(); // salinan aman, tetap ter-track Obx
    final f = filterAktif.value;
    Iterable<Map<String, dynamic>> base = src;
    if (f == 'Belum Dibaca') {
      base = src.where((e) => (e['read'] as bool? ?? false) == false);
    } else if (f != 'Semua') {
      base = src.where((e) =>
          ((e['tipe'] as String? ?? '').toUpperCase() == f.toUpperCase()));
    }
    return base.map(_projeksi).toList();
  }

  // ===== GETTER yang dibaca view =====
  List<Map<String, dynamic>> get hariIni =>
      _terfilter().where((n) => n['waktu'] != 'Kemarin').toList();

  List<Map<String, dynamic>> get kemarin =>
      _terfilter().where((n) => n['waktu'] == 'Kemarin').toList();

  int get belumDibacaCount => notifikasiList
      .where((e) => (e['read'] as bool? ?? false) == false)
      .length;

  int get baruHariIni => hariIni.where((n) => n['unread'] == true).length;

  // ===== AKSI (non-destructive: tandaiBaca terima int ATAU Map) =====
  int _idDari(dynamic ref) {
    if (ref is Map) return ref['id'] as int;
    return ref as int;
  }

  void tandaiBaca(dynamic ref) {
    final id = _idDari(ref);
    final idx = notifikasiList.indexWhere((e) => e['id'] == id);
    if (idx >= 0) {
      final item = Map<String, dynamic>.from(notifikasiList[idx]);
      item['read'] = true;
      notifikasiList[idx] = item;
      notifikasiList.refresh();
    }
  }

  void tandaiSemuaBaca() {
    notifikasiList.assignAll(notifikasiList.map((e) {
      final item = Map<String, dynamic>.from(e);
      item['read'] = true;
      return item;
    }).toList());
  }

  void hapusNotifikasi(dynamic ref) {
    final id = _idDari(ref);
    notifikasiList.removeWhere((e) => e['id'] == id);
    notifikasiList.refresh();
  }

  void hapusSemua() {
    notifikasiList.clear();
    notifikasiList.refresh();
  }
}
