import 'package:get/get.dart';
import '../controllers/notifikasi_karyawan_controller.dart';

class NotifikasiKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifikasiKaryawanController>(
      () => NotifikasiKaryawanController(),
    );
  }
}
