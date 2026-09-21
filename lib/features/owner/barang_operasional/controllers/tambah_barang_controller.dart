import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahBarangController extends GetxController {
  final selectedTabIndex = 0.obs;
  final selectedKategori = 'Energi & BBM'.obs;
  final selectedSatuan = 'liter'.obs;
  final namaBarang = ''.obs;
  final stokSaatIni = 3.obs;
  final stokMinimum = 2.obs;
  final totalHargaBeli = 66000.obs;
  final aktifDigunakan = true.obs;
  final searchQuery = ''.obs;

  final PageController pageController = PageController();

  // Daftar kategori
  final List<Map<String, dynamic>> kategoriList = [
    {
      'nama': 'Kemasan',
      'icon': Icons.inventory_2_rounded,
      'color': Color(0xFFFFE1EE)
    },
    {
      'nama': 'Energi & BBM',
      'icon': Icons.local_fire_department_rounded,
      'color': Color(0xFFFFC94D)
    },
    {
      'nama': 'Cetak & Promosi',
      'icon': Icons.print_rounded,
      'color': Color(0xFFF1E4DA)
    },
    {
      'nama': 'Perawatan Gerobak',
      'icon': Icons.handyman_rounded,
      'color': Color(0xFFE3EEE5)
    },
  ];

  // Satuan per kategori
  final Map<String, List<String>> satuanPerKategori = {
    'Kemasan': ['pcs', 'pack', 'roll', 'lembar', 'box'],
    'Energi & BBM': ['liter', 'ml', 'tabung'],
    'Cetak & Promosi': ['lembar', 'roll', 'pcs'],
    'Perawatan Gerobak': ['pcs', 'set', 'botol'],
  };

  // ✅ DATA DUMMY DAFTAR BARANG
  final List<Map<String, dynamic>> daftarBarang = [
    {
      'nama': 'Cup 16oz',
      'kategori': 'Kemasan',
      'icon': Icons.coffee_rounded,
      'iconColor': Color(0xFFFFE1EE),
      'stok': 0,
      'minStok': 50,
      'harga': 800,
      'satuan': 'pcs',
      'status': 'habis',
    },
    {
      'nama': 'Sedotan Hitam',
      'kategori': 'Kebersihan',
      'icon': Icons.straighten_rounded,
      'iconColor': Color(0xFFFFE1EE),
      'stok': 3,
      'minStok': 5,
      'harga': 12000,
      'satuan': 'pack',
      'status': 'menipis',
    },
    {
      'nama': 'Tisu Makan',
      'kategori': 'Kebersihan',
      'icon': Icons.eco_rounded,
      'iconColor': Color(0xFFE3EEE5),
      'stok': 12,
      'minStok': 4,
      'harga': 10000,
      'satuan': 'roll',
      'status': 'aman',
    },
    {
      'nama': 'Gas LPG 3kg',
      'kategori': 'Energi',
      'icon': Icons.local_fire_department_rounded,
      'iconColor': Color(0xFFFFF3D6),
      'stok': 1,
      'minStok': 2,
      'harga': 22000,
      'satuan': 'tabung',
      'status': 'menipis',
    },
  ];

  // ✅ Hitung jumlah per status
  int get jumlahAman => daftarBarang.where((b) => b['status'] == 'aman').length;
  int get jumlahMenipis =>
      daftarBarang.where((b) => b['status'] == 'menipis').length;
  int get jumlahHabis =>
      daftarBarang.where((b) => b['status'] == 'habis').length;
  int get totalBarang => daftarBarang.length;


  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectKategori(String kategori) {
    selectedKategori.value = kategori;
    if (satuanPerKategori[kategori] != null &&
        satuanPerKategori[kategori]!.isNotEmpty) {
      selectedSatuan.value = satuanPerKategori[kategori]!.first;
    }
  }

  void selectSatuan(String satuan) {
    selectedSatuan.value = satuan;
  }

  double get hargaPerSatuan {
    if (stokSaatIni.value <= 0) return 0;
    return totalHargaBeli.value / stokSaatIni.value;
  }

  String get formatHargaPerSatuan {
    return hargaPerSatuan.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  String get formatTotalHarga {
    return totalHargaBeli.value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  String formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void simpanBarang() {
    Get.snackbar(
      'Berhasil',
      'Barang "${namaBarang.value}" berhasil disimpan!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
  
}
