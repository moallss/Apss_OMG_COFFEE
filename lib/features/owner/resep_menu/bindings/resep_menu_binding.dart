import 'package:get/get.dart';
import '../controllers/resep_menu_controller.dart';

class ResepMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResepMenuController>(
      () => ResepMenuController(),
    );
  }
}
