import 'package:get/get.dart';

import '../controllers/stok_kritis_controller.dart';

class StokKritisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StokKritisController>(() => StokKritisController());
  }
}
