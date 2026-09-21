// PATH FILE: lib/features/auth/login/views/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final topPad = MediaQuery.of(context).padding.top;

    // HEADER PINK = 35% tinggi layar (40% dikurangi 5%)
    final headerH = screenH * 0.35;
    final double ex = screenH >= 720 ? 6.0 : 0.0;

    // ✅ STACK LUAR: Scaffold + footer terpisah
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.cream,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Positioned.fill(child: Container(color: AppColors.cream)),

              // ============================================
              // 1. HEADER PINK (FittedBox = anti overflow)
              // ============================================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerH,
                child: RepaintBoundary(
                  child: Container(
                    color: AppColors.primary,
                    padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ HAPUS BrutalDots() dan BrutalStar()
                        const SizedBox(height: 8),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: screenW - 48,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const BrutalLogoBadge(),
                                  const SizedBox(height: 14),
                                  Text('Selamat Datang',
                                      style: AppTextStyles.heroShadow
                                          .copyWith(fontSize: screenW * 0.09)),
                                  const SizedBox(height: 6),
                                  // ✅ HAPUS BrutalSquiggle() (garis kuning "=")
                                  const SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.body.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5),
                                      children: [
                                        const TextSpan(
                                            text:
                                                'Aplikasi manajemen operasional Coffee Keliling '),
                                        TextSpan(
                                          text: 'OMG COFFEE.',
                                          style: AppTextStyles.body.copyWith(
                                              color: AppColors.pinkSoft,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============================================
              // 2. CARD LOGIN (spacing adaptif)
              // ============================================
              Positioned(
                top: headerH - 46,
                left: 24,
                right: 24,
                child: RepaintBoundary(
                  child: BrutalCard(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: ex),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Masuk ke Akun',
                              style: AppTextStyles.headingMedium),
                          const SizedBox(height: 4),
                          Text('Silakan masukkan detail akun Anda',
                              style: AppTextStyles.bodySmall),
                          SizedBox(height: 18 + ex),
                          BrutalInput(
                            label: 'EMAIL',
                            controller: controller.emailController,
                            hint: 'omgcoffee@gmail.com',
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                          ),
                          SizedBox(height: 14 + ex),
                          Obx(() => BrutalInput(
                                label: 'PASSWORD',
                                controller: controller.passwordController,
                                hint: '••••••••••••',
                                icon: Icons.lock_rounded,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => controller.login(),
                                suffix: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                      minWidth: 44, minHeight: 44),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                  icon: BrutalIcon(
                                    icon: controller.isPasswordVisible.value
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    size: 20,
                                  ),
                                ),
                              )),
                          SizedBox(height: 8 + ex),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Get.toNamed(Routes.forgotPassword),
                              child: Text('Lupa password?',
                                  style: AppTextStyles.linkPink
                                      .copyWith(fontSize: 12)),
                            ),
                          ),
                          SizedBox(height: 16 + ex),
                          Obx(() => BrutalButton(
                                text: 'Masuk',
                                icon: Icons.arrow_forward_rounded,
                                loading: controller.isLoading.value,
                                onPressed: controller.login,
                              )),
                          SizedBox(height: 16 + ex),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Belum punya akun? ',
                                  style: AppTextStyles.bodySmall),
                              GestureDetector(
                                onTap: () => Get.toNamed(Routes.register),
                                child: Text('Daftar',
                                    style: AppTextStyles.linkPink),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ============================================
        // 3. FOOTER (DI LUAR SCAFFOLD = paten di bawah layar)
        //    Keyboard muncul → footer DITUTUPI keyboard,
        //    bukan ikut naik.
        // ============================================
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
                backgroundColor: Colors.transparent, // ✅ hapus highlight kuning
                decoration: TextDecoration.none, // ✅ hapus underline kuning
                decorationColor: Colors.transparent,
                decorationThickness: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
