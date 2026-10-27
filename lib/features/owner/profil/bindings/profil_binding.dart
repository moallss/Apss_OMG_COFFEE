// PATH FILE: lib/features/owner/profil/bindings/profil_binding.dart
import 'package:get/get.dart';
import '../controllers/profil_controller.dart';

class ProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilController>(() => ProfilController());
  }
}
