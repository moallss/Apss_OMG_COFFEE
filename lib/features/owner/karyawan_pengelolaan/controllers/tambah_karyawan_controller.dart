import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahKaryawanController extends GetxController {
  // ✅ TAB STATE (BARU)
  final selectedTabIndex = 0.obs;
  final pageController = PageController();

  // ✅ STATE ACCORDION (default 2/4 terbuka)
  final RxList<bool> openSections = [true, true, false, false].obs;

  // Section 1: Data Diri & Foto
  final namaLengkap = TextEditingController(text: 'Andi Saputra');
  final alamatLengkap =
      TextEditingController(text: 'Jl. Melati No. 5, Bandung');
  final noTelepon = TextEditingController(text: '0812-3456-7890');

  // Section 2: Akun Aplikasi
  final username = TextEditingController(text: 'andi.saputra');
  final email = TextEditingController(text: 'andi.saputra@gmail.com');
  final password = TextEditingController(text: '');
  final showPassword = false.obs;

  // Section 3: Penugasan Rombong
  final rombong = 'Rombong 01 (Alun-Alun Utara)'.obs;
  final unit = 'Unit #01 · Standby Siap Operasional'.obs;

  // Section 4: Jadwal & Hak Akses
  final jadwalRingkas = '4 Hari · Shift Pagi · Kasir & Stok Aktif'.obs;

  // ✅ DATA DUMMY DAFTAR KARYAWAN (BARU)
  final List<Map<String, dynamic>> daftarKaryawan = [
    {
      'nama': 'Andi Saputra',
      'role': 'Barista',
      'rombong': 'Rombong 01',
      'shift': 'Pagi',
      'status': 'aktif',
      'avatarColor': const Color(0xFFFFE1EE),
      'roleColor': const Color(0xFFEF2B7C),
    },
    {
      'nama': 'Rina Wati',
      'role': 'Kasir',
      'rombong': 'Rombong 01',
      'shift': 'Pagi',
      'status': 'aktif',
      'avatarColor': const Color(0xFFE3EEE5),
      'roleColor': const Color(0xFF3A6F43),
    },
    {
      'nama': 'Dedi Kurniawan',
      'role': 'Barista',
      'rombong': 'Rombong 02',
      'shift': 'Sore',
      'status': 'aktif',
      'avatarColor': const Color(0xFFFFF3D6),
      'roleColor': const Color(0xFFEF2B7C),
    },
    {
      'nama': 'Sari Putri',
      'role': 'Kasir',
      'rombong': 'Rombong 02',
      'shift': 'Sore',
      'status': 'cuti',
      'avatarColor': const Color(0xFFFFE1EE),
      'roleColor': const Color(0xFF3A6F43),
    },
  ];

  int get terbukaCount => openSections.where((o) => o).length;

  // ✅ GETTERS UNTUK DAFTAR KARYAWAN (BARU)
  int get jumlahAktif =>
      daftarKaryawan.where((k) => k['status'] == 'aktif').length;

  int get jumlahCuti =>
      daftarKaryawan.where((k) => k['status'] == 'cuti').length;

  // ✅ METHOD TAB (BARU)
  void changeTab(int index) {
    selectedTabIndex.value = index;
    pageController.jumpToPage(index);
  }

  void toggleSection(int index) {
    openSections[index] = !openSections[index];
  }

  void simpanKaryawan() {
    Get.snackbar(
      'Berhasil',
      'Karyawan "${namaLengkap.text}" berhasil disimpan!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    namaLengkap.dispose();
    alamatLengkap.dispose();
    noTelepon.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
