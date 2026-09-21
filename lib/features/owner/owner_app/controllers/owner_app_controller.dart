import 'package:get/get.dart';

class OwnerAppController extends GetxController {
  final currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
