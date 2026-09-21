import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DraftKaryawanController extends GetxController {
  final draftList = <Map<String, dynamic>>[
    {
      'id': '#DRV-01',
      'time': '10:00',
      'total': 30000,
      'items': 3,
      'data': [
        {'nama': 'Kopi Susu OMG', 'qty': 2, 'harga': 15000},
        {'nama': 'Americano', 'qty': 1, 'harga': 12000},
      ],
    },
    {
      'id': '#DRV-02',
      'time': '11:30',
      'total': 45000,
      'items': 2,
      'data': [
        {'nama': 'Latte', 'qty': 1, 'harga': 20000},
        {'nama': 'Cappuccino', 'qty': 1, 'harga': 18000},
      ],
    },
    {
      'id': '#DRV-03',
      'time': '12:15',
      'total': 25000,
      'items': 1,
      'data': [
        {'nama': 'Mocha', 'qty': 1, 'harga': 22000},
      ],
    },
  ].obs;

  String formatRupiah(int angka) {
    return 'Rp ${angka.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  void batalkanDraft(String draftId) {
    draftList.removeWhere((draft) => draft['id'] == draftId);
    Get.back();

    Get.snackbar(
      'Draft Dibatalkan',
      'Draft $draftId telah dibatalkan.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void lanjutkanDraft(String draftId) {
    Get.back();

    Get.snackbar(
      'Draft Dilanjutkan',
      'Draft $draftId telah dimuat ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF3A6F43),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  int get draftCount => draftList.length;

  void showConfirmBatalkan(String draftId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Batalkan Draft?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Draft $draftId akan dihapus secara permanen.',
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        batalkanDraft(draftId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Ya, Batalkan',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
