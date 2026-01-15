import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Professional animated logo loader
/// Shows logo with shimmer effect like pros do
class AnimatedLogoLoader extends StatelessWidget {
  final double size;
  final String? logoPath;
  final Duration period;

  const AnimatedLogoLoader({
    super.key,
    this.size = 120,
    this.logoPath = 'assets/images/logo.png',
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!;
    final highlight = theme.brightness == Brightness.dark ? Colors.grey[500]! : Colors.white;

    return Image.asset(
      logoPath ?? 'assets/images/logo.png',
      width: size.w,
      height: size.w * 1.8,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback icon
        return Icon(Icons.loyalty_rounded, size: size.sp, color: Colors.white);
      },
    );
  }
}

/// Full-screen logo loader with gradient background
class FullScreenLogoLoader extends StatelessWidget {
  final double logoSize;
  final String? logoPath;

  const FullScreenLogoLoader({super.key, this.logoSize = 120, this.logoPath});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
        ),
        child: Center(
          child: AnimatedLogoLoader(size: logoSize, logoPath: logoPath),
        ),
      ),
    );
  }
}

/// Inline loader (transparent background, smaller)
class InlineLogoLoader extends StatelessWidget {
  final double size;
  final String? logoPath;

  const InlineLogoLoader({super.key, this.size = 40, this.logoPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedLogoLoader(size: size, logoPath: logoPath),
    );
  }
}
