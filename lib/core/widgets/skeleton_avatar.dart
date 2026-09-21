// PATH FILE: lib/core/widgets/skeleton_avatar.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonAvatar extends StatelessWidget {
  final double size;
  final bool isCircle;

  const SkeletonAvatar({
    super.key,
    this.size = 44,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
        ),
      ),
    );
  }
}
