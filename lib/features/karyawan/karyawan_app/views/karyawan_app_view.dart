// PATH FILE: lib/features/karyawan/karyawan_app/views/karyawan_app_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/widgets/brutal_kit.dart';
import '../../karyawan_dashboard/controllers/karyawan_dashboard_controller.dart';
import '../../karyawan_dashboard/views/karyawan_dashboard_view.dart';
import '../../pos/pos_karyawan/views/pos_view.dart';
import '../controllers/karyawan_app_controller.dart';

class KaryawanAppView extends GetView<KaryawanAppController> {
  const KaryawanAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() => IndexedStack(
                  index: controller.currentTabIndex.value,
                  children: const [
                    KaryawanDashboardView(),
                    POSView(),
                    _PlaceholderView(label: 'STOK'),
                    _PlaceholderView(label: 'PROFIL'),
                  ],
                )),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _SharedNavbar(),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// NAVBAR BRUTAL (karyawan)
// ====================================================
class _SharedNavbar extends StatelessWidget {
  static const _navItems = [
    {'icon': Icons.home_rounded, 'label': 'BERANDA'},
    {'icon': Icons.point_of_sale_rounded, 'label': 'POS'},
    {'icon': Icons.inventory_2_rounded, 'label': 'STOK'},
    {'icon': Icons.person_rounded, 'label': 'PROFIL'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          16, 8, 16, MediaQuery.of(context).padding.bottom + 12),
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: appBorder(),
        boxShadow: AppShadows.hard(4),
      ),
      child: Row(
        children: List.generate(_navItems.length, (index) {
          return Expanded(
            child: _NavItem(
              index: index,
              icon: _navItems[index]['icon'] as IconData,
              label: _navItems[index]['label'] as String,
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<KaryawanAppController>();
    final dashController = Get.find<KaryawanDashboardController>();

    return Obx(() {
      final isActive = appController.currentTabIndex.value == index;
      final isLocked = label == 'POS' && !dashController.isCheckedIn.value;
      final fgColor = isLocked ? Colors.white.withOpacity(0.4) : Colors.white;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isLocked) {
            AppDialogs.showInfoDialog(
              title: 'POS Terkunci',
              message:
                  'Silakan Check-In terlebih dahulu untuk mengakses fitur Point of Sale (POS).',
              icon: Icons.lock_rounded,
              iconColor: AppDialogs.warningOrange,
            );
            return;
          }
          if (index == 2 || index == 3) {
            AppDialogs.showCustomSnackbar(
              title: 'Segera Hadir',
              message: 'Halaman $label sedang dalam pengembangan.',
              type: SnackbarType.info,
            );
            return;
          }
          appController.changeTab(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.appWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isActive ? AppColors.ink : Colors.transparent,
                width: 1.5),
            boxShadow: isActive ? AppShadows.hard(2) : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(icon,
                      color: isActive ? AppColors.primary : fgColor, size: 18),
                  if (isLocked)
                    Positioned(
                      bottom: -3,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.ink, width: 1),
                        ),
                        child: const Icon(Icons.lock_rounded,
                            color: Colors.white, size: 8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      color: isActive ? AppColors.primary : fgColor,
                      fontSize: 8,
                      height: 1.1,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
    });
  }
}

class _PlaceholderView extends StatelessWidget {
  final String label;
  const _PlaceholderView({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Halaman $label',
                style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Segera Hadir',
                style:
                    GoogleFonts.inter(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
