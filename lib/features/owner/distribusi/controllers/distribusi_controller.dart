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
      'fotoUrl': null,
      'role': 'Driver',
      'detail': 'Gerobak 01 · ID #DST-01',
    },
    {
      'nama': 'Bayu',
      'fotoUrl': null,
      'role': 'Driver',
      'detail': 'Gerobak 02 · ID #DST-02',
    },
    {
      'nama': 'Supri',
      'fotoUrl': null,
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
  // RIWAYAT + SEARCH + FILTER
  // ==========================================
  final searchQuery = ''.obs;
  final filterStatus = 'Semua'.obs;

  final riwayatDistribusi = <Map<String, dynamic>>[
    {
      'nama': 'Agus',
      'fotoUrl': null,
      'waktu': '09:30 WIB',
      'status': 'Proses',
      'tanggal': DateTime.now(),
      'items': ['Susu UHT (200 ml)', 'Kemasan (10 pcs)', 'Gula Aren (50 gr)'],
      'catatan': 'Sedang dalam pengiriman',
    },
    {
      'nama': 'Bayu',
      'fotoUrl': null,
      'waktu': '08:15 WIB',
      'status': 'Sukses',
      'tanggal': DateTime.now(),
      'items': ['Susu UHT (500 ml)', 'Kemasan (10 pcs)', 'Gula Aren (30 gr)'],
      'catatan': 'Distribusi reguler pagi',
    },
    {
      'nama': 'Supri',
      'fotoUrl': null,
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
  void tambahItem() {
    distribusiItems.add({
      'item': itemOptions[0],
      'unit': 'pcs',
      'qtyController': TextEditingController(text: '0'),
    });
  }

  void hapusItem(int i) {
    (distribusiItems[i]['qtyController'] as TextEditingController).dispose();
    distribusiItems.removeAt(i);
  }

  void setItem(int i, String v) {
    distribusiItems[i]['item'] = v;
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
    tambahItem();
    catatanController.clear();
    selectedTabIndex.value = 1;
    tabPageController.jumpToPage(1);
  }

  @override
  void onInit() {
    super.onInit();
    tambahItem();
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
