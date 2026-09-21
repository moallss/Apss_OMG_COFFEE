// PATH FILE: lib/core/utils/app_dialogs.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDialogs {
  // Warna Tema Aplikasi
  static const Color primaryPink = Color(0xFFFF3E9B);
  static const Color borderPink = Color(0xFFD6336C);
  static const Color warningOrange = Color(0xFFFFB800);
  static const Color successGreen = Color(0xFF2ECC71);
  static const Color errorRed = Color(0xFFE74C3C);

  // ==========================================
  // 1. CUSTOM POPUP DIALOG (Untuk Konfirmasi/Peringatan)
  // ==========================================
  static void showInfoDialog({
    required String title,
    required String message,
    IconData icon = Icons.info_outline_rounded,
    Color iconColor = primaryPink,
    String buttonText = 'Mengerti',
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 32),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onConfirm != null) onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPink,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: borderPink, width: 2)),
                  ),
                  child: Text(buttonText,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Ya, Lanjutkan',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: primaryPink.withOpacity(0.15),
                    shape: BoxShape.circle),
                child: const Icon(Icons.help_outline_rounded,
                    color: primaryPink, size: 32),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryPink,
                        side: const BorderSide(color: borderPink, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(cancelText,
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onConfirm != null) onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side:
                                const BorderSide(color: borderPink, width: 2)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(confirmText,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
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

  // ==========================================
  // 2. CUSTOM SNACKBAR (Untuk Notifikasi Sekilas)
  // ==========================================
  static void showCustomSnackbar({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    Color iconColor;
    Color titleColor;
    IconData iconData;

    // Switch statement yang exhaustive (tanpa default, karena semua case enum sudah dicakup)
    switch (type) {
      case SnackbarType.success:
        iconColor = successGreen;
        titleColor = successGreen;
        iconData = Icons.check_circle_rounded;
        break;
      case SnackbarType.error:
        iconColor = errorRed;
        titleColor = errorRed;
        iconData = Icons.error_rounded;
        break;
      case SnackbarType.warning:
        iconColor = warningOrange;
        titleColor = warningOrange;
        iconData = Icons.warning_rounded;
        break;
      case SnackbarType.info:
        iconColor = primaryPink;
        titleColor = primaryPink;
        iconData = Icons.info_rounded;
        break;
    }

    Get.snackbar(
      '', // Title string dikosongkan karena pakai titleText custom
      '', // Message string dikosongkan karena pakai messageText custom
      titleText: Text(
        title,
        style: GoogleFonts.inter(
            color: titleColor, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.inter(color: Colors.grey[700], fontSize: 12),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      borderRadius: 12, // Rounded corners untuk snackbar
      icon: Icon(iconData, color: iconColor, size: 28),
      // boxShadow DIHAPUS karena tidak didukung oleh Get.snackbar
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      animationDuration: const Duration(milliseconds: 400),
    );
  }
}

// Enum untuk tipe snackbar (diletakkan di luar class)
enum SnackbarType { success, error, warning, info }
