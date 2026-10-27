import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerDataController extends GetxController {
  // ==========================================
  // CAROUSEL STATE
  // ==========================================
  // ✅ Carousel peek (card berikutnya terlihat)
  final PageController pageController = PageController(viewportFraction: 0.85);
  final carouselIndex = 0.obs;

  void onCarouselChanged(int index) => carouselIndex.value = index;

  void goToSlide(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ==========================================
  // DATA DUMMY (Nanti diganti Supabase real)
  // ==========================================
  final totalMenu = 12.obs;
  final totalKategori = 4.obs;
  // ✅ Sesuai desain: 2 bahan kritis
  final stokKritis = ['Kopi Bubuk', 'Susu UHT'].obs;
  final jumlahKaryawan = 4.obs;
  final jumlahInvestor = 2.obs;
  final sudahCheckIn = 3.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
