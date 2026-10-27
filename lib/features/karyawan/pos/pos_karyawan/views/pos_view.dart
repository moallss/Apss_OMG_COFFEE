// PATH FILE: lib/features/karyawan/pos/pos_karyawan/views/pos_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/widgets/brutal_kit.dart';
import '../../draft_karyawan/views/draft_karyawan_view.dart';
import '../../draft_karyawan/controllers/draft_karyawan_controller.dart';

import '../controllers/pos_controller.dart';

import '../../ringkasan_pesanan/views/ringkasan_pesanan_view.dart';
import '../../ringkasan_pesanan/controllers/ringkasan_pesanan_controller.dart';

class POSView extends GetView<POSController> {
  const POSView({super.key});

  // ===== PALETTE BRUTALISME =====
  static const Color _ink = Color(0xFF1A1A1A);
  static const Color _pink = Color(0xFFEF2B7C);
  static const Color _yellow = Color(0xFFFFC94D);
  static const Color _green = Color(0xFF2D7A4F);
  static const Color _cream = Color(0xFFFAF9F6);
  static const Color _white = Color(0xFFFFFDF8);
  static const Color _red = Color(0xFFD32F2F);

  Border _bdr([double w = 2]) => Border.all(color: _ink, width: w);
  List<BoxShadow> _hard([double o = 3]) =>
      [BoxShadow(color: _ink, offset: Offset(o, o), blurRadius: 0)];

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final headerH = topPad + 112;
    return Scaffold(
      backgroundColor: _cream,
      body: Stack(
        children: [
          // ============================================
          // LAYER 1: HEADER PINK + DOTS
          // ============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: Container(
              color: _pink,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Judul diperkecil agar header compact
                    Text('POS KASIR',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(color: Colors.black, offset: Offset(2, 2))
                            ])),
                    const SizedBox(height: 8),

                    // ✅ CARD ROMBONG + BUTTON DRAFT SEJAJAR (terpisah)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height:
                                46, // ✅ TINGGI DIKUNCI sama dengan card draft
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: _white,
                              borderRadius: BorderRadius.circular(12),
                              border: _bdr(1.5),
                              boxShadow: _hard(2),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3D6),
                                    borderRadius: BorderRadius.circular(8),
                                    border: _bdr(1.5),
                                  ),
                                  child: const Icon(
                                      Icons.local_shipping_rounded,
                                      color: _ink,
                                      size: 14),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Obx(() => Text(
                                      'Rombong 01 • ${controller.userName.value}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          color: _ink,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800))),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3EEE5),
                                    borderRadius: BorderRadius.circular(50),
                                    border: _bdr(1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 4,
                                          height: 4,
                                          decoration: const BoxDecoration(
                                              color: _green,
                                              shape: BoxShape.circle)),
                                      const SizedBox(width: 4),
                                      Text('ONLINE',
                                          style: GoogleFonts.inter(
                                              color: _green,
                                              fontSize: 6.5,
                                              fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Obx(() {
                          final draftCount = controller.draftCount.value;
                          return GestureDetector(
                            onTap: () => _openDraft(context),
                            child: Container(
                              height:
                                  46, // ✅ TINGGI DIKUNCI sama dengan card rombong
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: _yellow,
                                borderRadius: BorderRadius.circular(12),
                                border: _bdr(1.5),
                                boxShadow: _hard(2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bookmark_rounded,
                                      color: _ink, size: 14),
                                  const SizedBox(width: 6),
                                  Text('$draftCount Draft',
                                      style: GoogleFonts.inter(
                                          color: _ink,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ============================================
          // LAYER 2: KONTEN KATALOG
          // ============================================
          Positioned(
            top: headerH,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: _cream,
              child: Column(
                children: [
                  const SizedBox(height: 14),

                  // ✅ SEARCH BAR pindah ke konten (header jadi pendek)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            controller.searchQuery.value = value,
                        decoration: InputDecoration(
                          hintText: 'Cari kopi, snack, dll...',
                          hintStyle: GoogleFonts.inter(
                              color: Colors.grey[500], fontSize: 11),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: _ink, size: 18),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Chips kategori (horizontal scroll)
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildCategoryChip('Semua', Icons.grid_view_rounded),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Kopi', Icons.coffee_rounded),
                        const SizedBox(width: 8),
                        _buildCategoryChip(
                            'Non-Kopi', Icons.local_drink_rounded),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Snack', Icons.icecream_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Section header katalog
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      children: [
                        Obx(() => Text(
                            'KATALOG PRODUK (${controller.filteredMenu.length} MENU)',
                            style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8))),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3EEE5),
                            borderRadius: BorderRadius.circular(6),
                            border: _bdr(1),
                          ),
                          child: Text('Stok Real-Time',
                              style: GoogleFonts.inter(
                                  color: _green,
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),

                  // Grid produk
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 170),
                      child: Obx(() => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: controller.filteredMenu.length + 1,
                            itemBuilder: (context, index) {
                              if (index == controller.filteredMenu.length) {
                                return _buildSoldOutCard();
                              }
                              return _buildMenuCard(
                                  controller.filteredMenu[index]);
                            },
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================
          // LAYER 3: CART SUMMARY BAR (PINK BRUTALISME)
          // ============================================
          Positioned(
            left: 20,
            right: 20,
            // overlay: 60 = puncak navbar (~40) + celah 20px yang kamu minta
            bottom: 50,
            child: Obx(() {
              if (controller.totalItem == 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(16),
                  border: _bdr(),
                  boxShadow: _hard(4),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _white,
                        borderRadius: BorderRadius.circular(10),
                        border: _bdr(1.5),
                      ),
                      child: const Icon(Icons.shopping_bag_rounded,
                          color: _pink, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${controller.totalItem} Item • ${controller.formatRupiah(controller.totalHarga)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('Antrean Aktif #A-017',
                              style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _openRingkasan(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _white,
                          borderRadius: BorderRadius.circular(10),
                          border: _bdr(1.5),
                          boxShadow: _hard(2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('PESANAN',
                                style: GoogleFonts.inter(
                                    color: _ink,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded,
                                color: _ink, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // NAVIGASI DRAFT (logika tetap sama)
  // ==========================================
  void _openDraft(BuildContext context) {
    Get.put(DraftKaryawanController());
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.4),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DraftKaryawanView();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  // ==========================================
  // NAVIGASI RINGKASAN (logika tetap sama)
  // ==========================================
  void _openRingkasan(BuildContext context) {
    if (!Get.isRegistered<RingkasanPesananController>()) {
      Get.put(RingkasanPesananController());
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const RingkasanPesananView(),
        transitionsBuilder: (_, animation, __, child) {
          if (animation.status == AnimationStatus.reverse) {
            return FadeTransition(opacity: animation, child: child);
          }
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  // ==========================================
  // CHIP KATEGORI
  // ==========================================
  Widget _buildCategoryChip(String category, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == category;
      return BrutalTap(
        shadowOffset: isSelected ? 2 : 0,
        child: GestureDetector(
          onTap: () => controller.selectedCategory.value = category,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? _pink : _white,
              borderRadius: BorderRadius.circular(50),
              border: _bdr(1.5),
              boxShadow: isSelected ? _hard(2) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: isSelected ? Colors.white : _ink, size: 12),
                const SizedBox(width: 6),
                Text(category,
                    style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : _ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ==========================================
  // CARD PRODUK
  // ==========================================
  Widget _buildMenuCard(Map<String, dynamic> menu) {
    return Obx(() {
      final cartItems =
          controller.cart.where((item) => item['id'] == menu['id']).toList();
      final quantity =
          cartItems.isNotEmpty ? cartItems.first['quantity'] as int : 0;
      final int stok = menu['stok'] as int? ?? 24;

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(14),
          border: _bdr(),
          boxShadow: _hard(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto + badge Dipilih
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F4EF),
                      borderRadius: BorderRadius.circular(10),
                      border: _bdr(1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: menu['foto'] ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Icon(
                            menu['kategori'] == 'Kopi'
                                ? Icons.coffee_rounded
                                : Icons.local_cafe_rounded,
                            color: _pink,
                            size: 36),
                      ),
                    ),
                  ),
                  if (quantity > 0)
                    Positioned(
                      top: -7,
                      right: -7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _pink,
                          borderRadius: BorderRadius.circular(8),
                          border: _bdr(1.5),
                          boxShadow: _hard(1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_rounded,
                                color: Colors.white, size: 10),
                            const SizedBox(width: 4),
                            Text('Dipilih',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Kategori + Stok
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3D6),
                    borderRadius: BorderRadius.circular(6),
                    border: _bdr(1),
                  ),
                  child: Text('${menu['kategori']}'.toUpperCase(),
                      style: GoogleFonts.inter(
                          color: _ink,
                          fontSize: 7,
                          fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                Text('Stok $stok',
                    style: GoogleFonts.inter(
                        color: _green,
                        fontSize: 8,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 4),

            // Nama produk
            Text(menu['nama'],
                style: GoogleFonts.inter(
                    color: _ink, fontSize: 12, fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),

            // Price pill kuning
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _yellow,
                borderRadius: BorderRadius.circular(8),
                border: _bdr(1.5),
              ),
              child: Text(controller.formatRupiah(menu['harga']),
                  style: GoogleFonts.inter(
                      color: _ink, fontSize: 10, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 12),

            // Jumlah / Tambah
            quantity == 0
                ? SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addToCart(menu);
                        controller.cart.refresh();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: _ink, width: 2)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_rounded,
                              size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('Tambah',
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Text('Jumlah',
                          style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 8,
                              fontWeight: FontWeight.w700)),
                      const Spacer(),
                      // ✅ MINUS diperbesar 34px + hit area opaque
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          controller.decreaseQuantity(controller.cart
                              .indexWhere((item) => item['id'] == menu['id']));
                          controller.cart.refresh();
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _white,
                            shape: BoxShape.circle,
                            border: _bdr(1.5),
                            boxShadow: _hard(1),
                          ),
                          child: const Icon(Icons.remove_rounded,
                              color: _ink, size: 18),
                        ),
                      ),
                      // ✅ Jarak antar button diperlebar agar tidak salah tekan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('$quantity',
                            style: GoogleFonts.inter(
                                color: _ink,
                                fontSize: 14,
                                fontWeight: FontWeight.w900)),
                      ),
                      // ✅ PLUS diperbesar 34px + hit area opaque
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          controller.increaseQuantity(controller.cart
                              .indexWhere((item) => item['id'] == menu['id']));
                          controller.cart.refresh();
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _pink,
                            shape: BoxShape.circle,
                            border: _bdr(1.5),
                            boxShadow: _hard(1),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // CARD SOLD OUT
  // ==========================================
  Widget _buildSoldOutCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFECE6),
        borderRadius: BorderRadius.circular(14),
        border: _bdr(),
        boxShadow: _hard(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F4EF),
                    borderRadius: BorderRadius.circular(10),
                    border: _bdr(1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[300]!,
                      alignment: Alignment.center,
                      child: const Icon(Icons.local_cafe_rounded,
                          color: Colors.grey, size: 36),
                    ),
                  ),
                ),
                Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _red,
                      borderRadius: BorderRadius.circular(8),
                      border: _bdr(1.5),
                    ),
                    child: Text('HABIS',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[300]!,
                  borderRadius: BorderRadius.circular(6),
                  border: _bdr(1),
                ),
                child: Text('NON-KOPI',
                    style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 7,
                        fontWeight: FontWeight.w800)),
              ),
              const Spacer(),
              Text('Kosong 0',
                  style: GoogleFonts.inter(
                      color: _red, fontSize: 8, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Matcha Latte',
              style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w900),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300]!,
              borderRadius: BorderRadius.circular(8),
              border: _bdr(1.5),
            ),
            child: Text('Rp 18.000',
                style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: _ink, width: 1.5)),
                padding: EdgeInsets.zero,
              ),
              child: Text('Habis',
                  style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
