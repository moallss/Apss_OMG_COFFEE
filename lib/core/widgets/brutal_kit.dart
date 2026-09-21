// PATH FILE: lib/core/widgets/brutal_kit.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

import 'package:flutter/services.dart';

// ✅ BARU: expose helper theme ke semua yang import brutal_kit
export '../theme/app_theme.dart' show appBorder, AppShadows;

/// ====================================================
/// BRUTAL KIT: widget reusable style neo-brutalism
/// Dipakai semua halaman yang sudah migrasi (Opsi B)
/// ====================================================

/// ICON dengan OUTLINE TEBAL khas brutalism
/// (layer stroke hitam di belakang + fill pink di depan)
class BrutalIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final Color outlineColor;
  final double outlineWidth;

  const BrutalIcon({
    super.key,
    required this.icon,
    this.size = 22,
    this.color = AppColors.primary,
    this.outlineColor = AppColors.ink,
    this.outlineWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Layer outline (stroke tebal)
        Text(
          String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            fontSize: size,
            height: 1.0,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        // Layer isi (pink)
        Icon(icon, color: color, size: size),
      ],
    );
  }
}

/// CARD: putih + border hitam + shadow keras
class BrutalCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double shadow;

  const BrutalCard({
    super.key,
    required this.child,
    this.radius = AppRadius.card,
    this.padding = const EdgeInsets.all(22),
    this.shadow = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(radius),
        border: appBorder(),
        boxShadow: AppShadows.hard(shadow),
      ),
      child: child,
    );
  }
}

/// INPUT: label uppercase + kotak icon pink + border hitam
class BrutalInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters; // ✅ properti baru

  const BrutalInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.inputFormatters, // ✅ di constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.labelUpper),
          const SizedBox(height: 7),
        ],
        Container(
          height: 58, // ✅ FIXED: email & password pasti sama tinggi
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.circular(AppRadius.input),
            border: appBorder(),
            boxShadow: AppShadows.hard(3),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              // ✅ Icon pink + outline tebal, TANPA container
              BrutalIcon(icon: icon, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters, // ✅ BARU
                  textInputAction: textInputAction,
                  onSubmitted: onSubmitted,
                  style: AppTextStyles.body.copyWith(fontSize: 13.5),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isCollapsed: true,
                    hintText: hint,
                    hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 12.5),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (suffix != null) suffix!,
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }
}

/// BUTTON: pink + border hitam + shadow keras
class BrutalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final double height;

  const BrutalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: height,
        decoration: BoxDecoration(
          color: AppColors.button,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: appBorder(),
          boxShadow: AppShadows.hard(enabled ? 4 : 1),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text, style: AppTextStyles.buttonBrutal),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, color: Colors.white, size: 18),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// DEKORASI: garis kuning bergelombang
class BrutalSquiggle extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const BrutalSquiggle({
    super.key,
    this.width = 130,
    this.height = 12,
    this.color = AppColors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _SquigglePainter(color)),
    );
  }
}

class _SquigglePainter extends CustomPainter {
  final Color color;
  _SquigglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    const waves = 5;
    final w = size.width / waves;
    path.moveTo(0, size.height / 2);
    for (var i = 0; i < waves; i++) {
      path.quadraticBezierTo(w * i + w / 4, 0, w * i + w / 2, size.height / 2);
      path.quadraticBezierTo(
          w * i + (w * 3 / 4), size.height, w * (i + 1), size.height / 2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// DEKORASI: grid titik
class BrutalDots extends StatelessWidget {
  final int cols;
  final int rows;
  final Color color;

  const BrutalDots({
    super.key,
    this.cols = 5,
    this.rows = 3,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cols * 10.0,
      height: rows * 10.0,
      child: CustomPaint(painter: _DotsPainter(cols, rows, color)),
    );
  }
}

class _DotsPainter extends CustomPainter {
  final int cols;
  final int rows;
  final Color color;
  _DotsPainter(this.cols, this.rows, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        canvas.drawCircle(Offset(c * 10.0 + 3, r * 10.0 + 3), 2.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// DEKORASI: bintang PUTIH dengan outline HITAM tebal
class BrutalStar extends StatelessWidget {
  final double size;
  const BrutalStar({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return BrutalIcon(
      icon: Icons.star_rounded,
      size: size,
      color: Colors.white, // ✅ isi putih
      outlineColor: AppColors.ink, // ✅ outline hitam
      outlineWidth: 4,
    );
  }
}

/// LOGO BADGE: pill putih + border hitam + shadow
/// LOGO BADGE: logo usaha + teks horizontal ke kanan
/// LOGO BADGE: logo usaha + teks horizontal ke kanan
/// compact = true → ukuran kecil (untuk halaman dengan header padat)
class BrutalLogoBadge extends StatelessWidget {
  final bool compact;

  /// ✅ Jika punya file logo: isi misal 'assets/logo.png'
  /// (daftarkan dulu di pubspec.yaml). null = pakai icon kopi.
  static const String? logoAsset = null;

  const BrutalLogoBadge({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16, vertical: compact ? 6 : 10),
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: appBorder(),
        boxShadow: AppShadows.hard(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoAsset != null
              ? Image.asset(
                  logoAsset!,
                  width: compact ? 18 : 26,
                  height: compact ? 18 : 26,
                  errorBuilder: (_, __, ___) => BrutalIcon(
                    icon: Icons.local_cafe_rounded,
                    color: AppColors.brandGreen,
                    size: compact ? 16 : 22,
                  ),
                )
              : BrutalIcon(
                  icon: Icons.local_cafe_rounded,
                  color: AppColors.brandGreen,
                  size: compact ? 16 : 22,
                ),
          SizedBox(width: compact ? 8 : 10),
          Text('OMG COFFEE',
              style: GoogleFonts.outfit(
                  color: AppColors.brandGreen,
                  fontSize: compact ? 11 : 14,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

/// DOTS FULL BACKGROUND (untuk header pink)
/// DOTS FULL BACKGROUND (untuk header pink)
/// Jika diberi child → dots jadi latar di belakang child (ukuran ikut child)
/// Jika tanpa child → dots memenuhi seluruh area tersedia
class BrutalDotBackground extends StatelessWidget {
  final Color color;
  final double spacing;
  final double radius;
  final Widget? child;

  const BrutalDotBackground({
    super.key,
    this.color = Colors.white,
    this.spacing = 18,
    this.radius = 1.8,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final painter = _DotGridBgPainter(color, spacing, radius);
    if (child == null) {
      return IgnorePointer(
        child: SizedBox.expand(child: CustomPaint(painter: painter)),
      );
    }
    return CustomPaint(painter: painter, child: child);
  }
}

class _DotGridBgPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double radius;
  _DotGridBgPainter(this.color, this.spacing, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// DIVIDER PUTUS-PUTUS (dashed line)
class BrutalDashedLine extends StatelessWidget {
  final Color color;
  const BrutalDashedLine({super.key, this.color = AppColors.muted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 2,
      child: CustomPaint(painter: _DashedHLinePainter(color.withOpacity(0.5))),
    );
  }
}

class _DashedHLinePainter extends CustomPainter {
  final Color color;
  _DashedHLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    double x = 0;
    while (x < size.width) {
      final end = (x + 6) > size.width ? size.width : (x + 6);
      canvas.drawLine(
          Offset(x, size.height / 2), Offset(end, size.height / 2), paint);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
