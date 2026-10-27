import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/utils/app_dialogs.dart';

class StokKritisController extends GetxController {
  final filterKategori = 'SEMUA ITEM'.obs;
  final filterStatus = 'Semua Status'.obs;

  final stokList = <Map<String, dynamic>>[
    {
      'id': 's1',
      'nama': 'Kopi Bubuk',
      'subtitle': 'Biji Robusta Blend',
      'kategori': 'BAHAN',
      'icon': 'coffee',
      'warna': const Color(0xFF8B4513),
      'status': 'HABIS',
      'sisa': '0/20 pcs',
      'min': '5 pcs',
      'cukup': '±0 porsi',
      'pemakaian': 'Pemakaian ±15 pcs/hari',
    },
    {
      'id': 's2',
      'nama': 'Susu UHT',
      'subtitle': 'Full Cream 1000ml',
      'kategori': 'BAHAN',
      'icon': 'inventory',
      'warna': const Color(0xFFFFB800),
      'status': 'HAMPIR HABIS',
      'sisa': '0.5/3 L',
      'min': '1 L',
      'cukup': '±8 porsi',
      'pemakaian': 'Pemakaian ±2 L/hari',
    },
    {
      'id': 's3',
      'nama': 'Cup 16oz',
      'subtitle': 'Gelas Sablon OMG',
      'kategori': 'BARANG',
      'icon': 'cup',
      'warna': const Color(0xFFEF2B7C),
      'status': 'HAMPIR HABIS',
      'sisa': '12/200 pcs',
      'min': '50 pcs',
      'cukup': '±12 porsi',
      'pemakaian': 'Pemakaian ±40 pcs/hari',
    },
    {
      'id': 's4',
      'nama': 'Gula Aren Cair',
      'subtitle': 'Konsentrat Alami',
      'kategori': 'BAHAN',
      'icon': 'drop',
      'warna': const Color(0xFF8B4513),
      'status': 'HAMPIR HABIS',
      'sisa': '0.4/2 kg',
      'min': '0.5 kg',
      'cukup': '±6 porsi',
      'pemakaian': 'Pemakaian ±0.5 kg/hari',
    },
  ].obs;

  // ==========================================
  // STATISTIK
  // ==========================================
  int get habisTotal =>
      stokList.where((s) => s['status'] == 'HABIS').length;
  int get hampirHabis =>
      stokList.where((s) => s['status'] == 'HAMPIR HABIS').length;
  int get dipantau => stokList.length;

  // ==========================================
  // FILTER
  // ==========================================
  List<Map<String, dynamic>> get filtered => stokList.where((s) {
        final matchKategori = filterKategori.value == 'SEMUA ITEM' ||
            (filterKategori.value == 'BAHAN BAKU' && s['kategori'] == 'BAHAN') ||
            (filterKategori.value == 'BARANG' && s['kategori'] == 'BARANG');
        final matchStatus = filterStatus.value == 'Semua Status' ||
            s['status'] == filterStatus.value.toUpperCase();
        return matchKategori && matchStatus;
      }).toList();

  void pilihKategori(String v) => filterKategori.value = v;
  void pilihStatus(String v) => filterStatus.value = v;

  // ==========================================
  // RESTOCK → Master Data terkait
  // ==========================================
  void restock(Map item) {
    if (item['kategori'] == 'BAHAN') {
      Get.toNamed(Routes.bahanBaku);
    } else {
      // Jika route Barang Operasional sudah ada, ganti ke route tersebut
      AppDialogs.showCustomSnackbar(
        title: 'Master Data Barang',
        message: 'Halaman Barang Operasional segera terhubung.',
        type: SnackbarType.info,
      );
    }
  }
}
