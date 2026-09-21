// PATH FILE: lib/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Login ke Supabase
  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register akun baru dengan metadata role
  Future<AuthResponse> register(
      String email, String password, String nama, String role) async {
    return await _supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'nama_lengkap': nama.trim(),
        'role': role, // 'owner', 'karyawan', atau 'investor'
      },
    );
  }

  /// Mendapatkan role pengguna yang sedang login
  Future<String?> getUserRole() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      // Mengambil role dari metadata user (raw_user_meta_data)
      return session.user.userMetadata?['role'] as String?;
    }
    return null;
  }

  /// Logout dari aplikasi
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  /// Cek apakah user sudah login
  bool get isLoggedIn => _supabase.auth.currentSession != null;
}
