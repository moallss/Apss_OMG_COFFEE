// PATH FILE: lib/features/owner/owner_app/views/owner_app_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/premium_navbar.dart';
import '../../owner_dashboard/views/owner_dashboard_view.dart';
import '../../owner_data/views/owner_data_view.dart';
import '../controllers/owner_app_controller.dart';
import '../../laporan/views/laporan_view.dart';
import '../../profil/views/profil_view.dart';

class OwnerAppView extends GetView<OwnerAppController> {
  const OwnerAppView({super.key});

  static const _navItems = [
    PremiumNavItem(icon: Icons.home_rounded, label: 'Beranda'),
    PremiumNavItem(icon: Icons.grid_view_rounded, label: 'Master Data'),
    PremiumNavItem(icon: Icons.bar_chart_rounded, label: 'Laporan'),
    PremiumNavItem(icon: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ KONSISTEN KARYAWAN: clip body di GARIS TENGAH navbar.
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
                    OwnerDashboardView(),
                    OwnerDataView(),
                    LaporanView(),
                    ProfilView(),
                  ],
                )),
          ),
          // NAVBAR: overlay di bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => PremiumNavbar(
                currentIndex: controller.currentTabIndex.value,
                items: _navItems,
                onTap: (index) {
                  controller.changeTab(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
