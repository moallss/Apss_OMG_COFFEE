import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_dialogs.dart';

class BahanBakuController extends GetxController {
  final selectedTabIndex = 0.obs;
  final PageController tabPageController = PageController();

  // ==========================================
  // FORM TAMBAH BAHAN
  // ==========================================
  final namaController = TextEditingController();
  final stokController = TextEditingController();
  final stokMinController = TextEditingController();
  final hargaController = TextEditingController();
  final supplierController = TextEditingController();
  final kategori = ''.obs;
  final unit = 'gr'.obs;
  final aktif = true.obs;

  final kategoriOptions = ['Kopi', 'Susu', 'Pemanis', 'Sirup', 'Lainnya'].obs;
  final unitOptions = ['gr', 'kg', 'ml', 'L', 'pcs'].obs;

  void selectKategori(String v) {
    kategori.value = v;
    Get.back();
  }

  void selectUnit(String v) => unit.value = v;

  void toggleAktifForm(bool v) => aktif.value = v;

  IconData iconKategori(String k) {
    switch (k) {
      case 'Kopi':
        return Icons.coffee_rounded;
      case 'Susu':
        return Icons.local_drink_rounded;
      case 'Pemanis':
        return Icons.grain_rounded;
      case 'Sirup':
        return Icons.water_drop_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  // ==========================================
  // DAFTAR BAHAN + SEARCH + FILTER
  // ==========================================
  final searchQuery = ''.obs;
  final filterStatus = 'Semua'.obs;
  final filterKategori = 'Semua'.obs;

  final bahanList = <Map<String, dynamic>>[
    {
      'nama': 'Kopi Bubuk Arabica',
      'kategori': 'Kopi',
      'stok': 500.0,
      'stokMin': 200.0,
      'unit': 'gr',
      'harga': 85,
      'supplier': 'Koperasi Gayo',
      'aktif': true,
    },
    {
      'nama': 'Kopi Bubuk Robusta',
      'kategori': 'Kopi',
      'stok': 300.0,
      'stokMin': 150.0,
      'unit': 'gr',
      'harga': 60,
      'supplier': 'Koperasi Gayo',
      'aktif': true,
    },
    {
      'nama': 'Susu UHT Full Cream',
      'kategori': 'Susu',
      'stok': 2000.0,
      'stokMin': 3000.0,
      'unit': 'ml',
      'harga': 18,
      'supplier': 'PT Dairy Indo',
      'aktif': true,
    },
    {
      'nama': 'Susu Oat',
      'kategori': 'Susu',
      'stok': 0.0,
      'stokMin': 1000.0,
      'unit': 'ml',
      'harga': 45,
      'supplier': 'PT Dairy Indo',
      'aktif': true,
    },
    {
      'nama': 'Gula Aren Cair',
      'kategori': 'Pemanis',
      'stok': 1500.0,
      'stokMin': 500.0,
      'unit': 'ml',
      'harga': 25,
      'supplier': 'UMKM Banten',
      'aktif': true,
    },
    {
      'nama': 'Sirup Vanilla',
      'kategori': 'Sirup',
      'stok': 800.0,
      'stokMin': 500.0,
      'unit': 'ml',
      'harga': 55,
      'supplier': 'Distributor Jakarta',
      'aktif': true,
    },
    {
      'nama': 'Es Batu Kristal',
      'kategori': 'Lainnya',
      'stok': 5.0,
      'stokMin': 2.0,
      'unit': 'kg',
      'harga': 2000,
      'supplier': 'Pabrik Es Lokal',
      'aktif': true,
    },
    {
      'nama': 'Sirup Caramel',
      'kategori': 'Sirup',
      'stok': 1200.0,
      'stokMin': 400.0,
      'unit': 'ml',
      'harga': 60,
      'supplier': 'Distributor Jakarta',
      'aktif': false,
    },
  ].obs;

  /// Status otomatis: Habis / Menipis / Aman
  String statusBahan(Map b) {
    final stok = (b['stok'] as num).toDouble();
    final min = (b['stokMin'] as num).toDouble();
    if (stok <= 0) return 'Habis';
    if (stok < min * 2) return 'Menipis';
    return 'Aman';
  }

  int countStatus(String s) =>
      bahanList.where((b) => statusBahan(b) == s).length;

  List<Map<String, dynamic>> get filteredBahan {
    return bahanList.where((b) {
      final q = (b['nama'] as String)
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      final st =
          filterStatus.value == 'Semua' || statusBahan(b) == filterStatus.value;
      final kt = filterKategori.value == 'Semua' ||
          b['kategori'] == filterKategori.value;
      return q && st && kt;
    }).toList();
  }

  bool get hasActiveFilter =>
      filterStatus.value != 'Semua' || filterKategori.value != 'Semua';

  void onSearchChanged(String v) => searchQuery.value = v;

  String formatRupiah(int v) => v.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  String formatStok(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);

  // ==========================================
  // TAB
  // ==========================================
  void changeTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    tabPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  void onTabChanged(int index) => selectedTabIndex.value = index;

  // ==========================================
  // SIMPAN BAHAN
  // ==========================================
  void simpanBahan() {
    if (namaController.text.trim().isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Nama bahan wajib diisi.',
        type: SnackbarType.warning,
      );
      return;
    }
    if (kategori.value.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Silakan pilih kategori bahan.',
        type: SnackbarType.warning,
      );
      return;
    }
    if (stokController.text.isEmpty || stokMinController.text.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Stok saat ini dan stok minimum wajib diisi.',
        type: SnackbarType.warning,
      );
      return;
    }
    if (hargaController.text.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Harga per unit wajib diisi.',
        type: SnackbarType.warning,
      );
      return;
    }

    bahanList.insert(0, {
      'nama': namaController.text.trim(),
      'kategori': kategori.value,
      'stok': double.parse(stokController.text),
      'stokMin': double.parse(stokMinController.text),
      'unit': unit.value,
      'harga': int.parse(hargaController.text.replaceAll('.', '')),
      'supplier': supplierController.text.trim().isEmpty
          ? '-'
          : supplierController.text.trim(),
      'aktif': aktif.value,
    });

    AppDialogs.showCustomSnackbar(
      title: 'Bahan Tersimpan',
      message: '${namaController.text.trim()} berhasil ditambahkan.',
      type: SnackbarType.success,
    );

    namaController.clear();
    stokController.clear();
    stokMinController.clear();
    hargaController.clear();
    supplierController.clear();
    kategori.value = '';
    unit.value = 'gr';
    aktif.value = true;
    selectedTabIndex.value = 1;
    tabPageController.jumpToPage(1);
  }

  // ==========================================
  // RESTOCK & HAPUS
  // ==========================================
  void restockBahan(Map b, double amount) {
    b['stok'] = (b['stok'] as num).toDouble() + amount;
    bahanList.refresh();
    AppDialogs.showCustomSnackbar(
      title: 'Stok Diperbarui',
      message: '${b['nama']} +${formatStok(amount)} ${b['unit']}',
      type: SnackbarType.success,
    );
  }

  void hapusBahan(Map b) {
    bahanList.remove(b);
    Get.back();
    AppDialogs.showCustomSnackbar(
      title: 'Bahan Dihapus',
      message: '${b['nama']} dihapus dari daftar.',
      type: SnackbarType.info,
    );
  }

  @override
  void onClose() {
    tabPageController.dispose();
    namaController.dispose();
    stokController.dispose();
    stokMinController.dispose();
    hargaController.dispose();
    supplierController.dispose();
    super.onClose();
  }
}
