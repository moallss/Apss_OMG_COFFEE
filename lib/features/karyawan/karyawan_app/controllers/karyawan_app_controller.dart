import 'package:get/get.dart';
import '../../profil_karyawan/controllers/profil_karyawan_controller.dart';

class KaryawanAppController extends GetxController {
  // Tab yang sedang aktif (0=Beranda, 1=POS, 2=Stok, 3=Profil)
  final currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ PASTIKAN controller Profil terdaftar saat shell dibuka
    //    (backup aman selain di binding — anti error "not found")
    if (!Get.isRegistered<ProfilKaryawanController>()) {
      Get.lazyPut<ProfilKaryawanController>(() => ProfilKaryawanController());
    }
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
