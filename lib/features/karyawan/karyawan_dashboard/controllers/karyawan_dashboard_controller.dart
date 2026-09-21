// PATH FILE: lib/features/dashboard/karyawan_dashboard/controllers/karyawan_dashboard_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../data/services/auth_service.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../../core/utils/app_dialogs.dart';

class KaryawanDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Data User
  final userName = ''.obs;
  final greeting = ''.obs;
  final currentIndex = 0.obs;
  final karyawanPhotoUrl = ''.obs;

  // State Check-In
  final isCheckedIn = false.obs;
  final isLoadingCheckIn = false.obs;
  final checkInTime = ''.obs;
  final distribusiConfirmedTime = ''.obs;

  // Data Dashboard - Belum Check-In
  final jumlahBahan = 5.obs;
  final jumlahBarang = 3.obs;

  // Data Dashboard - Sudah Check-In
  final jumlahTransaksi = 100.obs;
  final jumlahPenjualan = 'Rp 500.000'.obs;
  final draftAktifCount = 2.obs;
  final sisaStokDistribusi = <Map<String, dynamic>>[
    {'nama': 'Kopi Bubuk 500g', 'stok': 'Sisa 0 dari 20pcs', 'status': 'Habis'},
    {
      'nama': 'Susu UHT Full Cream',
      'stok': 'Sisa 0,5 L dari 3 L',
      'status': 'Hampir Habis'
    },
  ].obs;
  final closingTime = '17:00'.obs;
  final isClosingAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadDashboardData();
    _checkClosingAvailability();
  }

  void _loadUserData() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      final user = session.user;
      userName.value = user.userMetadata?['full_name'] ??
          user.userMetadata?['nama_lengkap'] ??
          'Karyawan';
      _updateGreeting();
    }
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 11)
      greeting.value = 'Selamat Pagi';
    else if (hour >= 11 && hour < 15)
      greeting.value = 'Selamat Siang';
    else if (hour >= 15 && hour < 18)
      greeting.value = 'Selamat Sore';
    else
      greeting.value = 'Selamat Malam';
  }

  void _loadDashboardData() {
    isLoadingCheckIn.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isLoadingCheckIn.value = false;
    });
  }

  void _checkClosingAvailability() {
    final now = DateTime.now();
    final closingHour = int.parse(closingTime.value.split(':')[0]);
    final closingMinute = int.parse(closingTime.value.split(':')[1]);
    final closingDateTime =
        DateTime(now.year, now.month, now.day, closingHour, closingMinute);

    isClosingAvailable.value =
        now.isAfter(closingDateTime) || now.isAtSameMomentAs(closingDateTime);
  }

  Future<void> checkIn() async {
    isLoadingCheckIn.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      final now = DateTime.now();
      checkInTime.value =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      distribusiConfirmedTime.value =
          '${(now.hour + 1).toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      isCheckedIn.value = true;

      AppDialogs.showCustomSnackbar(
        title: 'Check-In Berhasil',
        message:
            'Selamat bekerja! Operasi distribusi dan inventaris telah aktif.',
        type: SnackbarType.success,
      );
    } catch (e) {
      AppDialogs.showCustomSnackbar(
        title: 'Check-In Gagal',
        message: 'Terjadi kesalahan. Silakan coba lagi.',
        type: SnackbarType.error,
      );
    } finally {
      isLoadingCheckIn.value = false;
    }
  }

  Future<void> closing() async {
    if (!isClosingAvailable.value) {
      AppDialogs.showCustomSnackbar(
        title: 'Belum Waktunya Closing',
        message:
            'Closing aktif setelah pukul ${closingTime.value}. Silakan coba lagi nanti.',
        type: SnackbarType.warning,
      );
      return;
    }

    AppDialogs.showCustomSnackbar(
      title: 'Closing Dimulai',
      message: 'Proses closing operasional sedang berjalan...',
      type: SnackbarType.info,
    );
  }

  Future<void> logout() async {
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

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
