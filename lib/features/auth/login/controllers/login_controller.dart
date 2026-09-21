// PATH FILE: lib/features/auth/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/app_dialogs.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    // Dispose akan otomatis membersihkan controller
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Data Belum Lengkap',
        message: 'Email dan password wajib diisi.',
        type: SnackbarType.warning, // Warna Oranye
      );
      return;
    }

    isLoading.value = true;
    if (Get.context != null) FocusScope.of(Get.context!).unfocus();

    try {
      final AuthResponse response = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      final String role = response.user?.userMetadata?['role'] ?? 'unknown';

      AppDialogs.showCustomSnackbar(
        title: 'Login Berhasil',
        message: 'Selamat datang! Role Anda: ${role.toUpperCase()}',
        type: SnackbarType.success, // Warna Hijau
      );

      if (role == 'owner') {
        Get.offAllNamed(Routes.ownerApp); // ✅ Masuk ke shell + shared navbar
      } else if (role == 'karyawan') {
        Get.offAllNamed(Routes.karyawanApp); // ✅ Masuk ke shell + shared navbar
      } else if (role == 'investor') {
        Get.offAllNamed(Routes.register);
      } else {
        AppDialogs.showCustomSnackbar(
          title: 'Error',
          message: 'Role tidak dikenali di sistem.',
          type: SnackbarType.error, // Warna Merah
        );
      }
    } catch (e) {
      AppDialogs.showCustomSnackbar(
        title: 'Login Gagal',
        message: 'Email atau password yang Anda masukkan salah.',
        type: SnackbarType.error, // Warna Merah
      );
    } finally {
      isLoading.value = false;
    }
  }
}
