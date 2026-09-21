// PATH FILE: lib/features/auth/register/views/register_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final topPad = MediaQuery.of(context).padding.top;

    // Header 35% tinggi layar (konsisten dengan Login & Lupa PW)
    final headerH = screenH * 0.35;

    // ✅ OVERLAP ADAPTIF: layar tinggi → card naik lebih dalam ke header
    final double overlap = screenH >= 720 ? 130 : 72;
    // ✅ SPACING ADAPTIF: layar tinggi → spacing lebih lega
    final double ex = screenH >= 720 ? 6.0 : 0.0;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.cream,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Positioned.fill(child: Container(color: AppColors.cream)),

              // ============================================
              // 1. HEADER PINK (35%)
              // ============================================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerH,
                child: RepaintBoundary(
                  child: Container(
                    color: AppColors.primary,
                    // ✅ padding bottom = overlap + napas pink 14
                    padding:
                        EdgeInsets.fromLTRB(24, topPad + 16, 24, overlap + 14),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: screenW - 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            const BrutalLogoBadge(),
                            const SizedBox(height: 14),
                            Text(
                              'Selamat Bergabung',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heroShadow.copyWith(
                                fontSize: screenW * 0.09,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const SizedBox(height: 4),
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
                                  const TextSpan(
                                      text: 'Pendaftaran akun khusus Owner '),
                                  TextSpan(
                                    text: 'OMG COFFEE.',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.pinkSoft,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ============================================
              // 2. CARD FORM (RAISE: overlap 72px ke header)
              // ============================================
              Positioned(
                top: headerH - overlap, // ✅ SEBELUM: headerH - 72
                left: 24,
                right: 24,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  // ✅ ConstrainedBox minHeight DIHAPUS (konten register sudah panjang)
                  child: BrutalCard(
                    padding: EdgeInsets.all(
                        14 + ex), // ✅ padding uniform proporsional
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Buat Akun Baru',
                            style: AppTextStyles.headingMedium),
                        const SizedBox(height: 4),
                        Text('Pendaftaran khusus Owner',
                            style: AppTextStyles.bodySmall),
                        SizedBox(height: 12 + ex), // ✅ ritme group

                        // --- NAMA LENGKAP ---
                        BrutalInput(
                          label: 'NAMA LENGKAP',
                          controller: controller.namaController,
                          hint: 'Nama lengkap...',
                          icon: Icons.person_rounded,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 10 + ex), // ✅ ritme base

                        // --- EMAIL ---
                        BrutalInput(
                          label: 'EMAIL',
                          controller: controller.emailController,
                          hint: 'nama@gmail.com',
                          icon: Icons.email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        SizedBox(height: 10 + ex), // ✅ ritme base

                        // --- PASSWORD ---
                        Obx(() => BrutalInput(
                              label: 'PASSWORD',
                              controller: controller.passwordController,
                              hint: 'Minimal 8 karakter...',
                              icon: Icons.lock_rounded,
                              obscureText: !controller.isPasswordVisible.value,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              suffix: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 44, minHeight: 44),
                                onPressed: controller.togglePasswordVisibility,
                                icon: BrutalIcon(
                                  icon: controller.isPasswordVisible.value
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  size: 20,
                                ),
                              ),
                            )),
                        SizedBox(height: 10 + ex), // ✅ ritme base

                        // --- KONFIRMASI PASSWORD ---
                        Obx(() => BrutalInput(
                              label: 'KONFIRMASI PASSWORD',
                              controller: controller.confirmPasswordController,
                              hint: 'Ulangi password...',
                              icon: Icons.lock_person_rounded,
                              obscureText:
                                  !controller.isConfirmPasswordVisible.value,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => controller.register(),
                              suffix: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 44, minHeight: 44),
                                onPressed:
                                    controller.toggleConfirmPasswordVisibility,
                                icon: BrutalIcon(
                                  icon:
                                      controller.isConfirmPasswordVisible.value
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                  size: 20,
                                ),
                              ),
                            )),
                        SizedBox(height: 12 + ex), // ✅ ritme group

                        // --- TOMBOL DAFTAR ---
                        Obx(() => BrutalButton(
                              text: 'Daftar',
                              icon: Icons.arrow_forward_rounded,
                              loading: controller.isLoading.value,
                              onPressed: controller.register,
                            )),
                        SizedBox(height: 10 + ex), // ✅ ritme base

                        // --- LINK LOGIN ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sudah punya akun? ',
                                style: AppTextStyles.bodySmall),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.login),
                              child: Text(
                                'Masuk',
                                style: AppTextStyles.linkPink.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ============================================
        // 3. FOOTER (paten di luar Scaffold)
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
}
