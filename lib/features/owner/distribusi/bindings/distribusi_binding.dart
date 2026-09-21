import 'package:get/get.dart';
import '../controllers/distribusi_controller.dart';

class DistribusiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DistribusiController());
  }
}
