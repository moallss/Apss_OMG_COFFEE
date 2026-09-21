import 'package:get/get.dart';
import '../controllers/ringkasan_pesanan_controller.dart';

class RingkasanPesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RingkasanPesananController>(() => RingkasanPesananController());
  }
}
