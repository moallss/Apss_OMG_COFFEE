// PATH FILE: lib/features/auth/register/controllers/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/services/auth_service.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../../core/utils/app_dialogs.dart'; // Import untuk custom dialog/snackbar

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ============================================
  // FUNGSI VALIDASI
  // ============================================

  bool _validateNama(String nama) {
    if (nama.trim().isEmpty) {
      _showError('Nama lengkap wajib diisi');
      return false;
    }
    if (nama.trim().length < 2) {
      _showError('Nama minimal 2 karakter');
      return false;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nama.trim())) {
      _showError('Nama hanya boleh mengandung huruf dan spasi');
      return false;
    }
    return true;
  }

  bool _validateEmail(String email) {
    if (email.trim().isEmpty) {
      _showError('Email wajib diisi');
      return false;
    }
    if (!GetUtils.isEmail(email.trim())) {
      _showError('Format email tidak valid');
      return false;
    }
    if (!email.trim().toLowerCase().endsWith('@gmail.com')) {
      _showError('Email harus menggunakan Gmail @gmail.com');
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      _showError('Password wajib diisi');
      return false;
    }
    if (password.length < 8) {
      _showError('Password minimal 8 karakter');
      return false;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      _showError('Password harus mengandung minimal 1 huruf besar A-Z');
      return false;
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      _showError('Password harus mengandung minimal 1 angka 0-9');
      return false;
    }
    if (!RegExp(r'[@#$_\-\.]').hasMatch(password)) {
      _showError('Password harus mengandung minimal 1 simbol @ # _ - atau .');
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _showError('Konfirmasi password wajib diisi');
      return false;
    }
    if (password != confirmPassword) {
      _showError('Konfirmasi password tidak cocok');
      return false;
    }
    return true;
  }

  bool validateForm() {
    if (!_validateNama(namaController.text)) return false;
    if (!_validateEmail(emailController.text)) return false;
    if (!_validatePassword(passwordController.text)) return false;
    if (!_validateConfirmPassword(
        passwordController.text, confirmPasswordController.text)) return false;
    return true;
  }

  // ============================================
  // FUNGSI REGISTER
  // ============================================

  Future<void> register() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      await _authService.register(
        emailController.text.trim(),
        passwordController.text,
        namaController.text.trim(),
        'owner',
      );

      // Tutup keyboard terlebih dahulu agar transisi mulus
      if (Get.context != null) {
        FocusScope.of(Get.context!).unfocus();
      }

      // Notifikasi sukses dengan custom snackbar cantik
      AppDialogs.showCustomSnackbar(
        title: 'Registrasi Berhasil',
        message: 'Akun Owner berhasil dibuat. Silakan login.',
        type: SnackbarType.success,
      );

      // Bersihkan form
      namaController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Navigasi ke halaman login
      Get.offNamed(Routes.login);
    } catch (e) {
      _showError('Gagal mendaftar: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper untuk menampilkan error snackbar (menggunakan custom snackbar)
  void _showError(String message) {
    AppDialogs.showCustomSnackbar(
      title: 'Validasi Gagal',
      message: message,
      type: SnackbarType.error,
    );
  }
}
