import 'package:get/get.dart';
import '../controllers/draft_karyawan_controller.dart';

class DraftKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DraftKaryawanController>(() => DraftKaryawanController());
  }
}
