import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingController extends GetxController {
  // State untuk Preferensi Aplikasi
  final RxBool soundEnabled = true.obs;
  final RxBool vibrationEnabled = true.obs;
  final RxString defaultPaymentMethod = 'CASH'.obs; // CASH atau QRIS

  // ✅ FITUR BARU: MODE LUAR RUANGAN (OUTDOOR MODE)
  // Default OFF. Jika ON, kontras ditingkatkan drastis untuk visibilitas di bawah matahari.
  final RxBool outdoorMode = false.obs;
  final RxBool highContrast = false.obs; // BARU
  final RxBool sunlightUi = false.obs; // BARU

  void toggleHighContrast(bool val) => highContrast.value = val;
  void toggleSunlightUi(bool val) => sunlightUi.value = val;

  // Ukuran Font Global (0=Kecil, 1=Normal, 2=Besar)
  final RxInt fontSizeIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  void _loadPreferences() {
    // Simulasi load dari SharedPreferences/Local Storage
    // Nanti bisa diganti dengan real storage
  }

  void toggleSound(bool val) => soundEnabled.value = val;
  void toggleVibration(bool val) => vibrationEnabled.value = val;
  void setDefaultPayment(String method) => defaultPaymentMethod.value = method;

  // Toggle Outdoor Mode
  void toggleOutdoorMode(bool val) {
    outdoorMode.value = val;
    // Opsional: Bisa trigger rebuild theme global jika diperlukan nanti
  }

  void setFontSize(int index) => fontSizeIndex.value = index;
}
