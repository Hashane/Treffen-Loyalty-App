import 'package:flutter/material.dart';

// DEPRECATED: This file provided small responsive helpers used earlier in the
// project. The app now uses `flutter_screenutil` for consistent, well-tested
// scaling across platforms (mobile, tablet, web). Keep this file for
// backwards-compatibility during migration, but prefer `flutter_screenutil`.

/// Small responsive helpers.
/// - Use `context.wp(0.5)` for 50% of screen width.
/// - Use `context.hp(0.1)` for 10% of screen height.
/// - Use `context.ssp(size)` to scale a size (based on a base width of 375).
/// - Use `context.radiu(s)` to get a scaled border radius.

extension Responsive on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  /// Width percentage: pass 0.0..1.0
  double wp(double percent) => screenSize.width * percent;

  /// Height percentage: pass 0.0..1.0
  double hp(double percent) => screenSize.height * percent;

  /// Scales a raw size (e.g. font or spacing) according to screen width.
  /// Base width is 375 (iPhone 11/12 mini-ish). Use for consistent proportion.
  double ssp(double size, {double baseWidth = 375}) => size * (screenSize.width / baseWidth);

  /// Scaled border radius
  BorderRadius radiu(double size) => BorderRadius.circular(ssp(size));

  /// EdgeInsets with scaled all
  EdgeInsets paddedAll(double size) => EdgeInsets.all(ssp(size));

  /// EdgeInsets symmetric scaled
  EdgeInsets paddedSymmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: ssp(horizontal), vertical: ssp(vertical));
}

/// Small responsive helpers (legacy - prefer `flutter_screenutil`).
/// - Use `16.w`, `16.h`, `16.r`, or `16.sp` from `flutter_screenutil` instead.
