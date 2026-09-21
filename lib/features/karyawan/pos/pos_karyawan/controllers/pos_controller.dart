// PATH FILE: lib/features/pos/controllers/pos_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/utils/app_dialogs.dart';

class POSController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==========================================
  // DATA USER (Dari Supabase Session)
  // ==========================================
  final userName = ''.obs;
  final greeting = ''.obs;

  // ==========================================
  // JUMLAH DRAFT (Untuk Badge)
  // ==========================================
  final draftCount = 3.obs; // Dummy data, nanti dari database

  // ==========================================
  // DATA MENU (Dummy - nanti dari Supabase)
  // ==========================================
// PATH FILE: lib/features/pos/controllers/pos_controller.dart
// TAMBAHKAN field 'foto' di menuList untuk foto dummy:

  final menuList = <Map<String, dynamic>>[
    {
      'id': 1,
      'nama': 'Kopi Susu OMG',
      'harga': 15000,
      'kategori': 'Kopi',
      'stok': 50,
      'foto':
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=200'
    },
    {
      'id': 2,
      'nama': 'Americano',
      'harga': 12000,
      'kategori': 'Kopi',
      'stok': 50,
      'foto':
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200'
    },
    {
      'id': 3,
      'nama': 'Cappuccino',
      'harga': 18000,
      'kategori': 'Kopi',
      'stok': 50,
      'foto':
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=200'
    },
    {
      'id': 4,
      'nama': 'Latte',
      'harga': 20000,
      'kategori': 'Kopi',
      'stok': 50,
      'foto':
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200'
    },
    {
      'id': 5,
      'nama': 'Mocha',
      'harga': 22000,
      'kategori': 'Kopi',
      'stok': 50,
      'foto':
          'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?w=200'
    },
    {
      'id': 6,
      'nama': 'Es Teh Manis',
      'harga': 8000,
      'kategori': 'Non-Kopi',
      'stok': 50,
      'foto': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=200'
    },
    {
      'id': 7,
      'nama': 'Es Jeruk',
      'harga': 10000,
      'kategori': 'Non-Kopi',
      'stok': 50,
      'foto':
          'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=200'
    },
    {
      'id': 8,
      'nama': 'Air Mineral',
      'harga': 5000,
      'kategori': 'Non-Kopi',
      'stok': 50,
      'foto': 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=200'
    },
  ].obs;
  // ==========================================
  // KERANJANG BELANJA
  // ==========================================
  final cart = <Map<String, dynamic>>[].obs;
  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;

  // ==========================================
  // SIKLUS HIDUP CONTROLLER
  // ==========================================
  @override
  void onInit() {
    super.onInit();
    _loadUserData(); // Load data user dari Supabase saat controller di-init
  }

  // ==========================================
  // LOAD DATA USER DARI SUPABASE
  // ==========================================
  void _loadUserData() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      final user = session.user;
      userName.value = user.userMetadata?['full_name'] ??
          user.userMetadata?['nama_lengkap'] ??
          'User';
      _updateGreeting();
    }
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 11)
      greeting.value = 'Selamat Pagi';
    else if (hour >= 11 && hour < 15)
      greeting.value = 'Selamat Siang';
    else if (hour >= 15 && hour < 18)
      greeting.value = 'Selamat Sore';
    else
      greeting.value = 'Selamat Malam';
  }

  // ==========================================
  // FORMAT RUPIAH
  // ==========================================
  String formatRupiah(int angka) {
    return 'Rp ${angka.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // ==========================================
  // FUNGSI KERANJANG
  // ==========================================
  void addToCart(Map<String, dynamic> menu) {
    final existingIndex = cart.indexWhere((item) => item['id'] == menu['id']);

    if (existingIndex != -1) {
      cart[existingIndex]['quantity'] =
          (cart[existingIndex]['quantity'] as int) + 1;
    } else {
      cart.add({
        'id': menu['id'],
        'nama': menu['nama'],
        'harga': menu['harga'],
        'quantity': 1,
      });
    }

    AppDialogs.showCustomSnackbar(
      title: 'Ditambahkan',
      message: '${menu['nama']} ditambahkan ke keranjang',
      type: SnackbarType.success,
    );
  }

  void decreaseQuantity(int index) {
    if ((cart[index]['quantity'] as int) > 1) {
      cart[index]['quantity'] = (cart[index]['quantity'] as int) - 1;
    } else {
      cart.removeAt(index);
    }
  }

  void increaseQuantity(int index) {
    cart[index]['quantity'] = (cart[index]['quantity'] as int) + 1;
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
  }

  int get totalHarga {
    return cart.fold<int>(
        0,
        (sum, item) =>
            sum + ((item['harga'] as int) * (item['quantity'] as int)));
  }

  int get totalItem {
    return cart.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
  }

  List<Map<String, dynamic>> get filteredMenu {
    return menuList.where((menu) {
      final matchCategory = selectedCategory.value == 'Semua' ||
          menu['kategori'] == selectedCategory.value;
      final matchSearch = menu['nama']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  void checkout() {
    if (cart.isEmpty) {
      AppDialogs.showCustomSnackbar(
        title: 'Keranjang Kosong',
        message: 'Tambahkan menu terlebih dahulu sebelum checkout.',
        type: SnackbarType.warning,
      );
      return;
    }

    AppDialogs.showConfirmDialog(
      title: 'Konfirmasi Pembayaran',
      message:
          'Total pembayaran: ${formatRupiah(totalHarga)}\n\nLanjutkan proses pembayaran?',
      confirmText: 'Bayar',
      cancelText: 'Batal',
      onConfirm: () {
        AppDialogs.showCustomSnackbar(
          title: 'Pembayaran Berhasil',
          message:
              'Transaksi senilai ${formatRupiah(totalHarga)} berhasil diproses.',
          type: SnackbarType.success,
        );
        cart.clear();
      },
    );
  }

  void clearCart() {
    if (cart.isEmpty) return;

    AppDialogs.showConfirmDialog(
      title: 'Kosongkan Keranjang',
      message: 'Yakin ingin menghapus semua item dari keranjang?',
      confirmText: 'Ya, Hapus',
      cancelText: 'Batal',
      onConfirm: () {
        cart.clear();
        AppDialogs.showCustomSnackbar(
          title: 'Keranjang Dikosongkan',
          message: 'Semua item telah dihapus.',
          type: SnackbarType.info,
        );
      },
    );
  }
}
