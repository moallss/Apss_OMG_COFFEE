// PATH FILE: lib/features/karyawan/karyawan_dashboard/controllers/karyawan_dashboard_controller.dart
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
  final karyawanPhotoUrl = ''.obs;

  // ✅ BARU: Jam live & label tanggal
  final currentTime = ''.obs;
  final tanggalLabel = ''.obs;
  final performaDate = ''.obs;
  Timer? _clockTimer;

  // State Check-In
  final isCheckedIn = false.obs;
  final isLoadingCheckIn = false.obs;
  final checkInTime = ''.obs;
  final distribusiConfirmedTime = ''.obs;

  // Data Dashboard - Belum Check-In
  final jumlahBahan = 5.obs;
  final jumlahBarang = 3.obs;

  // ✅ BARU: Data card desain baru
  final shiftLabel = 'Shift Pagi'.obs;
  final shiftJam = '07:00 - 15:00'.obs;
  final rombongLabel = 'Rombong 01'.obs;
  final partnerLabel = 'Partner: Andi & Dimas'.obs;
  final ruteCount = '3 titik rute'.obs;
  final ruteLabel = 'Alun-Alun • Balai Kota • Bumi Asri'.obs;
  final distribusiBahan = 5.obs;
  final distribusiBarang = 4.obs;
  final posBadge = 3.obs;

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

  // ✅ BARU: Performa kemarin
  final performaTransaksi = 32.obs;
  final performaOmzet = 'Rp 480rb'.obs;
  final performaAudit = 98.obs;

  // ✅ STATE CHECK-IN SHEET (3 TAHAP)
  final checkInStep = 1.obs;
  final selfieTaken = false.obs;
  final selfieTime = ''.obs;
  final gpsAccuracy = '±3m'.obs;
  final logisticsConfirmed = false.obs;

  final List<Map<String, dynamic>> logistikItems = [
    {
      'icon': Icons.coffee_rounded,
      'tint': const Color(0xFFFFF3D6),
      'nama': 'Kopi Arabica Gayo',
      'detail': 'Biji kopi sangrai fresh',
      'qty': '8,5',
      'unit': 'Kg',
    },
    {
      'icon': Icons.local_drink_rounded,
      'tint': const Color(0xFFE3F2FD),
      'nama': 'Susu UHT Full Cream',
      'detail': '12 karton kemasan 1L',
      'qty': '12',
      'unit': 'Liter',
    },
    {
      'icon': Icons.water_drop_rounded,
      'tint': const Color(0xFFFFF3D6),
      'nama': 'Gula Aren Cair',
      'detail': '1 jerigen segel utuh',
      'qty': '5',
      'unit': 'Liter',
    },
    {
      'icon': Icons.coffee_maker_rounded,
      'tint': const Color(0xFFE3EEE5),
      'nama': 'Cup 16oz & Sedotan',
      'detail': 'Lengkap dengan lid cup',
      'qty': '200',
      'unit': 'PCS',
    },
  ];

  // ✅ Reset state sebelum sheet dibuka
  void prepareCheckIn() {
    checkInStep.value = 1;
    selfieTaken.value = false;
    selfieTime.value = '';
    logisticsConfirmed.value = false;
  }

  // ✅ Simulasi ambil foto selfie
  void takeSelfie() {
    final n = DateTime.now();
    selfieTime.value =
        '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}:${n.second.toString().padLeft(2, '0')} WIB';
    selfieTaken.value = true;
  }

  void nextCheckInStep() {
    if (checkInStep.value < 3) checkInStep.value++;
  }

  void prevCheckInStep() {
    if (checkInStep.value > 1) checkInStep.value--;
  }

  void toggleLogisticsConfirmed() {
    logisticsConfirmed.value = !logisticsConfirmed.value;
  }

  // ✅ Selesaikan check-in lalu tutup sheet
  Future<void> finishCheckIn() async {
    await checkIn();
    if (isCheckedIn.value) Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadDashboardData();
    _checkClosingAvailability();
    _startClock();
    _setDateLabels();
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }

  // ✅ Jam live (update tiap detik)
  void _startClock() {
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateClock();
    });
  }

  void _updateClock() {
    final now = DateTime.now();
    currentTime.value =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // ✅ Label tanggal Indonesia
  void _setDateLabels() {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    final n = DateTime.now();
    tanggalLabel.value =
        '${days[n.weekday - 1]}, ${n.day} ${months[n.month - 1]} ${n.year}';

    final y = n.subtract(const Duration(days: 1));
    performaDate.value = '${y.day} ${months[y.month - 1]}';
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

  void bukaDistribusi() {
    AppDialogs.showCustomSnackbar(
      title: 'Distribusi',
      message:
          '${distribusiBahan.value} bahan & ${distribusiBarang.value} barang menunggu konfirmasi setelah check-in.',
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

  // ✅ Info stok kritis
  void bukaStok() {
    AppDialogs.showCustomSnackbar(
      title: 'Stok Kritis',
      message: 'Susu UHT & Cup 16oz menipis — buka tab STOK untuk detail.',
      type: SnackbarType.warning,
    );
  }

  // ✅ Navigasi ke Kasir dari card status (sudah check-in)
  void bukaKasir() {
    Get.toNamed(Routes.pos);
  }
}
