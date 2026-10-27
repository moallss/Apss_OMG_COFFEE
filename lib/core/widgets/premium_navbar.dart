// PATH FILE: lib/core/widgets/premium_navbar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'brutal_kit.dart';

class PremiumNavItem {
  final IconData icon;
  final String label;

  const PremiumNavItem({required this.icon, required this.label});
}

class PremiumNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<PremiumNavItem> items;

  /// Index item terkunci (mis. POS sebelum check-in). Opsional —
  /// owner tidak mengirim apa pun, jadi perilakunya tidak berubah.
  final Set<int> lockedIndices;

  /// Tinggi pill & jarak bawahnya — dipakai view lain untuk
  /// menghitung GARIS TENGAH navbar (batas clip konten).
  static const double barHeight = 68;
  static const double bottomGap = 12;

  const PremiumNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.lockedIndices = const {},
  });

  @override
  Widget build(BuildContext context) {
    final count = items.length;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // Posisi alignment pill untuk setiap index (-1 .. 1)
    final alignments = List.generate(
      count,
      (i) => Alignment(count == 1 ? 0 : (2 * i / (count - 1)) - 1, 0),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomGap + bottomInset),
      child: Container(
        height: barHeight,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:
              AppColors.primary, // ✅ REVISI 1: card navbar PINK seperti semula
          borderRadius: BorderRadius.circular(50),
          border: appBorder(),
          boxShadow: AppShadows.hard(4),
        ),
        child: Stack(
          children: [
            // ===== SLIDING PILL PUTIH (status aktif) =====
            AnimatedAlign(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutCubic,
              alignment: alignments[currentIndex],
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppColors.appWhite, // ✅ REVISI 1: aktif = PUTIH
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.ink, width: 2),
                  ),
                ),
              ),
            ),

            // ===== ITEMS =====
            Row(
              children: List.generate(count, (i) {
                final active = i == currentIndex;
                final locked = lockedIndices.contains(i);
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onTap(i);
                    },
                    child: _buildItemContent(items[i], active, locked),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ REVISI 2: icon di ATAS, teks di BAWAH (Column) — tidak overflow lagi
  Widget _buildItemContent(PremiumNavItem item, bool active, bool locked) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
      tween: Tween<double>(begin: 0, end: active ? 1 : 0),
      builder: (context, t, child) {
        // Warna: cream (di atas pink) -> pink (di atas pill putih)
        // Jika terkunci: putih redup permanen.
        final fg = locked
            ? Colors.white.withValues(alpha: 0.40)
            : Color.lerp(AppColors.appWhite, AppColors.primary, t)!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: locked ? 1 : 1 + (0.10 * t),
                  child: Icon(item.icon, color: fg, size: 18),
                ),
                if (locked)
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
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: fg,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        );
      },
    );
  }
}
