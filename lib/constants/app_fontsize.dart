import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppFontSize {
  static double? sizeTitle = 40;
  static double? sizeMedium = 20;
  static double? sizeSmall = 16;
  static double? sizeTable = 18;
  static double? sizeLarge = 24;
  static double? sizeSuperLarge = 32;
  static double? sizeSuperSmall = 14;
  static double? sizeSuperSmalls = 12;
  static double? sizeStatus = 13;

  static double deviceTextScale(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;

    if (shortestSide >= 1000) {
      return 1.4;
    }
    if (shortestSide >= 820) {
      return 1.32;
    }
    if (shortestSide >= 600) {
      return 1.25;
    }
    return 1.0;
  }

  static double effectiveTextScale(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final systemScale = mediaQuery.textScaler.scale(1.0);
    final clampedSystemScale = systemScale.clamp(0.9, 1.2).toDouble();
    final deviceScale = deviceTextScale(context);
    return math.max(0.9, math.min(clampedSystemScale * deviceScale, 1.6));
  }
}

class AppFontWeight {
  static const bold = FontWeight.bold;
}
