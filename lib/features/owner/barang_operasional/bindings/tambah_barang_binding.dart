import 'package:get/get.dart';
import '../controllers/tambah_barang_controller.dart';

class TambahBarangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahBarangController>(
      () => TambahBarangController(),
    );
  }
}
