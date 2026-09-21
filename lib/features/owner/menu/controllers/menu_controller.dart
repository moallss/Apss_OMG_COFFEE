import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_dialogs.dart';

/// Hasil edit foto dari editor (dipakai callback onSave)
class FotoEditResult {
  final double zoom;
  final int turns;
  final Offset offsetNorm;
  final bool flipH;
  final bool flipV;
  final double brightness;
  final double contrast;
  final double saturation;

  const FotoEditResult({
    this.zoom = 1.0,
    this.turns = 0,
    this.offsetNorm = Offset.zero,
    this.flipH = false,
    this.flipV = false,
    this.brightness = 1.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
  });
}

class MenuController extends GetxController {
  final selectedTabIndex = 0.obs;
  final PageController tabPageController = PageController();

  // ==========================================
  // FORM BUAT MENU
  // ==========================================
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final kategori = ''.obs;
  final menuAktif = true.obs;

  // FOTO (path + semua parameter edit)
  final fotoPath = Rxn<String>();
  final fotoZoom = 1.0.obs;
  final fotoTurns = 0.obs;
  final fotoOffset = Offset.zero.obs;
  final fotoFlipH = false.obs;
  final fotoFlipV = false.obs;
  final fotoBrightness = 1.0.obs;
  final fotoContrast = 1.0.obs;
  final fotoSaturation = 1.0.obs;

  // ✅ BARU: filter untuk Lihat Menu
  final filterKategori = 'Semua'.obs;
  final filterStatus = 'Semua'.obs;

  final kategoriOptions = ['Kopi', 'Non-Kopi', 'Snack', 'Makanan'].obs;

  void selectKategori(String v) {
    kategori.value = v;
    Get.back();
  }

  void toggleAktifForm(bool v) => menuAktif.value = v;

  void setFoto(String path, FotoEditResult r) {
    fotoPath.value = path;
    fotoZoom.value = r.zoom;
    fotoTurns.value = r.turns;
    fotoOffset.value = r.offsetNorm;
    fotoFlipH.value = r.flipH;
    fotoFlipV.value = r.flipV;
    fotoBrightness.value = r.brightness;
    fotoContrast.value = r.contrast;
    fotoSaturation.value = r.saturation;
  }

  void resetFoto() {
    fotoPath.value = null;
    fotoZoom.value = 1.0;
    fotoTurns.value = 0;
    fotoOffset.value = Offset.zero;
    fotoFlipH.value = false;
    fotoFlipV.value = false;
    fotoBrightness.value = 1.0;
    fotoContrast.value = 1.0;
    fotoSaturation.value = 1.0;
  }

  // ==========================================
  // VALIDASI KEAMANAN FOTO (3 lapis)
  // ==========================================
  Future<String?> validateFoto(XFile file) async {
    final ext = file.path.split('.').last.toLowerCase();
    const allowed = ['jpg', 'jpeg', 'png', 'webp'];
    if (!allowed.contains(ext)) {
      return 'Format .$ext tidak didukung. Hanya JPG, PNG, atau WEBP.';
    }

    final bytes = await file.readAsBytes();
    if (bytes.length > 2 * 1024 * 1024) {
      return 'Ukuran maksimal 2MB (file Anda ${(bytes.length / 1024 / 1024).toStringAsFixed(1)}MB).';
    }

    final type = _detectImageType(bytes);
    final cocok =
        (ext == 'jpg' || ext == 'jpeg') ? type == 'jpeg' : type == ext;
    if (!cocok) {
      return 'DETEKSI KEAMANAN: isi file terdeteksi '
          '"${type ?? 'tidak dikenal'}" tetapi ber-ekstensi .$ext. File ditolak.';
    }
    return null;
  }

