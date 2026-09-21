// PATH FILE: lib/features/auth/forgot_password/controllers/forgot_password_controller.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/utils/app_dialogs.dart';

class ForgotPasswordController extends GetxController {
  /// ✅ TRUE = demo (kode via dialog). FALSE = Supabase asli (kode via email).
  /// Setelah setup Email Template di Dashboard Supabase → set false.
  static const bool demoMode = true;

  final SupabaseClient _supabase = Supabase.instance.client;

  // 1 = EMAIL, 2 = OTP, 3 = PASSWORD BARU
  final step = 1.obs;

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final countdown = 0.obs;

  Timer? _timer;
  String _demoOtp = '';

  String get formattedCountdown {
    final m = (countdown.value ~/ 60).toString().padLeft(2, '0');
    final s = (countdown.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void gotoStep(int s) {
    if (s < step.value) step.value = s;
  }

  // ============================================
  // STEP 1: KIRIM OTP
  // ============================================
  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return _error('Email wajib diisi');
    if (!GetUtils.isEmail(email)) return _error('Format email tidak valid');
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      return _error('Email harus menggunakan Gmail @gmail.com');
    }

    isLoading.value = true;
    try {
      if (demoMode) {
        await Future.delayed(const Duration(milliseconds: 800));
        _demoOtp = (100000 + Random().nextInt(900000)).toString();
      } else {
        // ✅ REAL: Supabase kirim email recovery berisi {{ .Token }}
        await _supabase.auth.resetPasswordForEmail(email);
      }

      countdown.value = 300;
      _startTimer();
      step.value = 2;

      if (demoMode) {
        AppDialogs.showInfoDialog(
          title: 'Kode OTP Terkirim (DEMO)',
          message: 'Email terkirim ke $email.\nKode demo Anda: $_demoOtp',
          icon: Icons.mail_lock_rounded,
        );
      } else {
        AppDialogs.showCustomSnackbar(
          title: 'Kode Terkirim',
          message: 'Cek inbox email Anda untuk kode OTP.',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      _error('Gagal mengirim kode. Coba lagi sebentar lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown.value <= 1) {
        countdown.value = 0;
        t.cancel();
      } else {
        countdown.value--;
      }
    });
  }

  // ============================================
  // STEP 2: VERIFIKASI OTP
  // ============================================
  Future<void> verifyOtp() async {
    if (countdown.value == 0) {
      return _error('Kode OTP kedaluwarsa. Silakan kirim ulang.');
    }
    final code = otpController.text.trim();
    if (code.length != 6) return _error('Kode OTP harus 6 digit');

    isLoading.value = true;
    try {
      if (demoMode) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (code != _demoOtp) return _error('Kode OTP tidak cocok');
      } else {
        // ✅ REAL: validasi kode recovery → terbentuk recovery session
        await _supabase.auth.verifyOTP(
          type: OtpType.recovery,
          email: emailController.text.trim(),
          token: code,
        );
      }
      step.value = 3;
    } catch (e) {
      _error('Kode OTP tidak valid atau kedaluwarsa.');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================
  // STEP 3: RESET PASSWORD
  // ============================================
  Future<void> resetPassword() async {
    final pass = newPassController.text;
    final conf = confirmPassController.text;

    if (pass.isEmpty || conf.isEmpty) {
      return _error('Password dan konfirmasi wajib diisi');
    }
    if (pass.length < 8) return _error('Password minimal 8 karakter');
    if (!RegExp(r'[A-Z]').hasMatch(pass)) {
      return _error('Password harus mengandung minimal 1 huruf besar A-Z');
    }
    if (!RegExp(r'[0-9]').hasMatch(pass)) {
      return _error('Password harus mengandung minimal 1 angka 0-9');
    }
    if (!RegExp(r'[@#$_\-\.]').hasMatch(pass)) {
      return _error(
          'Password harus mengandung minimal 1 simbol @ # _ - atau .');
    }
    if (pass != conf) return _error('Konfirmasi password tidak cocok');

    isLoading.value = true;
    try {
      if (!demoMode) {
        // ✅ REAL: ganti password pakai recovery session
        await _supabase.auth.updateUser(UserAttributes(password: pass));
        await _supabase.auth.signOut(); // kembalikan ke kondisi login bersih
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
      }

      AppDialogs.showCustomSnackbar(
        title: 'Password Diperbarui',
        message: 'Silakan login dengan password baru Anda.',
        type: SnackbarType.success,
      );
      Get.offNamed(Routes.login);
    } catch (e) {
      _error('Gagal memperbarui password. Coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  void _error(String message) => AppDialogs.showCustomSnackbar(
        title: 'Validasi Gagal',
        message: message,
        type: SnackbarType.error,
      );

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    otpController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
