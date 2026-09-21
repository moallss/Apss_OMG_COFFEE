// PATH FILE: lib/features/auth/login/bindings/login_binding.dart
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut memastikan Controller dibuat BARU setiap kali halaman Login dibuka.
    // Ini mencegah error "FocusNode/Controller used after being disposed".
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