  String? _detectImageType(Uint8List b) {
    bool head(List<int> sig) {
      if (b.length < sig.length) return false;
      for (var i = 0; i < sig.length; i++) {
        if (b[i] != sig[i]) return false;
      }
      return true;
    }

    if (head([0xFF, 0xD8, 0xFF])) return 'jpeg';
    if (head([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) return 'png';
    if (b.length > 12 &&
        String.fromCharCodes(b.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(b.sublist(8, 12)) == 'WEBP') {
      return 'webp';
    }
    return null;
  }

  // ==========================================
  // DAFTAR MENU + SEARCH
  // ==========================================
  final searchQuery = ''.obs;

  final menuList = <Map<String, dynamic>>[
    {
      'nama': 'Es Kopi Susu',
      'kategori': 'Kopi',
      'harga': 18000,
      'deskripsi': 'Kopi susu gula aren signature',
      'aktif': true,
      'fotoPath': null,
      'fotoZoom': 1.0,
      'fotoTurns': 0,
      'fotoOffset': Offset.zero,
      'fotoFlipH': false,
      'fotoFlipV': false,
      'fotoBrightness': 1.0,
      'fotoContrast': 1.0,
      'fotoSaturation': 1.0,
    },
    {
      'nama': 'Croissant',
      'kategori': 'Snack',
      'harga': 15000,
      'deskripsi': 'Butter croissant fresh from oven',
      'aktif': true,
      'fotoPath': null,
      'fotoZoom': 1.0,
      'fotoTurns': 0,
      'fotoOffset': Offset.zero,
      'fotoFlipH': false,
      'fotoFlipV': false,
      'fotoBrightness': 1.0,
      'fotoContrast': 1.0,
      'fotoSaturation': 1.0,
    },
    {
      'nama': 'Nasi Goreng OMG',
      'kategori': 'Makanan',
      'harga': 25000,
      'deskripsi': '-',
      'aktif': false,
      'fotoPath': null,
      'fotoZoom': 1.0,
      'fotoTurns': 0,
      'fotoOffset': Offset.zero,
      'fotoFlipH': false,
      'fotoFlipV': false,
      'fotoBrightness': 1.0,
      'fotoContrast': 1.0,
      'fotoSaturation': 1.0,
    },
  ].obs;

  List<Map<String, dynamic>> get filteredMenu {
    return menuList.where((m) {
      // Filter search nama
      final matchQuery = (m['nama'] as String)
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      // Filter kategori
      final matchKategori = filterKategori.value == 'Semua' ||
          (m['kategori'] as String) == filterKategori.value;
      // Filter status aktif
      final matchStatus = filterStatus.value == 'Semua' ||
          (filterStatus.value == 'Aktif' && m['aktif'] == true) ||
          (filterStatus.value == 'Nonaktif' && m['aktif'] == false);
      return matchQuery && matchKategori && matchStatus;
    }).toList();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  // ✅ BARU: setter untuk filter
  void setFilterKategori(String v) {
    filterKategori.value = v;
    Get.back();
  }

  void setFilterStatus(String v) {
    filterStatus.value = v;
    Get.back();
  }

  // ✅ BARU: cek apakah ada filter aktif
  bool get hasActiveFilter =>
      filterKategori.value != 'Semua' || filterStatus.value != 'Semua';

  void toggleAktifMenu(Map<String, dynamic> m) {
    m['aktif'] = !(m['aktif'] as bool);
    menuList.refresh();
  }

  String formatRupiah(int v) => v.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

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
  // SIMPAN MENU
  // ==========================================
  void simpanMenu() {
    if (namaController.text.trim().isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Nama menu wajib diisi.',
        type: SnackbarType.warning,
      );
      return;
    }
    if (kategori.value.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Silakan pilih kategori menu.',
        type: SnackbarType.warning,
      );
      return;
    }
    if (hargaController.text.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: 'Harga jual dasar wajib diisi.',
        type: SnackbarType.warning,
      );
      return;
    }

    menuList.insert(0, {
      'nama': namaController.text.trim(),
      'kategori': kategori.value,
      'harga': int.parse(hargaController.text.replaceAll('.', '')),
      'deskripsi': deskripsiController.text.trim().isEmpty
          ? '-'
          : deskripsiController.text.trim(),
      'aktif': menuAktif.value,
      'fotoPath': fotoPath.value,
      'fotoZoom': fotoZoom.value,
      'fotoTurns': fotoTurns.value,
      'fotoOffset': fotoOffset.value,
      'fotoFlipH': fotoFlipH.value,
      'fotoFlipV': fotoFlipV.value,
      'fotoBrightness': fotoBrightness.value,
      'fotoContrast': fotoContrast.value,
      'fotoSaturation': fotoSaturation.value,
    });

    AppDialogs.showCustomSnackbar(
      title: 'Menu Tersimpan',
      message: '${namaController.text.trim()} berhasil ditambahkan.',
      type: SnackbarType.success,
    );

    namaController.clear();
    hargaController.clear();
    deskripsiController.clear();
    kategori.value = '';
    menuAktif.value = true;
    resetFoto();
    selectedTabIndex.value = 1;
    tabPageController.jumpToPage(1);
  }

  @override
  void onClose() {
    tabPageController.dispose();
    namaController.dispose();
    hargaController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
}
