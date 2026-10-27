// PATH FILE: lib/features/karyawan/profil_karyawan/controllers/profil_karyawan_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../../../../data/services/auth_service.dart';

import '../../karyawan_app/controllers/karyawan_app_controller.dart';
import '../../karyawan_dashboard/controllers/karyawan_dashboard_controller.dart';
import '../../setting/views/setting_view.dart';
import '../../setting/bindings/setting_binding.dart';

class ProfilKaryawanController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Data profil
  final nama = 'Andi Saputra'.obs;
  final initial = 'A'.obs;
  final role = 'KARYAWAN'.obs;
  final status = 'AKTIF'.obs;
  final idKaryawan = 'KRY-014'.obs;
  final bergabung = 'Bergabung Jan 2026'.obs;
  final telepon = '0812-3456-7890'.obs;
  final email = 'andi.saputra@omgcoffee.id'.obs;

  // ✅ TAMBAHKAN DUA BARIS INI DI SINI
  final fotoUrl = ''.obs; // Untuk URL gambar profil (kosong jika belum ada)
  final alamat = 'Belum diisi'.obs; // Untuk alamat domisili karyawan

  // Penugasan aktif
  final rombong = 'Rombong 01'.obs;
  final partner = 'Partner: Dimas'.obs;
  final shift = 'Shift Pagi'.obs;
  final jamShift = '07:00 - 15:00'.obs;
  final rute = '3 Titik Rute'.obs;
  final ruteDetail = 'Alun-Alun • Balai Kota • Bumi Asri'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfil();
  }

  void _loadProfil() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      final user = session.user;

      // Nama & Initial
      final fullName = user.userMetadata?['full_name'] ??
          user.userMetadata?['nama_lengkap'] ??
          nama.value;
      nama.value = fullName as String;
      initial.value = nama.value.isNotEmpty ? nama.value[0].toUpperCase() : 'K';

      // Email
      final userEmail = user.email;
      if (userEmail != null && userEmail.isNotEmpty) {
        email.value = userEmail;
      }

      // ✅ TAMBAHKAN LOGIKA BERIKUT UNTUK FOTO & ALAMAT
      // Jika metadata Supabase punya field photo_url atau address, ambil dari sana.
      // Jika belum ada, gunakan default dummy di bawah ini agar UI terisi.

      final metaPhoto = user.userMetadata?['photo_url'];
      if (metaPhoto != null && metaPhoto.toString().isNotEmpty) {
        fotoUrl.value = metaPhoto.toString();
      } else {
        fotoUrl.value = ''; // Kosongkan agar tampil inisial huruf
      }

      final metaAddress = user.userMetadata?['address'];
      if (metaAddress != null && metaAddress.toString().isNotEmpty) {
        alamat.value = metaAddress.toString();
      } else {
        // Dummy data untuk demo jika backend belum siap
        alamat.value = 'Jl. Merdeka No. 10, Bandung';
      }
    }
  }

  // Menu actions
  void bukaJadwal() {
    AppDialogs.showCustomSnackbar(
      title: 'Jadwal Saya',
      message: 'Halaman jadwal sedang dalam pengembangan.',
      type: SnackbarType.info,
    );
  }

  void bukaRiwayatClosing() {
    AppDialogs.showCustomSnackbar(
      title: 'Riwayat Closing',
      message: 'Halaman riwayat closing sedang dalam pengembangan.',
      type: SnackbarType.info,
    );
  }

  void bukaNotifikasi() {
    AppDialogs.showCustomSnackbar(
      title: 'Notifikasi',
      message: 'Pusat notifikasi sedang dalam pengembangan.',
      type: SnackbarType.info,
    );
  }

    void bukaPengaturan() {
    Get.to(
      () => const SettingView(),
      binding: SettingBinding(),
      transition: Transition.rightToLeft,
    );
  }

  // ✅ Konfirmasi logout
  void konfirmasiLogout() {
    AppDialogs.showConfirmDialog(
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      confirmText: 'Ya, Logout',
      cancelText: 'Batal',
      onConfirm: () async {
        await _authService.logout();
        Get.offAllNamed(Routes.login);
      },
    );
  }

  // Navigasi bottom nav
  // Navigasi via IndexedStack shell (bukan push route)
  void keBeranda() {
    final appCtrl = Get.find<KaryawanAppController>();
    appCtrl.changeTab(0);
  }

  void keKasir() {
    final dashCtrl = Get.find<KaryawanDashboardController>();
    if (!dashCtrl.isCheckedIn.value) {
      AppDialogs.showCustomSnackbar(
        title: 'POS Terkunci',
        message: 'Silakan Check-In terlebih dahulu.',
        type: SnackbarType.warning,
      );
      return;
    }
    final appCtrl = Get.find<KaryawanAppController>();
    appCtrl.changeTab(1);
  }

  void keStok() {
    AppDialogs.showCustomSnackbar(
      title: 'Segera Hadir',
      message: 'Halaman stok sedang dalam pengembangan.',
      type: SnackbarType.info,
    );
  }
}
