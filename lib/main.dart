// PATH FILE: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'app/bindings/global_binding.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load environment variables
  await dotenv.load(fileName: ".env");

  // 2. Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OMG COFFEE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, // Memanggil tema pink OMG COFFEE
      initialBinding: GlobalBinding(),
      initialRoute: AppPages.initial, // Mengarah ke Splash
      getPages: AppPages.routes,
    );
  }
}
