part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const ownerDashboard = _Paths.ownerDashboard;
  static const karyawanDashboard = _Paths.karyawanDashboard;
  static const pos = _Paths.pos;
  static const karyawanApp = _Paths.karyawanApp;
  static const ownerApp = _Paths.ownerApp;
  static const distribusi = _Paths.distribusi;
  static const menu = _Paths.menu;
  static const bahanBaku = _Paths.bahanBaku;
  static const resepMenu = _Paths.resepMenu;
  static const forgotPassword = _Paths.forgotPassword;
  static const tambahBarang = _Paths.tambahBarang; // ✅ BARU
  static const pengguna = _Paths.pengguna; // ✅ BARU
  static const tambahKaryawan = _Paths.tambahKaryawan; // di Routes
}

abstract class _Paths {
  _Paths._();
  static const login = '/login';
  static const register = '/register';
  static const ownerDashboard = '/owner-dashboard';
  static const karyawanDashboard = '/karyawan-dashboard';
  static const pos = '/pos';
  static const karyawanApp = '/karyawan-app';
  static const ownerApp = '/owner-app';
  static const distribusi = '/distribusi';
  static const menu = '/menu';
  static const bahanBaku = '/bahan-baku';
  static const resepMenu = '/resep-menu';
  static const forgotPassword = '/forgot-password';
  static const tambahBarang = '/tambah-barang'; // ✅ BARU
  static const pengguna = '/pengguna'; // ✅ BARU
  static const tambahKaryawan = '/tambah-karyawan'; // di _Paths
}
