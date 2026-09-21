// PATH FILE: lib/features/auth/forgot_password/views/forgot_password_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final topPad = MediaQuery.of(context).padding.top;

    // Header pink = 35% tinggi layar (konsisten dengan Login)
    final headerH = screenH * 0.35;

    // Spacing adaptif
    final double ex = screenH >= 720 ? 6.0 : 0.0;

    // ✅ TINGGI MINIMUM CARD (direvisi: proporsi padding pas)
    final double cardMinH = screenH >= 720 ? 440 : 410;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.cream,
          resizeToAvoidBottomInset: true,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // ============================================
              // 1. PINK HEADER (35% tinggi layar)
              // ============================================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerH,
                child: Container(
                  color: AppColors.primary,
                  padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 62),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: screenW - 48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ LOGO SAMA DENGAN LOGIN (non-compact)
                          const BrutalLogoBadge(),
                          const SizedBox(height: 14),
                          // ✅ SKALA JUDUL SAMA DENGAN LOGIN (0.09)
                          Text(
                            'Lupa Password?',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heroShadow.copyWith(
                              fontSize: screenW * 0.09,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const SizedBox(height: 4),
                          // ✅ UKURAN DESKRIPSI SAMA DENGAN LOGIN (12.5)
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                                height: 1.25,
                              ),
                              children: [
                                const TextSpan(text: 'Reset password akun '),
                                TextSpan(
                                  text: 'OMG COFFEE',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.pinkSoft,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                    height: 1.25,
                                  ),
                                ),
                                const TextSpan(text: ' dalam 3 langkah.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ============================================
              // 2. CARD + SCROLL (minHeight revisi)
              // ============================================
              Positioned(
                top: headerH - 46,
                left: 24,
                right: 24,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: cardMinH),
                    child: BrutalCard(
                      padding: EdgeInsets.all(16 + ex),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _stepPills(),
                          const SizedBox(height: 16),
                          Obx(() {
                            switch (controller.step.value) {
                              case 2:
                                return _stepOtp();
                              case 3:
                                return _stepNewPass();
                              default:
                                return _stepEmail();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // FOOTER (paten di luar Scaffold)
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).padding.bottom + 20,
          child: Center(
            child: Text(
              'OMG COFFEE · COFFEE KELILING',
              style: AppTextStyles.labelUpper.copyWith(
                color: AppColors.muted,
                fontSize: 9,
                backgroundColor: Colors.transparent,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STEP PILLS 1-2-3
  // ==========================================
  Widget _stepPills() {
    const labels = ['EMAIL', 'OTP', 'PASSWORD'];
    return Obx(() => Row(
          children: List.generate(3, (i) {
            final idx = i + 1;
            final active = controller.step.value == idx;
            final done = controller.step.value > idx;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.gotoStep(idx),
                child: Container(
                  height: 38,
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary
                        : (done
                            ? AppColors.brandGreen.withOpacity(0.12)
                            : AppColors.appWhite),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: active
                          ? AppColors.ink
                          : (done ? AppColors.brandGreen : AppColors.ink),
                      width: 1.5,
                    ),
                    boxShadow: active ? AppShadows.hard(2) : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$idx',
                          style: GoogleFonts.inter(
                              color: active
                                  ? Colors.white
                                  : (done
                                      ? AppColors.brandGreen
                                      : AppColors.muted),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900)),
                      Text(labels[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              color: active
                                  ? Colors.white
                                  : (done
                                      ? AppColors.brandGreen
                                      : AppColors.muted),
                              fontSize: 6.8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }

  // ==========================================
  // STEP 1: EMAIL
  // ==========================================
  Widget _stepEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ✅ FONT SAMA DENGAN LOGIN: headingMedium (~18)
        Text('Reset Password', style: AppTextStyles.headingMedium),
        const SizedBox(height: 4),
        Text('Masukkan email terdaftar untuk menerima kode OTP',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 16),
        BrutalInput(
          label: 'EMAIL',
          controller: controller.emailController,
          hint: 'nama@gmail.com',
          icon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => controller.sendOtp(),
        ),
        const SizedBox(height: 16),
        Obx(() => BrutalButton(
              text: 'Kirim Kode OTP',
              icon: Icons.send_rounded,
              loading: controller.isLoading.value,
              onPressed: controller.sendOtp,
            )),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, color: AppColors.muted, size: 14),
            const SizedBox(width: 6),
            Flexible(
              child: Text('Kode OTP berlaku 5 menit setelah dikirim',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _backToLoginRow(),
      ],
    );
  }

  // ==========================================
  // STEP 2: OTP
  // ==========================================
  Widget _stepOtp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Masukkan Kode OTP', style: AppTextStyles.headingMedium),
        const SizedBox(height: 4),
        Text('Kode terkirim ke ${controller.emailController.text.trim()}',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 16),
        BrutalInput(
          label: 'KODE OTP',
          controller: controller.otpController,
          hint: '6 digit kode',
          icon: Icons.confirmation_number_rounded,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => Center(
              child: controller.countdown.value > 0
                  ? Text(
                      'Kirim ulang kode dalam ${controller.formattedCountdown}',
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted))
                  : GestureDetector(
                      onTap: controller.sendOtp,
                      child: Text('Kirim ulang kode',
                          style: AppTextStyles.linkPink.copyWith(
                              fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
            )),
        const SizedBox(height: 16),
        BrutalButton(
          text: 'Verifikasi Kode',
          icon: Icons.verified_user_rounded,
          onPressed: controller.verifyOtp,
        ),
        const SizedBox(height: 16),
        _backToLoginRow(),
      ],
    );
  }

  // ==========================================
  // STEP 3: PASSWORD BARU
  // ==========================================
  Widget _stepNewPass() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Buat Password Baru', style: AppTextStyles.headingMedium),
        const SizedBox(height: 4),
        Text('Gunakan kombinasi huruf besar, angka & simbol',
            style: AppTextStyles.bodySmall),
        const SizedBox(height: 16),
        Obx(() => BrutalInput(
              label: 'PASSWORD BARU',
              controller: controller.newPassController,
              hint: 'Minimal 8 karakter...',
              icon: Icons.lock_rounded,
              obscureText: !controller.isPasswordVisible.value,
              suffix: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                onPressed: controller.togglePasswordVisibility,
                icon: BrutalIcon(
                  icon: controller.isPasswordVisible.value
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
              ),
            )),
        const SizedBox(height: 14),
        Obx(() => BrutalInput(
              label: 'KONFIRMASI PASSWORD',
              controller: controller.confirmPassController,
              hint: 'Ulangi password baru...',
              icon: Icons.lock_person_rounded,
              obscureText: !controller.isConfirmPasswordVisible.value,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => controller.resetPassword(),
              suffix: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                onPressed: controller.toggleConfirmPasswordVisibility,
                icon: BrutalIcon(
                  icon: controller.isConfirmPasswordVisible.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                ),
              ),
            )),
        const SizedBox(height: 16),
        Obx(() => BrutalButton(
              text: 'Simpan Password Baru',
              icon: Icons.save_rounded,
              loading: controller.isLoading.value,
              onPressed: controller.resetPassword,
            )),
        const SizedBox(height: 16),
        _backToLoginRow(),
      ],
    );
  }

  // ==========================================
  // LINK KEMBALI KE LOGIN
  // ==========================================
  Widget _backToLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ✅ bodySmall 11/600 muted (sama dengan "Belum punya akun?")
        Text('Ingat password? ', style: AppTextStyles.bodySmall),
        GestureDetector(
          onTap: () => Get.offNamed(Routes.login),
          // ✅ linkPink 11/800 (sama dengan "Daftar")
          child: Text('Masuk',
              style: AppTextStyles.linkPink
                  .copyWith(fontSize: 11, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
