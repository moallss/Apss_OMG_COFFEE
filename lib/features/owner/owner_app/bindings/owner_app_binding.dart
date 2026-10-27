import 'package:get/get.dart';
import '../../owner_dashboard/bindings/owner_dashboard_binding.dart';
import '../../owner_data/bindings/owner_data_binding.dart';
import '../../laporan/bindings/laporan_binding.dart';
import '../../profil/bindings/profil_binding.dart';
import '../controllers/owner_app_controller.dart';

class OwnerAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OwnerAppController());
    OwnerDashboardBinding().dependencies();
    OwnerDataBinding().dependencies();
    LaporanBinding().dependencies();
    ProfilBinding().dependencies();
  }
}
