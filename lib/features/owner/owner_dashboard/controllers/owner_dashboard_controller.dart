// PATH FILE: lib/features/dashboard/owner_dashboard/controllers/owner_dashboard_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_dialogs.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../app/routes/app_pages.dart';

class OwnerDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Data User
  final userName = ''.obs;
  final greeting = ''.obs;
  final currentIndex = 0.obs;

  // REVISI 1: URL Foto Profile Owner (Nanti dihubungkan dengan data dari halaman Profile/Supabase)
  // Kosongkan string ini untuk mengetes fallback (huruf depan nama)
  final ownerPhotoUrl = ''.obs;

  // Loading States
  final isLoadingOmzet = true.obs;
  final isLoadingStok = true.obs;
  final isLoadingKaryawan = true.obs;

  // Data Dashboard
  final omzetHariIni = 'Rp 1.250.000'.obs;
  final estimasiLaba = 'Rp 980.000'.obs;
  final totalTransaksi = '84'.obs;
  final persentaseKenaikan = '+12,5%'.obs;
  final pengeluaranHariIni = 'Rp 270.000'.obs;

  final stokKritis = <Map<String, dynamic>>[
    {
      'nama': 'Kopi Bubuk',
      'kategori': 'Bahan Pokok',
      'stok': 'Sisa 0 dari 20 pcs',
      'status': 'Habis'
    },
    {
      'nama': 'Susu UHT',
      'kategori': 'Dairy',
      'stok': 'Sisa 0,5 L dari 3 L',
      'status': 'Hampir Habis'
    },
    {
      'nama': 'Sirup Karamel',
      'kategori': 'Sirup',
      'stok': 'Sisa 1 dari 5 btl',
      'status': 'Hampir Habis'
    },
  ].obs;

  // REVISI 2: Data Karyawan dengan fotoUrl
  // Saya set 'Agus' fotonya null untuk mengetes fallback huruf 'A'
  final karyawanList = <Map<String, dynamic>>[
    {
      'nama': 'Bayu',
      'info': 'Check-in: 08:15',
      'status': 'Sudah Check-In',
      'fotoUrl': 'https://i.pravatar.cc/150?u=bayu'
    },
    {
      'nama': 'Agus',
      'info': 'Check-in: 08:15',
      'status': 'Sudah Check-In',
      'fotoUrl': null
    },
    {
      'nama': 'Supri',
      'info': 'Shift Siang',
      'status': 'Belum Check-In',
      'fotoUrl': 'https://i.pravatar.cc/150?u=supri'
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    loadDashboardData();
  }

  void _loadUserData() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      final user = session.user;
      userName.value = user.userMetadata?['full_name'] ??
          user.userMetadata?['nama_lengkap'] ??
          'Owner';
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

  Future<void> loadDashboardData() async {
    isLoadingOmzet.value = true;
    isLoadingStok.value = true;
    isLoadingKaryawan.value = true;

    // Simulasi fetch data (nanti ganti dengan Supabase real)
    await Future.delayed(const Duration(milliseconds: 300));

    if (!isClosed) {
      isLoadingOmzet.value = false;
      isLoadingStok.value = false;
      isLoadingKaryawan.value = false;
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
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
}
