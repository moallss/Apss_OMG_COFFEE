// PATH FILE: lib/features/karyawan/karyawan_app/views/karyawan_app_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/premium_navbar.dart';
import '../../karyawan_dashboard/controllers/karyawan_dashboard_controller.dart';
import '../../karyawan_dashboard/views/karyawan_dashboard_view.dart';
import '../../pos/pos_karyawan/views/pos_view.dart';
import '../../profil_karyawan/views/profil_karyawan_view.dart';
import '../../stok/controllers/stok_controller.dart';
import '../../stok/views/stok_view.dart';
import '../controllers/karyawan_app_controller.dart';

class KaryawanAppView extends GetView<KaryawanAppController> {
  const KaryawanAppView({super.key});

  // ✅ Daftar tab karyawan — pakai PremiumNavItem yang SAMA dengan Owner
  static const _navItems = [
    PremiumNavItem(icon: Icons.home_rounded, label: 'Beranda'),
    PremiumNavItem(icon: Icons.point_of_sale_rounded, label: 'POS'),
    PremiumNavItem(icon: Icons.inventory_2_rounded, label: 'Stok'),
    PremiumNavItem(icon: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    // Pastikan StokController terdaftar
    if (!Get.isRegistered<StokController>()) {
      Get.put(StokController());
    }

    final dashController = Get.find<KaryawanDashboardController>();

    // ✅ KONSISTEN OWNER: clip body di GARIS TENGAH navbar.
    //    Saat scroll, konten menyelip ke belakang paruh atas pill,
    //    lalu hilang tepat di tengahnya → efek depth yang sama
    //    di dua role (owner & karyawan).
    final clipBottom = MediaQuery.of(context).padding.bottom +
        PremiumNavbar.bottomGap +
        (PremiumNavbar.barHeight / 2);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          // BODY: berakhir tepat di garis tengah navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: clipBottom,
            child: Obx(() => IndexedStack(
                  index: controller.currentTabIndex.value,
                  children: const [
                    KaryawanDashboardView(),
                    POSView(),
                    StokView(),
                    ProfilKaryawanView(),
                  ],
                )),
          ),
          // NAVBAR: overlay di bawah — WIDGET YANG SAMA PERSIS DENGAN OWNER
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              // Hitung lockedIndices secara reaktif
              final locked = <int>{
                if (!dashController.isCheckedIn.value) 1, // POS = index 1
              };

              return PremiumNavbar(
                currentIndex: controller.currentTabIndex.value,
                items: _navItems,
                lockedIndices: locked,
                onTap: (index) {
                  // Logika lock POS: tampilkan dialog jika belum check-in
                  if (locked.contains(index)) {
                    AppDialogs.showInfoDialog(
                      title: 'POS Terkunci',
                      message:
                          'Silakan Check-In terlebih dahulu untuk mengakses fitur Point of Sale (POS).',
                      icon: Icons.lock_rounded,
                      iconColor: AppDialogs.warningOrange,
                    );
                    return;
                  }
                  controller.changeTab(index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
