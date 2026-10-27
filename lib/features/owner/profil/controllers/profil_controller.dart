// PATH FILE: lib/features/owner/profil/controllers/profil_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilController extends GetxController {
  // Data Profil Owner
  final namaOwner = 'Bages Arisandi'.obs;
  final roleOwner = 'OWNER'.obs;
  final fotoUrl = 'https://i.pravatar.cc/150?u=bages';
  final telepon = '0812-9876-5...'.obs;
  final email = 'bages@omg...'.obs;

  // Data Profil Usaha
  final namaUsaha = 'OMG Coffee'.obs;
  final lokasiUsaha = 'Bandung, Jawa Barat'.obs;
  final jamOperasional = '07:00 - 21:00 WIB'.obs;

  // Kontak Detail
  final emailPribadi = 'halo@omgcoffee.id'.obs;
  final teleponBisnis = '0812-9876-5432'.obs;
  final emailBisnis = 'omgcoffee.id'.obs;
  final website = 'www.omgcoffee...'.obs;
  final instagram = '@omgcoffee_id'.obs;

  // Navigasi
  final selectedTabIndex = 3.obs;
  final PageController pageController = PageController(initialPage: 3);

  void changeTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
  }
}
