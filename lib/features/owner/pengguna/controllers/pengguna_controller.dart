import 'package:get/get.dart';

import '../../../../app/routes/app_pages.dart'; // ✅ TAMBAHKAN BARIS INI

class PenggunaController extends GetxController {
  final jumlahKaryawan = 4.obs;
  final jumlahInvestor = 2.obs;
  final karyawanAktif = 3.obs;
  final totalBagiHasil = 35.obs;

  final List<String> karyawanInitials = ['A', 'R', 'D', 'S'];
  final List<String> investorInitials = ['B', 'W'];

  // ✅ NAVIGASI KE ROLE KARYAWAN
  void openKaryawan() {
    Get.toNamed(Routes.tambahKaryawan); // ✅ Ganti snackbar dengan navigasi
  }

  // ✅ NAVIGASI KE ROLE INVESTOR
  void openInvestor() {
    // TODO: Ganti dengan route halaman Investor setelah dibuat
    // Get.toNamed(Routes.investorPengelolaan);
    Get.snackbar(
      'Segera Hadir',
      'Halaman pengelolaan Investor sedang disiapkan.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
