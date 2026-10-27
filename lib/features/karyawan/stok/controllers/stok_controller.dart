import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StokController extends GetxController {
  // State untuk filter aktif (0=SEMUA, 1=KOPI, 2=SUSU & DAIRY, 3=PEMANIS, 4=LAINNYA)
  final RxInt selectedFilterIndex = 0.obs;

  // Data Dummy (Mock) - TOTAL 10 ITEM
  final RxList<Map<String, dynamic>> stokItems = <Map<String, dynamic>>[
    // --- ITEM LAMA (1-5) ---
    {
      'id': 1,
      'nama': 'Espresso Beans Arabica',
      'kategori': 'KOPI',
      'satuan': 'kg',
      'stok': 8.5,
      'maksimal': 20.0,
      'minimum': 2.0,
      'estimasi': '± 470 cup',
      'ikon': Icons.local_cafe_outlined,
      'status': 'AMAN',
    },
    {
      'id': 2,
      'nama': 'Susu UHT Full Cream',
      'kategori': 'SUSU & DAIRY',
      'satuan': 'ltr',
      'stok': 4.5,
      'maksimal': 20.0,
      'minimum': 5.0,
      'estimasi': '± 37 cup',
      'ikon': Icons.water_drop_outlined,
      'status': 'KRITIS',
    },
    {
      'id': 3,
      'nama': 'Paper Cup 16oz Dingin',
      'kategori': 'LAINNYA',
      'satuan': 'pcs',
      'stok': 45.0,
      'maksimal': 200.0,
      'minimum': 50.0,
      'estimasi': '± 45 cup',
      'ikon': Icons.inventory_2_outlined,
      'status': 'KRITIS',
    },
    {
      'id': 4,
      'nama': 'Sirup Gula Aren Asli',
      'kategori': 'PEMANIS',
      'satuan': 'ltr',
      'stok': 2.5,
      'maksimal': 10.0,
      'minimum': 1.0,
      'estimasi': '± 83 cup',
      'ikon': Icons.soup_kitchen_outlined,
      'status': 'MENIPIS',
    },
    {
      'id': 5,
      'nama': 'Sedotan Steril Hitam',
      'kategori': 'LAINNYA',
      'satuan': 'pcs',
      'stok': 250.0,
      'maksimal': 500.0,
      'minimum': 50.0,
      'estimasi': '± 250 cup',
      'ikon': Icons.straighten_rounded,
      'status': 'AMAN',
    },

    // --- ITEM BARU TAMBAHAN (6-10) ---

    // 6. Kopi Robusta (Status: Aman)
    {
      'id': 6,
      'nama': 'Kopi Robusta Premium',
      'kategori': 'KOPI',
      'satuan': 'kg',
      'stok': 15.0,
      'maksimal': 20.0,
      'minimum': 3.0,
      'estimasi': '± 800 cup',
      'ikon': Icons.coffee_rounded,
      'status': 'AMAN',
    },

    // 7. Susu Oat / Nabati (Status: Menipis)
    {
      'id': 7,
      'nama': 'Susu Oat Creamy',
      'kategori': 'SUSU & DAIRY',
      'satuan': 'ltr',
      'stok': 3.0,
      'maksimal': 15.0,
      'minimum': 2.0,
      'estimasi': '± 25 cup',
      'ikon': Icons.grass_rounded, // Ikon daun/oat
      'status': 'MENIPIS',
    },

    // 8. Lidah Cup / Seal Film (Status: Kritis - Penting untuk kemasan)
    {
      'id': 8,
      'nama': 'Seal Film Cup Roll',
      'kategori': 'LAINNYA',
      'satuan': 'roll',
      'stok': 1.0,
      'maksimal': 5.0,
      'minimum': 2.0,
      'estimasi': '± 500 seal',
      'ikon': Icons.movie_creation_outlined,
      'status': 'KRITIS',
    },

    // 9. Sirup Vanila (Status: Aman)
    {
      'id': 9,
      'nama': 'Sirup Vanila French',
      'kategori': 'PEMANIS',
      'satuan': 'botol',
      'stok': 8.0,
      'maksimal': 10.0,
      'minimum': 2.0,
      'estimasi': '± 160 porsi',
      'ikon': Icons.bakery_dining_rounded,
      'status': 'AMAN',
    },

    // 10. Es Batu Kristal (Status: Menipis - Biasa cepat habis siang hari)
    {
      'id': 10,
      'nama': 'Es Batu Kristal Halus',
      'kategori': 'LAINNYA',
      'satuan': 'kg',
      'stok': 12.0,
      'maksimal': 50.0,
      'minimum': 10.0,
      'estimasi': '± 60 gelas',
      'ikon': Icons.ac_unit_rounded,
      'status': 'MENIPIS',
    },
  ].obs;

  // Getter untuk daftar item yang difilter
  List<Map<String, dynamic>> get filteredStokItems {
    if (selectedFilterIndex.value == 0) return stokItems.toList();

    String kategoriTarget = '';
    switch (selectedFilterIndex.value) {
      case 1:
        kategoriTarget = 'KOPI';
        break;
      case 2:
        kategoriTarget = 'SUSU & DAIRY';
        break;
      case 3:
        kategoriTarget = 'PEMANIS';
        break;
      case 4:
        kategoriTarget = 'LAINNYA';
        break;
    }

    return stokItems
        .where((item) => item['kategori'] == kategoriTarget)
        .toList();
  }

  // Cek apakah ada item kritis untuk menampilkan Banner Alert
  bool get hasCriticalStock {
    return stokItems.any((item) => item['status'] == 'KRITIS');
  }

  // Jumlah item kritis
  int get criticalCount {
    return stokItems.where((item) => item['status'] == 'KRITIS').length;
  }

  // Helper Warna Status
  Color getStatusColor(String status) {
    switch (status) {
      case 'KRITIS':
        return const Color(0xFFD32F2F); // Merah
      case 'MENIPIS':
        return const Color(0xFFFFC94D); // Kuning/Oranye
      default:
        return const Color(0xFF2D7A4F); // Hijau
    }
  }

  // Aksi Simulasi Update Stok (+/-)
  void updateStok(int index, double amount) {
    final currentStok = stokItems[index]['stok'] as double;
    final maxStok = stokItems[index]['maksimal'] as double;

    double newStok = currentStok + amount;
    if (newStok < 0) newStok = 0;
    if (newStok > maxStok) newStok = maxStok;

    stokItems[index]['stok'] = newStok;

    // Recalculate status logic simply based on min/max for demo purposes
    final minVal = stokItems[index]['minimum'] as double;
    if (newStok <= minVal) {
      stokItems[index]['status'] = 'KRITIS';
    } else if (newStok <= (minVal * 2)) {
      stokItems[index]['status'] = 'MENIPIS';
    } else {
      stokItems[index]['status'] = 'AMAN';
    }

    stokItems.refresh();
  }
}
