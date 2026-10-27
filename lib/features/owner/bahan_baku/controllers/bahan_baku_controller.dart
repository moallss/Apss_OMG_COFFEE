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

  // ==========================================
  // KATEGORI BARU (CUSTOM)
  // ==========================================
  final RxList<Map<String, dynamic>> customKategoriList =
      <Map<String, dynamic>>[].obs;

  final newKategoriNama = TextEditingController();
  final hexColorController = TextEditingController(text: '#6F4E37');
  final newKategoriWarna = const Color(0xFF6F4E37).obs; // Default: Warna Kopi
  final newKategoriIcon = Icons.eco_rounded.obs;

  // Kategori Icon Picker
  final selectedIconCategory = 'Semua'.obs;
  final Map<String, List<Map<String, dynamic>>> iconCategories = {
    'Semua': [
      {'icon': Icons.eco_rounded, 'label': 'Bahan'},
      {'icon': Icons.water_drop_rounded, 'label': 'Cair'},
      {'icon': Icons.grain_rounded, 'label': 'Biji'},
      {'icon': Icons.local_drink_rounded, 'label': 'Minum'},
      {'icon': Icons.coffee_rounded, 'label': 'Kopi'},
      {'icon': Icons.emoji_food_beverage_rounded, 'label': 'Teh'},
      {'icon': Icons.bakery_dining_rounded, 'label': 'Roti'},
      {'icon': Icons.cake_rounded, 'label': 'Kue'},
      {'icon': Icons.cookie_rounded, 'label': 'Cookie'},
      {'icon': Icons.icecream_rounded, 'label': 'Dingin'},
      {'icon': Icons.restaurant_rounded, 'label': 'Sendok'},
      {'icon': Icons.kitchen_rounded, 'label': 'Dapur'},
      {'icon': Icons.blender_rounded, 'label': 'Blender'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Kotak'},
      {'icon': Icons.abc_rounded, 'label': 'Huruf'},
      {'icon': Icons.star_rounded, 'label': 'Bintang'},
    ],
    'Bahan': [
      {'icon': Icons.eco_rounded, 'label': 'Bahan'},
      {'icon': Icons.water_drop_rounded, 'label': 'Cair'},
      {'icon': Icons.grain_rounded, 'label': 'Biji'},
      {'icon': Icons.grass_rounded, 'label': 'Daun'},
      {'icon': Icons.spa_rounded, 'label': 'Herbal'},
      {'icon': Icons.nature_rounded, 'label': 'Alami'},
    ],
    'Minuman': [
      {'icon': Icons.coffee_rounded, 'label': 'Kopi'},
      {'icon': Icons.local_drink_rounded, 'label': 'Minum'},
      {'icon': Icons.emoji_food_beverage_rounded, 'label': 'Teh'},
      {'icon': Icons.local_cafe_rounded, 'label': 'Cangkir'},
      {'icon': Icons.wine_bar_rounded, 'label': 'Sirup'},
      {'icon': Icons.icecream_rounded, 'label': 'Dingin'},
    ],
    'Makanan': [
      {'icon': Icons.bakery_dining_rounded, 'label': 'Roti'},
      {'icon': Icons.cake_rounded, 'label': 'Kue'},
      {'icon': Icons.cookie_rounded, 'label': 'Cookie'},
      {'icon': Icons.local_pizza_rounded, 'label': 'Pizza'},
      {'icon': Icons.set_meal_rounded, 'label': 'Makan'},
      {'icon': Icons.breakfast_dining_rounded, 'label': 'Sarapan'},
    ],
    'Peralatan': [
      {'icon': Icons.restaurant_rounded, 'label': 'Sendok'},
      {'icon': Icons.kitchen_rounded, 'label': 'Dapur'},
      {'icon': Icons.blender_rounded, 'label': 'Blender'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Kotak'},
      {'icon': Icons.scale_rounded, 'label': 'Timbangan'},
      {'icon': Icons.cleaning_services_rounded, 'label': 'Bersih'},
    ],
    'Lainnya': [
      {'icon': Icons.abc_rounded, 'label': 'Huruf'},
      {'icon': Icons.star_rounded, 'label': 'Bintang'},
      {'icon': Icons.label_rounded, 'label': 'Label'},
      {'icon': Icons.category_rounded, 'label': 'Kategori'},
      {'icon': Icons.layers_rounded, 'label': 'Lapisan'},
      {'icon': Icons.bookmark_rounded, 'label': 'Tanda'},
    ],
  };

  void setSelectedIconCategory(String cat) => selectedIconCategory.value = cat;
  void setNewKategoriWarna(Color c) => newKategoriWarna.value = c;
  void setNewKategoriIcon(IconData i) => newKategoriIcon.value = i;

  bool isValidHex(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (clean.length != 6) return false;
    return RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(clean);
  }

  void updateKategoriFromHex(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (!isValidHex(hex)) return;
    try {
      final color = Color(int.parse('FF$clean', radix: 16));
      newKategoriWarna.value = color;
    } catch (e) {}
  }

  void simpanKategoriBaru() {
    if (newKategoriNama.text.trim().isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Nama kategori wajib diisi.',
        type: SnackbarType.warning,
      );
      return;
    }

    customKategoriList.add({
      'label': newKategoriNama.text.trim(),
      'icon': newKategoriIcon.value,
      'color': newKategoriWarna.value,
    });

    newKategoriNama.clear();
    newKategoriWarna.value = const Color(0xFF6F4E37);
    newKategoriIcon.value = Icons.eco_rounded;

    Get.back(); // Tutup bottom sheet
    AppDialogs.showCustomSnackbar(
      title: 'Berhasil',
      message: 'Kategori baru berhasil ditambahkan.',
      type: SnackbarType.success,
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
    newKategoriNama.dispose();
    hexColorController.dispose(); // <-- TAMBAH INI
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    // Listener untuk update live preview
    newKategoriNama.addListener(() {
      // Trigger update dengan mengubah warna sedikit (hack untuk force rebuild)
      final currentColor = newKategoriWarna.value;
      newKategoriWarna.value = currentColor;
    });
  }
}
