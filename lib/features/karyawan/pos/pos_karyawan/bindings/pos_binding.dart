// PATH FILE: lib/features/pos/bindings/pos_binding.dart
import 'package:get/get.dart';
import '../controllers/pos_controller.dart'; // <-- PATH DIPERBAIKI

class POSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<POSController>(() => POSController());
  }
}
