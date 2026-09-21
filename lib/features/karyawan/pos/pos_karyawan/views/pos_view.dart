// PATH FILE: lib/features/pos/views/pos_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart'; // <-- IMPORT TAMBAHAN UNTUK SKELETON

import '../../draft_karyawan/views/draft_karyawan_view.dart';
import '../../draft_karyawan/controllers/draft_karyawan_controller.dart';

import '../controllers/pos_controller.dart';

import '../../ringkasan_pesanan/views/ringkasan_pesanan_view.dart';
import '../../ringkasan_pesanan/controllers/ringkasan_pesanan_controller.dart';

class POSView extends GetView<POSController> {
  const POSView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Stack(
        children: [
          // ============================================
          // LAYER 1: CONTAINER PINK
          // ============================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 190,
              decoration: const BoxDecoration(
                color: Color(0xFFEF2B7C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          final name = controller.userName.value;
                          final initialLetter =
                              name.isNotEmpty ? name[0].toUpperCase() : 'U';
                          return Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initialLetter,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    controller.greeting.value,
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Obx(() => Text(
                                    controller.userName.value,
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),

                        // BUTTON DRAFT DENGAN BADGE JUMLAH
                        Obx(() {
                          final draftCount = controller.draftCount.value;
                          return GestureDetector(
                            onTap: () {
                              // Inisialisasi controller manual
                              Get.put(DraftKaryawanController());

                              // Buka route transparan menggunakan Navigator native
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque:
                                      false, // WAJIB: Agar halaman POS tetap terlihat
                                  barrierColor: Colors.black.withOpacity(0.4),
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return const DraftKaryawanView();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.bookmark_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                // BADGE JUMLAH DRAFT
                                if (draftCount > 0)
                                  Positioned(
                                    right: -6,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF3E9B),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: Text(
                                        '$draftCount',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            controller.searchQuery.value = value,
                        decoration: InputDecoration(
                          hintText: 'Cari Menu...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ============================================
          // LAYER 2: CONTAINER CREAM
          // ============================================
          Positioned(
            top: 190,
            left: 0,
            right: 0,
            bottom: 50,
            child: Container(
              color: const Color(0xFFFAF9F6),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: _buildCategoryChip('Semua')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCategoryChip('Kopi')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCategoryChip('Non-Kopi')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Obx(() => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.72,
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
          // LAYER 3: CART SUMMARY BAR
          // ============================================
          Positioned(
            left: 20,
            right: 20,
            bottom: 85,
            child: Obx(() {
              if (controller.totalItem == 0) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(controller.formatRupiah(controller.totalHarga),
                              style: GoogleFonts.outfit(
                                  color: const Color(0xFF3A6F43), // ← UBAH INI
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFB800)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text('${controller.totalItem} Item',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFFFFB800),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFF3E9B).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.bookmark_rounded,
                          color: Color(0xFFFF3E9B), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            // Inisialisasi controller jika belum ada
                            if (!Get.isRegistered<
                                RingkasanPesananController>()) {
                              Get.put(RingkasanPesananController());
                            }

                            // Buka bottom sheet dengan efek blur (POS tetap terlihat)
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                transitionDuration:
                                    const Duration(milliseconds: 350),
                                pageBuilder: (_, __, ___) =>
                                    const RingkasanPesananView(),
                                transitionsBuilder: (_, animation, __, child) {
                                  // Saat MENUTUP (reverse): pudar halus
                                  if (animation.status ==
                                      AnimationStatus.reverse) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  }
                                  // Saat MEMBUKA: slide dari bawah
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
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF3E9B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: Color(0xFFD6336C), width: 2)),
                          ),
                          child: const Text('BAYAR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
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

  Widget _buildCategoryChip(String category) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == category;
      return GestureDetector(
        onTap: () => controller.selectedCategory.value = category,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF3E9B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD6336C), width: 1.5),
          ),
          child: Text(category,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : const Color(0xFFD6336C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
      );
    });
  }

  Widget _buildMenuCard(Map<String, dynamic> menu) {
    return Obx(() {
      final cartItems =
          controller.cart.where((item) => item['id'] == menu['id']).toList();
      final cartItem = cartItems.isNotEmpty ? cartItems.first : null;
      final quantity = cartItem != null ? cartItem['quantity'] as int : 0;

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD6336C), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // REVISI 2: SKELETON LOADER UNTUK GAMBAR
            AspectRatio(
              aspectRatio: 1.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: menu['foto'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Menggunakan Shimmer sebagai placeholder
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFFF3E9B).withValues(alpha: 0.1),
                    child: Icon(
                        menu['kategori'] == 'Kopi'
                            ? Icons.coffee_rounded
                            : Icons.local_cafe_rounded,
                        color: const Color(0xFFFF3E9B),
                        size: 36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(menu['nama'],
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(menu['kategori'],
                style:
                    GoogleFonts.inter(color: Colors.grey[500], fontSize: 10)),
            const SizedBox(height: 2),
            Text(controller.formatRupiah(menu['harga']),
                style: GoogleFonts.inter(
                    color: const Color(0xFF3A6F43), // ← WARNA HIJAU TUA
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Container Kapsul Membungkus Button -/+ dan Angka
            // DESIGN KREATIF: Segmented Control Style (FIXED)
            // SOLUSI ANTI-OVERFLOW: Gunakan Expanded (menyesuaikan sisa ruang)
            // SOLUSI: Bedakan warna button -/+ dan perbaiki garis vertikal
            // SOLUSI: Button -/+ konsisten, tanpa borderRadius individual
            // SOLUSI: ClipRRect untuk memotong button yang menonjol keluar
            // SOLUSI: Padding dalam container agar border tidak tertutup button
            // SOLUSI FINAL: Tanpa ClipRRect, button punya borderRadius sendiri
            Expanded(
              child: quantity == 0
                  ? ElevatedButton(
                      onPressed: () {
                        controller.addToCart(menu);
                        controller.cart.refresh();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3E9B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded,
                              size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Tambah',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F0),
                        border: Border.all(
                            color: const Color(0xFFD6336C), width: 1.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          // Button Minus - Pink Solid dengan borderRadius KIRI saja
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.decreaseQuantity(controller.cart
                                    .indexWhere(
                                        (item) => item['id'] == menu['id']));
                                controller.cart.refresh();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF3E9B),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Divider Vertikal
                          Container(
                            width: 1.5,
                            color: const Color(0xFFD6336C),
                          ),
                          // Number - Cream Background, Pink Text
                          Expanded(
                            child: Container(
                              color: const Color(0xFFFFF8F0),
                              child: Center(
                                child: Text(
                                  '$quantity',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFD6336C),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Divider Vertikal
                          Container(
                            width: 1.5,
                            color: const Color(0xFFD6336C),
                          ),
                          // Button Plus - Pink Solid dengan borderRadius KANAN saja
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.increaseQuantity(controller.cart
                                    .indexWhere(
                                        (item) => item['id'] == menu['id']));
                                controller.cart.refresh();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF3E9B),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSoldOutCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.4,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.coffee_rounded,
                      color: Colors.grey, size: 36),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('HABIS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Matcha Latte',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('Non-Kopi',
              style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10)),
          const SizedBox(height: 2),
          Text('Rp 18.000',
              style: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Habis',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
