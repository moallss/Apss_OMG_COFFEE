// PATH FILE: lib/data/services/menu_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuService {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _table = 'menu';

  // ==========================================
  // READ: ambil semua menu (urutan terbaru)
  // ==========================================
  Future<List<Map<String, dynamic>>> fetchMenu() async {
    final res = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  // ==========================================
  // CREATE: tambah menu baru
  // ==========================================
  Future<void> createMenu(Map<String, dynamic> data) async {
    await _client.from(_table).insert(data);
  }

  // ==========================================
  // UPDATE: edit menu berdasarkan id
  // ==========================================
  Future<void> updateMenu(String id, Map<String, dynamic> data) async {
    await _client.from(_table).update({
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  // ==========================================
  // DELETE: hapus menu berdasarkan id
  // ==========================================
  Future<void> deleteMenu(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
