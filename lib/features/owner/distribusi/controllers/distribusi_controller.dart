// PATH FILE: lib/features/owner/distribusi/controllers/distribusi_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';

class DistribusiController extends GetxController {
  final selectedTabIndex = 0.obs;
  final PageController tabPageController = PageController();

  // ==========================================
  // KARYAWAN (dummy dengan role & detail)
  // ==========================================
  final karyawanList = <Map<String, dynamic>>[
    {
      'nama': 'Andi',
      'fotoUrl': 'https://i.pravatar.cc/150?u=andi',
      'role': 'Driver',
      'detail': 'Gerobak 01 · ID #DST-01',
    },
    {
      'nama': 'Bayu',
      'fotoUrl': 'https://i.pravatar.cc/150?u=bayu',
      'role': 'Driver',
      'detail': 'Gerobak 02 · ID #DST-02',
    },
    {
      'nama': 'Supri',
      'fotoUrl': 'https://i.pravatar.cc/150?u=supri',
      'role': 'Driver',
      'detail': 'Gerobak 03 · ID #DST-03',
    },
  ].obs;
  final selectedKaryawanIndex = 0.obs;

  // ==========================================
  // TANGGAL
  // ==========================================
  final tanggalDistribusi = DateTime.now().obs;

  static const bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  static const hari = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu'
  ];

  String get tanggalFormatted {
    final d = tanggalDistribusi.value;
    return '${hari[d.weekday % 7]}, ${d.day.toString().padLeft(2, '0')} ${bulan[d.month - 1]} ${d.year}';
  }

  Future<void> pickTanggal() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: tanggalDistribusi.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) tanggalDistribusi.value = picked;
  }

  // ==========================================
  // ITEM DISTRIBUSI
  // ==========================================
  final itemOptions = [
    'Kopi Bubuk 500g',
    'Susu UHT',
    'Cup 16oz',
    'Gula Aren',
    'Sedotan',
    'Tisu',
  ].obs;

  final unitOptions = ['gram', 'liter', 'pcs', 'pack'].obs;

  // Mapping item ke kategori
  Map<String, String> get itemKategoriMap => {
        'Kopi Bubuk 500g': 'Bahan Pokok',
        'Gula Aren': 'Bahan Pokok',
        'Susu UHT': 'Dairy',
        'Cup 16oz': 'Kemasan',
        'Sedotan': 'Kemasan',
        'Tisu': 'Kemasan',
      };

  String getKategori(String item) => itemKategoriMap[item] ?? 'Lainnya';

  String getKategoriKelompok(String item) {
    final sub = itemKategoriMap[item] ?? '';
    if (sub == 'Kemasan' || sub == 'Barang Operasional' || sub == 'Operasional') {
      return 'BARANG OPERASIONAL';
    }
    return 'BAHAN BAKU';
  }

  Color getKategoriColor(String kategori) {
    switch (kategori) {
      case 'Bahan Pokok':
        return AppColors.primary;
      case 'Dairy':
        return const Color(0xFF8B4513);
      case 'Kemasan':
        return AppColors.brandGreen;
      default:
        return AppColors.muted;
    }
  }

  IconData getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'Bahan Pokok':
        return Icons.inventory_2_rounded;
      case 'Dairy':
        return Icons.water_drop_rounded;
      case 'Kemasan':
        return Icons.category_rounded;
      default:
        return Icons.inventory_rounded;
    }
  }

  final distribusiItems = <Map<String, dynamic>>[].obs;
  final catatanController = TextEditingController();

  // ==========================================
  // BOTTOM SHEET MASTER DATA & STATE
  // ==========================================
  final sheetTabIndex = 0.obs;
  final sheetSearchQuery = ''.obs;

  final masterBahanBaku = <Map<String, dynamic>>[
    {
      'icon': Icons.water_drop_rounded,
      'iconColor': const Color(0xFF8B4513),
      'category': 'PEMANIS',
      'name': 'Gula Aren',
      'stock': '1,8 kg',
      'unit': 'satuan gram',
      'percentage': 72,
      'status': 'Aman',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.ac_unit_rounded,
      'iconColor': AppColors.brandGreen,
      'category': 'TOPPING',
      'name': 'Es Batu',
      'stock': '4 kg',
      'unit': 'satuan gram',
      'percentage': 85,
      'status': 'Aman',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.coffee_rounded,
      'iconColor': const Color(0xFF6B4F3A),
      'category': 'TOPPING',
      'name': 'Bubuk Matcha',
      'stock': '200 g',
      'unit': 'satuan gram',
      'percentage': 20,
      'status': 'Hampir Habis',
      'isEmpty': false,
      'isCritical': true,
    },
    {
      'icon': Icons.inventory_2_rounded,
      'iconColor': AppColors.primary,
      'category': 'KOPI',
      'name': 'Kopi Bubuk',
      'stock': '2,5 kg',
      'unit': 'satuan gram',
      'percentage': 60,
      'status': 'Tercatat',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.local_drink_rounded,
      'iconColor': const Color(0xFF1A1A1A),
      'category': 'DAIRY',
      'name': 'Susu UHT',
      'stock': '0 L',
      'unit': 'satuan liter',
      'percentage': 0,
      'status': 'Habis',
      'isEmpty': true,
      'isCritical': false,
    },
  ];

  final masterBarangOperasional = <Map<String, dynamic>>[
    {
      'icon': Icons.coffee_rounded,
      'iconColor': const Color(0xFFFFB800),
      'category': 'KEMASAN',
      'name': 'Cup 16oz',
      'stock': '120 pcs',
      'unit': 'satuan pcs',
      'percentage': 80,
      'status': 'Aman',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.coffee_rounded,
      'iconColor': AppColors.brandGreen,
      'category': 'KEMASAN',
      'name': 'Cup 22oz',
      'stock': '85 pcs',
      'unit': 'satuan pcs',
      'percentage': 65,
      'status': 'Aman',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.local_drink_rounded,
      'iconColor': const Color(0xFF8B4513),
      'category': 'KEMASAN',
      'name': 'Sedotan Plastik',
      'stock': '350 pcs',
      'unit': 'satuan pcs',
      'percentage': 70,
      'status': 'Aman',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.cleaning_services_rounded,
      'iconColor': AppColors.primary,
      'category': 'OPERASIONAL',
      'name': 'Tisu Kering',
      'stock': '15 pack',
      'unit': 'satuan pack',
      'percentage': 50,
      'status': 'Aman',
      'isEmpty': false,
      'isCritical': false,
    },
    {
      'icon': Icons.shopping_bag_rounded,
      'iconColor': const Color(0xFFFFB800),
      'category': 'KEMASAN',
      'name': 'Kantong Kresek',
      'stock': '40 pcs',
      'unit': 'satuan pcs',
      'percentage': 25,
      'status': 'Hampir Habis',
      'isEmpty': false,
      'isCritical': true,
    },
  ];

  List<Map<String, dynamic>> get currentMasterList {
    final list = sheetTabIndex.value == 0 ? masterBahanBaku : masterBarangOperasional;
    final q = sheetSearchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return list;
    return list.where((item) {
      final name = (item['name'] as String).toLowerCase();
      final cat = (item['category'] as String).toLowerCase();
      return name.contains(q) || cat.contains(q);
    }).toList();
  }

  // ==========================================
  // RIWAYAT + SEARCH + FILTER
  // ==========================================
  final searchQuery = ''.obs;
  final filterStatus = 'Semua'.obs;

  final riwayatDistribusi = <Map<String, dynamic>>[
    {
      'nama': 'Agus',
      'fotoUrl': 'https://i.pravatar.cc/150?u=agus',
      'waktu': '09:30 WIB',
      'status': 'Proses',
      'tanggal': DateTime.now(),
      'items': ['Susu UHT (200 ml)', 'Kemasan (10 pcs)', 'Gula Aren (50 gr)'],
      'catatan': 'Sedang dalam pengiriman',
    },
    {
      'nama': 'Bayu',
      'fotoUrl': 'https://i.pravatar.cc/150?u=bayu',
      'waktu': '08:15 WIB',
      'status': 'Sukses',
      'tanggal': DateTime.now(),
      'items': ['Susu UHT (500 ml)', 'Kemasan (10 pcs)', 'Gula Aren (30 gr)'],
      'catatan': 'Distribusi reguler pagi',
    },
    {
      'nama': 'Supri',
      'fotoUrl': 'https://i.pravatar.cc/150?u=supri',
      'waktu': '16:45 WIB',
      'status': 'Sukses',
      'tanggal': DateTime.now().subtract(const Duration(days: 1)),
      'items': ['Cup 16oz (50 pcs)', 'Sedotan (100 pcs)'],
      'catatan': '-',
    },
  ].obs;

  List<Map<String, dynamic>> get filteredRiwayat {
    return riwayatDistribusi.where((r) {
      final matchQuery = (r['nama'] as String)
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      final matchStatus =
          filterStatus.value == 'Semua' || r['status'] == filterStatus.value;
      return matchQuery && matchStatus;
    }).toList();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void setFilterStatus(String v) {
    filterStatus.value = v;
    Get.back();
  }

  String tanggalLabel(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final formatted =
        '${hari[d.weekday % 7]}, ${d.day.toString().padLeft(2, '0')} ${bulan[d.month - 1]} ${d.year}';
    if (day == today) return 'HARI INI · $formatted';
    if (day == today.subtract(const Duration(days: 1))) {
      return 'KEMARIN · $formatted';
    }
    return formatted;
  }

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

  void selectKaryawan(int index) {
    selectedKaryawanIndex.value = index;
    Get.back();
  }

  // ==========================================
  // ITEM CRUD
  // ==========================================
  void tambahItem({String? item, String? kategori, String? unit, String qty = '0'}) {
    final itemName = item ?? itemOptions[0];
    final kat = kategori ?? getKategoriKelompok(itemName);
    distribusiItems.add({
      'item': itemName,
      'kategori': kat,
      'unit': unit ?? (kat == 'BARANG OPERASIONAL' ? 'pcs' : 'gram'),
      'qtyController': TextEditingController(text: qty),
    });
  }

  void hapusItem(int i) {
    (distribusiItems[i]['qtyController'] as TextEditingController).dispose();
    distribusiItems.removeAt(i);
  }

  void setItem(int i, String v) {
    distribusiItems[i]['item'] = v;
    distribusiItems[i]['kategori'] = getKategoriKelompok(v);
    distribusiItems.refresh();
  }

  void setUnit(int i, String v) {
    distribusiItems[i]['unit'] = v;
    distribusiItems.refresh();
  }

  void incrementQty(int i) {
    final ctrl = distribusiItems[i]['qtyController'] as TextEditingController;
    final current = int.tryParse(ctrl.text.replaceAll('.', '')) ?? 0;
    ctrl.text = (current + 1).toString();
  }

  void decrementQty(int i) {
    final ctrl = distribusiItems[i]['qtyController'] as TextEditingController;
    final current = int.tryParse(ctrl.text.replaceAll('.', '')) ?? 0;
    if (current > 0) ctrl.text = (current - 1).toString();
  }

  // ==========================================
  // SIMPAN
  // ==========================================
  void simpanDistribusi() {
    if (distribusiItems.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Tambahkan minimal 1 item distribusi.',
        type: SnackbarType.warning,
      );
      return;
    }

    final k = karyawanList[selectedKaryawanIndex.value];
    final now = DateTime.now();

    riwayatDistribusi.insert(0, {
      'nama': k['nama'],
      'fotoUrl': k['fotoUrl'],
      'waktu':
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB',
      'status': 'Proses',
      'tanggal': now,
      'items': distribusiItems
          .map((it) =>
              '${it['item']} (${(it['qtyController'] as TextEditingController).text} ${(it['unit'] as String)})')
          .toList(),
      'catatan': catatanController.text.trim().isEmpty
          ? '-'
          : catatanController.text.trim(),
    });

    AppDialogs.showCustomSnackbar(
      title: 'Distribusi Tersimpan',
      message: 'Data distribusi berhasil disimpan.',
      type: SnackbarType.success,
    );

    for (final it in distribusiItems) {
      (it['qtyController'] as TextEditingController).dispose();
    }
    distribusiItems.clear();
    tambahItem(item: 'Kopi Bubuk 500g', kategori: 'BAHAN BAKU', unit: 'gram');
    tambahItem(item: 'Cup 16oz', kategori: 'BARANG OPERASIONAL', unit: 'pcs');
    catatanController.clear();
    selectedTabIndex.value = 1;
    tabPageController.jumpToPage(1);
  }

  @override
  void onInit() {
    super.onInit();
    distribusiItems.addAll([
      {
        'item': 'Kopi Bubuk 500g',
        'kategori': 'BAHAN BAKU',
        'unit': 'gram',
        'qtyController': TextEditingController(text: '500'),
      },
      {
        'item': 'Susu UHT',
        'kategori': 'BAHAN BAKU',
        'unit': 'liter',
        'qtyController': TextEditingController(text: '2'),
      },
      {
        'item': 'Cup 16oz',
        'kategori': 'BARANG OPERASIONAL',
        'unit': 'pcs',
        'qtyController': TextEditingController(text: '50'),
      },
      {
        'item': 'Sedotan',
        'kategori': 'BARANG OPERASIONAL',
        'unit': 'pack',
        'qtyController': TextEditingController(text: '1'),
      },
    ]);
  }

  @override
  void onClose() {
    tabPageController.dispose();
    for (final it in distribusiItems) {
      (it['qtyController'] as TextEditingController).dispose();
    }
    catatanController.dispose();
    super.onClose();
  }
}
