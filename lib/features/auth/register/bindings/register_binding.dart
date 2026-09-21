// PATH FILE: lib/features/auth/register/bindings/register_binding.dart
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut memastikan Controller dibuat BARU setiap kali halaman Register dibuka.
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}
