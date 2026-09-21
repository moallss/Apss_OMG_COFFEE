// PATH FILE: lib/app/middlewares/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  // Priority 1 berarti middleware ini dijalankan paling awal
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Cek apakah user sudah punya session (sudah login)
    final session = Supabase.instance.client.auth.currentSession;

    // Jika BELUM login, tendang paksa ke halaman Login
    if (session == null) {
      return const RouteSettings(name: Routes.login);
    }

    // Jika SUDAH login, izinkan masuk (return null)
    return null;
  }
}
