import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

class ResepMenuController extends GetxController {
  final selectedTabIndex = 0.obs;
  final PageController tabPageController = PageController();

  // Form controls
  final selectedMenu = 'Es Kopi Susu'.obs;
  final hargaJual = 18000.obs;
  final kategoriMenu = 'Kopi'.obs;

  // Bahan resep
  final bahanResepList = <Map<String, dynamic>>[
    {
      'nama': 'Kopi Bubuk Arabica',
      'sisa': '8,5 kg',
      'qty': 18,
      'unit': 'gram',
      'harga': 1530,
    },
    {
      'nama': 'Susu UHT Full Cream',
      'sisa': '0,8 L',
      'qty': 150,
      'unit': 'ml',
      'harga': 2700,
    },
    {
      'nama': 'Gula Aren Cair',
      'sisa': '2,5 L',
      'qty': 30,
      'unit': 'ml',
      'harga': 750,
    },
  ].obs;

  // Barang pelengkap
  final barangPelengkapList = <Map<String, dynamic>>[
    {
      'nama': 'Cup 16oz',
      'sisa': '0 pcs',
      'qty': 1,
      'unit': 'pcs',
      'harga': 800,
      'isKritis': true,
    },
    {
      'nama': 'Sedotan Hitam',
      'sisa': '250 pcs',
      'qty': 1,
      'unit': 'pcs',
      'harga': 200,
      'isKritis': true,
    },
    {
      'nama': 'Tisu Makan',
      'sisa': '100 lembar',
      'qty': 1,
      'unit': 'lembar',
      'harga': 300,
      'isKritis': false,
    },
  ].obs;

  // Pengaturan biaya
  final buangSisa = 5.obs;
  final biayaLain = 0.obs;

  // Calculations
  double get totalBahanResep {
    return bahanResepList.fold(0, (sum, item) => sum + (item['harga'] as int));
  }

  double get totalBarangPelengkap {
    return barangPelengkapList.fold(
        0, (sum, item) => sum + (item['harga'] as int));
  }

  double get totalBuangSisa {
    return (totalBahanResep + totalBarangPelengkap) * (buangSisa.value / 100);
  }

  double get hppFinal {
    return totalBahanResep +
        totalBarangPelengkap +
        totalBuangSisa +
        biayaLain.value;
  }

  double get margin {
    if (hppFinal == 0) return 0;
    return ((hargaJual.value - hppFinal) / hppFinal) * 100;
  }

  void changeTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    tabPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  void onTabChanged(int index) => selectedTabIndex.value = index;

  void incrementQty(int index, bool isBahan) {
    if (isBahan) {
      bahanResepList[index]['qty'] = bahanResepList[index]['qty'] + 1;
    } else {
      barangPelengkapList[index]['qty'] = barangPelengkapList[index]['qty'] + 1;
    }
  }

  void decrementQty(int index, bool isBahan) {
    if (isBahan && bahanResepList[index]['qty'] > 1) {
      bahanResepList[index]['qty'] = bahanResepList[index]['qty'] - 1;
    } else if (!isBahan && barangPelengkapList[index]['qty'] > 1) {
      barangPelengkapList[index]['qty'] = barangPelengkapList[index]['qty'] - 1;
    }
  }

  void hapusBahan(int index) {
    bahanResepList.removeAt(index);
  }

  void hapusBarang(int index) {
    barangPelengkapList.removeAt(index);
  }

  void simpanResep() {
    Get.snackbar(
      'Resep Tersimpan',
      'Resep ${selectedMenu.value} berhasil disimpan',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.brandGreen,
      colorText: Colors.white,
    );
  }
}
