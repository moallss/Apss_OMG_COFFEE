import 'package:get/get.dart';
import '../controllers/owner_data_controller.dart';

class OwnerDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OwnerDataController());
  }
}
