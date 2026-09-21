import 'package:get/get.dart';

class KaryawanAppController extends GetxController {
  // Tab yang sedang aktif (0=Beranda, 1=POS, 2=Stok, 3=Profile)
  final currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
