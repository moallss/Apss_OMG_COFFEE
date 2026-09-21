// PATH FILE: lib/app/bindings/global_binding.dart
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Mendaftarkan AuthService sebagai service global (permanent: true agar tidak dihapus dari memori)
    Get.put<AuthService>(AuthService(), permanent: true);
  }
}
