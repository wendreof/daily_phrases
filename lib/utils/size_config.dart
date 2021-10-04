import 'package:flutter/material.dart';

class SizeConfig {
  final MediaQueryData mediaQueryData;
  SizeConfig({required this.mediaQueryData});

  static Future<SizeConfig> of(BuildContext context) async =>
      SizeConfig(mediaQueryData: MediaQuery.of(context));

  double dynamicScaleSize(
      {required double size,
      double? scaleFactorTablet,
      double? scaleFactorMini}) {
    if (isTablet()) {
      final scaleFactor = scaleFactorTablet ?? 2;
      return size * scaleFactor;
    }
    if (isMini()) {
      final scaleFactor = scaleFactorMini ?? 0.8;
      return size * scaleFactor;
    }
    return size;
  }

  // ignore: lines_longer_than_80_chars
  /// Defines device type based on logical device pixels. Bigger than 600 means it is a tablet
  bool isTablet() {
    final shortestSide = mediaQueryData.size.shortestSide;
    return shortestSide > 600;
  }

  // ignore: lines_longer_than_80_chars
  /// Defines device type based on logical device pixels. Less or equal than 320 means it is a mini device
  bool isMini() {
    final shortestSide = mediaQueryData.size.shortestSide;
    return shortestSide <= 320;
  }
}
