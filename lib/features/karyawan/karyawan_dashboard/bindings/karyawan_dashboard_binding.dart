// PATH FILE: lib/features/dashboard/karyawan_dashboard/bindings/karyawan_dashboard_binding.dart
import 'package:get/get.dart';
import '../controllers/karyawan_dashboard_controller.dart';

class KaryawanDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanDashboardController>(
        () => KaryawanDashboardController());
  }
}
