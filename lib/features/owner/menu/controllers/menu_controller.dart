// PATH FILE: lib/features/owner/menu/controllers/menu_controller.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_dialogs.dart';
import '../../../../data/services/menu_service.dart';

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
  final MenuService _menuService = MenuService();

  final selectedTabIndex = 0.obs;
  final PageController tabPageController = PageController();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final editingId = Rxn<String>();

  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final kategori = ''.obs;
  final menuAktif = true.obs;

  final fotoPath = Rxn<String>();
  final fotoBytes =
      Rxn<Uint8List>(); // ✅ BARU: bytes untuk preview (aman di web)
  final fotoZoom = 1.0.obs;
  final fotoTurns = 0.obs;
  final fotoOffset = Offset.zero.obs;
  final fotoFlipH = false.obs;
  final fotoFlipV = false.obs;
  final fotoBrightness = 1.0.obs;
  final fotoContrast = 1.0.obs;
  final fotoSaturation = 1.0.obs;

  final filterKategori = 'Semua'.obs;
  final filterStatus = 'Semua'.obs;
  final searchQuery = ''.obs;
  final kategoriOptions = ['Kopi', 'Non-Kopi', 'Snack', 'Makanan'].obs;
  final menuList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMenu();
  }

  Future<void> loadMenu() async {
    isLoading.value = true;
    try {
      final rows = await _menuService.fetchMenu();
      menuList.assignAll(rows.map(_rowToItem).toList());
    } catch (e) {
      AppDialogs.showCustomSnackbar(
        title: 'Gagal Memuat Menu',
        message: 'Periksa koneksi/Supabase. Detail: $e',
        type: SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _rowToItem(Map<String, dynamic> r) {
    return {
      'id': r['id'] as String,
      'nama': (r['nama_menu'] as String?) ?? '-',
      'kategori': (r['kategori'] as String?) ?? 'Kopi',
      'harga': ((r['harga'] as num?) ?? 0).toInt(),
      'deskripsi': (r['deskripsi'] as String?) ?? '-',
      'aktif': (r['tersedia'] as bool?) ?? true,
      'fotoPath': r['gambar_url'],
      'fotoZoom': 1.0,
      'fotoTurns': 0,
      'fotoOffset': Offset.zero,
      'fotoFlipH': false,
      'fotoFlipV': false,
      'fotoBrightness': 1.0,
      'fotoContrast': 1.0,
      'fotoSaturation': 1.0,
    };
  }

  Future<void> simpanMenu() async {
    if (isSaving.value) return;

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

    final deskripsiClean = deskripsiController.text.trim();
    final deskripsiFinal = deskripsiClean.isEmpty ? '-' : deskripsiClean;

    final data = {
      'nama_menu': namaController.text.trim(),
      'kategori': kategori.value,
      'harga': int.parse(hargaController.text.replaceAll('.', '')),
      'deskripsi': deskripsiFinal,
      'tersedia': menuAktif.value,
      'gambar_url': null,
    };

    isSaving.value = true;
    try {
      final id = editingId.value;
      if (id != null) {
        await _menuService.updateMenu(id, data);
        AppDialogs.showCustomSnackbar(
          title: 'Menu Diperbarui',
          message: '${data['nama_menu']} berhasil diubah.',
          type: SnackbarType.success,
        );
      } else {
        await _menuService.createMenu(data);
        AppDialogs.showCustomSnackbar(
          title: 'Menu Tersimpan',
          message: '${data['nama_menu']} berhasil ditambahkan.',
          type: SnackbarType.success,
        );
      }
      _resetForm();
      await loadMenu();
      changeTab(1);
    } catch (e) {
      AppDialogs.showCustomSnackbar(
        title: 'Gagal Menyimpan',
        message: 'Detail: $e',
        type: SnackbarType.error,
      );
    } finally {
      isSaving.value = false;
    }
  }

  void startEdit(Map<String, dynamic> m) {
    editingId.value = m['id'] as String?;
    namaController.text = (m['nama'] as String?) ?? '';
    hargaController.text = formatRupiah((m['harga'] as int?) ?? 0);

    final desk = m['deskripsi'] as String? ?? '';
    deskripsiController.text = (desk == '-') ? '' : desk;

    kategori.value = (m['kategori'] as String?) ?? '';
    menuAktif.value = (m['aktif'] as bool?) ?? true;
    resetFoto();
    changeTab(0);

    AppDialogs.showCustomSnackbar(
      title: 'Mode Edit',
      message: 'Mengubah "${m['nama']}". Ubah form lalu tekan Update Menu.',
      type: SnackbarType.info,
    );
  }

  void cancelEdit() {
    editingId.value = null;
    _resetForm();
  }

  void _resetForm() {
    namaController.clear();
    hargaController.clear();
    deskripsiController.clear();
    kategori.value = '';
    menuAktif.value = true;
    editingId.value = null;
    resetFoto();
  }

  void confirmDelete(Map<String, dynamic> m) {
    final id = m['id'] as String?;
    if (id == null) return;

    AppDialogs.showConfirmDialog(
      title: 'Hapus Menu',
      message: '"${m['nama']}" akan dihapus permanen dari daftar menu.',
      confirmText: 'Ya, Hapus',
      cancelText: 'Batal',
      onConfirm: () async {
        try {
          await _menuService.deleteMenu(id);
          AppDialogs.showCustomSnackbar(
            title: 'Menu Dihapus',
            message: '${m['nama']} telah dihapus.',
            type: SnackbarType.success,
          );
          await loadMenu();
        } catch (e) {
          AppDialogs.showCustomSnackbar(
            title: 'Gagal Menghapus',
            message: 'Detail: $e',
            type: SnackbarType.error,
          );
        }
      },
    );
  }

  Future<void> toggleAktifMenu(Map<String, dynamic> m) async {
    final id = m['id'] as String?;
    final old = m['aktif'] as bool;
    m['aktif'] = !old;
    menuList.refresh();

    if (id == null) return;
    try {
      await _menuService.updateMenu(id, {'tersedia': m['aktif']});
    } catch (e) {
      m['aktif'] = old;
      menuList.refresh();
      AppDialogs.showCustomSnackbar(
        title: 'Gagal Mengubah Status',
        message: 'Detail: $e',
        type: SnackbarType.error,
      );
    }
  }

  List<Map<String, dynamic>> get filteredMenu {
    return menuList.where((m) {
      final matchQuery = (m['nama'] as String)
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      final matchKategori = filterKategori.value == 'Semua' ||
          (m['kategori'] as String) == filterKategori.value;
      final matchStatus = filterStatus.value == 'Semua' ||
          (filterStatus.value == 'Aktif' && m['aktif'] == true) ||
          (filterStatus.value == 'Nonaktif' && m['aktif'] == false);
      return matchQuery && matchKategori && matchStatus;
    }).toList();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  bool get hasActiveFilter =>
      filterKategori.value != 'Semua' || filterStatus.value != 'Semua';

  String formatRupiah(int v) => v.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  void selectKategori(String v) {
    kategori.value = v;
  }

  void toggleAktifForm(bool v) => menuAktif.value = v;

  void setFoto(String path, Uint8List bytes, FotoEditResult r) {
    fotoPath.value = path;
    fotoBytes.value = bytes; // ✅ simpan bytes
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
    fotoBytes.value = null; // ✅
    fotoZoom.value = 1.0;
    fotoTurns.value = 0;
    fotoOffset.value = Offset.zero;
    fotoFlipH.value = false;
    fotoFlipV.value = false;
    fotoBrightness.value = 1.0;
    fotoContrast.value = 1.0;
    fotoSaturation.value = 1.0;
  }

  Future<String?> validateFoto(XFile file, Uint8List bytes) async {
    const allowed = ['jpg', 'jpeg', 'png', 'webp'];

    // ✅ WEB: file.path = blob URL tanpa ekstensi → prioritaskan file.name
    String ext = file.name.split('.').last.toLowerCase();
    if (!allowed.contains(ext)) {
      ext = file.path.split('.').last.toLowerCase();
    }
    if (!allowed.contains(ext)) {
      return 'Format .$ext tidak didukung. Hanya JPG, PNG, atau WEBP.';
    }

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

  @override
  void onClose() {
    tabPageController.dispose();
    namaController.dispose();
    hargaController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
}
