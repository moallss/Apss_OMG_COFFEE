// PATH FILE: lib/features/karyawan/karyawan_app/bindings/karyawan_app_binding.dart
import 'package:get/get.dart';

import '../../karyawan_dashboard/controllers/karyawan_dashboard_controller.dart';
import '../../pos/pos_karyawan/controllers/pos_controller.dart';
import '../../profil_karyawan/controllers/profil_karyawan_controller.dart';
import '../controllers/karyawan_app_controller.dart';

class KaryawanAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanAppController>(
      () => KaryawanAppController(),
    );
    Get.lazyPut<KaryawanDashboardController>(
      () => KaryawanDashboardController(),
    );
    Get.lazyPut<POSController>(
      () => POSController(),
    );
    // ✅ BARU: daftarkan controller Profil agar tersedia di IndexedStack
    Get.lazyPut<ProfilKaryawanController>(
      () => ProfilKaryawanController(),
    );
  }
}
