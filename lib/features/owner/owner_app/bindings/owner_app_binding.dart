import 'package:get/get.dart';
import '../../owner_dashboard/bindings/owner_dashboard_binding.dart';
import '../../owner_data/bindings/owner_data_binding.dart';
import '../controllers/owner_app_controller.dart';

class OwnerAppBinding extends Bindings {
  @override
  void dependencies() {
    // Controller shell (navbar)
    Get.lazyPut(() => OwnerAppController());

    // ✅ Panggil binding tiap fitur tab (manual, karena IndexedStack)
    OwnerDashboardBinding().dependencies();
    OwnerDataBinding().dependencies();
  }
}
