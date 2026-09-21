import 'package:get/get.dart';
import '../controllers/mode_pembayaran_controller.dart';

class ModePembayaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModePembayaranController>(() => ModePembayaranController());
  }
}