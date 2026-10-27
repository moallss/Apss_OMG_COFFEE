// PATH FILE: lib/features/karyawan/profil_karyawan/bindings/profil_karyawan_binding.dart
import 'package:get/get.dart';

import '../controllers/profil_karyawan_controller.dart';

class ProfilKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilKaryawanController>(
      () => ProfilKaryawanController(),
    );
  }
}
