import 'package:get/get.dart';
import '../controllers/tambah_karyawan_controller.dart';

class TambahKaryawanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahKaryawanController>(
      () => TambahKaryawanController(),
    );
  }
}
