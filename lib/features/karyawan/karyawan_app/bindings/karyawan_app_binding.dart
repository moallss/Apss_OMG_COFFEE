import 'package:get/get.dart';
import '../../karyawan_dashboard/controllers/karyawan_dashboard_controller.dart';
import '../../pos/pos_karyawan/controllers/pos_controller.dart';
import '../controllers/karyawan_app_controller.dart';

class KaryawanAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KaryawanAppController());
    Get.lazyPut(() => KaryawanDashboardController());
    Get.lazyPut(() => POSController());
  }
}
