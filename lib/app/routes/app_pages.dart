import 'package:get/get.dart';

import '../../features/auth/login/bindings/login_binding.dart';
import '../../features/auth/login/views/login_view.dart';
import '../../features/auth/register/bindings/register_binding.dart';
import '../../features/auth/register/views/register_view.dart';
import '../../features/owner/owner_dashboard/bindings/owner_dashboard_binding.dart';
import '../../features/owner/owner_dashboard/views/owner_dashboard_view.dart';
import '../../features/karyawan/karyawan_dashboard/bindings/karyawan_dashboard_binding.dart';
import '../../features/karyawan/karyawan_dashboard/views/karyawan_dashboard_view.dart';
import '../../features/karyawan/pos/pos_karyawan/bindings/pos_binding.dart';
import '../../features/karyawan/pos/pos_karyawan/views/pos_view.dart';
import '../../features/karyawan/karyawan_app/bindings/karyawan_app_binding.dart';
import '../../features/karyawan/karyawan_app/views/karyawan_app_view.dart';
import '../../features/owner/owner_app/bindings/owner_app_binding.dart';
import '../../features/owner/owner_app/views/owner_app_view.dart';
import '../../features/owner/distribusi/bindings/distribusi_binding.dart';
import '../../features/owner/distribusi/views/distribusi_view.dart';
import '../../features/owner/menu/bindings/menu_binding.dart';
import '../../features/owner/menu/views/menu_view.dart';
import '../../features/owner/bahan_baku/bindings/bahan_baku_binding.dart';
import '../../features/owner/bahan_baku/views/bahan_baku_view.dart';
import '../../features/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../../features/auth/forgot_password/views/forgot_password_view.dart';

import '../../features/owner/resep_menu/bindings/resep_menu_binding.dart';
import '../../features/owner/resep_menu/views/resep_menu_view.dart';

// ✅ PERBAIKI PATH IMPORT (tambahkan ../../)
import '../../features/owner/barang_operasional/views/tambah_barang_view.dart';
import '../../features/owner/barang_operasional/bindings/tambah_barang_binding.dart';

import '../../features/owner/pengguna/bindings/pengguna_binding.dart';
import '../../features/owner/pengguna/views/pengguna_view.dart';

import '../../features/owner/karyawan_pengelolaan/bindings/tambah_karyawan_binding.dart';
import '../../features/owner/karyawan_pengelolaan/views/tambah_karyawan_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ownerDashboard,
      page: () => const OwnerDashboardView(),
      binding: OwnerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.karyawanDashboard,
      page: () => const KaryawanDashboardView(),
      binding: KaryawanDashboardBinding(),
    ),
    GetPage(
      name: _Paths.pos,
      page: () => const POSView(),
      binding: POSBinding(),
    ),
    GetPage(
      name: _Paths.karyawanApp,
      page: () => const KaryawanAppView(),
      binding: KaryawanAppBinding(),
    ),
    GetPage(
      name: _Paths.ownerApp,
      page: () => const OwnerAppView(),
      binding: OwnerAppBinding(),
    ),
    GetPage(
      name: _Paths.distribusi,
      page: () => const DistribusiView(),
      binding: DistribusiBinding(),
    ),
    GetPage(
      name: _Paths.menu,
      page: () => const MenuView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: _Paths.bahanBaku,
      page: () => const BahanBakuView(),
      binding: BahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.resepMenu,
      page: () => const ResepMenuView(),
      binding: ResepMenuBinding(),
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ), // ✅ TUTUP GetPage forgotPassword DENGAN BENAR

    // ✅ TAMBAHKAN ROUTE TAMBAH BARANG DI SINI (SEJAJAR, BUKAN NESTED)
    GetPage(
      name: _Paths.tambahBarang,
      page: () => TambahBarangView(),
      binding: TambahBarangBinding(),
    ),
    GetPage(
      name: _Paths.pengguna,
      page: () => const PenggunaView(),
      binding: PenggunaBinding(),
    ),
    GetPage(
      name: _Paths.tambahKaryawan,
      page: () => const TambahKaryawanView(),
      binding: TambahKaryawanBinding(),
    ),
  ];
}
