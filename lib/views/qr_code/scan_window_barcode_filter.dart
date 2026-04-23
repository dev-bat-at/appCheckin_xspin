import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

bool isBarcodeInsideScanWindow({
  required Barcode barcode,
  required Size cameraPreviewSize,
  required Size widgetSize,
  required Rect scanWindow,
  BoxFit fit = BoxFit.cover,
}) {
  if (barcode.corners.length < 4 ||
      cameraPreviewSize.isEmpty ||
      widgetSize.isEmpty) {
    return false;
  }

  final ratios = _calculateBoxFitRatio(
    fit: fit,
    cameraPreviewSize: cameraPreviewSize,
    widgetSize: widgetSize,
  );

  final horizontalPadding =
      (cameraPreviewSize.width * ratios.widthRatio - widgetSize.width) / 2;
  final verticalPadding =
      (cameraPreviewSize.height * ratios.heightRatio - widgetSize.height) / 2;

  final adjustedOffsets = barcode.corners
      .map(
        (offset) => Offset(
          offset.dx * ratios.widthRatio - horizontalPadding,
          offset.dy * ratios.heightRatio - verticalPadding,
        ),
      )
      .toList();

  final center = _polygonCenter(adjustedOffsets);
  return scanWindow.contains(center);
}

({double widthRatio, double heightRatio}) _calculateBoxFitRatio({
  required BoxFit fit,
  required Size cameraPreviewSize,
  required Size widgetSize,
}) {
  if (cameraPreviewSize.width <= 0 ||
      cameraPreviewSize.height <= 0 ||
      widgetSize.width <= 0 ||
      widgetSize.height <= 0) {
    return (widthRatio: 1.0, heightRatio: 1.0);
  }

  final widthRatio = widgetSize.width / cameraPreviewSize.width;
  final heightRatio = widgetSize.height / cameraPreviewSize.height;

  switch (fit) {
    case BoxFit.fill:
      return (widthRatio: widthRatio, heightRatio: heightRatio);
    case BoxFit.contain:
      final ratio = math.min(widthRatio, heightRatio);
      return (widthRatio: ratio, heightRatio: ratio);
    case BoxFit.cover:
      final ratio = math.max(widthRatio, heightRatio);
      return (widthRatio: ratio, heightRatio: ratio);
    case BoxFit.fitWidth:
      return (widthRatio: widthRatio, heightRatio: widthRatio);
    case BoxFit.fitHeight:
      return (widthRatio: heightRatio, heightRatio: heightRatio);
    case BoxFit.none:
      return (widthRatio: 1.0, heightRatio: 1.0);
    case BoxFit.scaleDown:
      final ratio = math.min(1, math.min(widthRatio, heightRatio)).toDouble();
      return (widthRatio: ratio, heightRatio: ratio);
  }
}

Offset _polygonCenter(List<Offset> points) {
  if (points.isEmpty) {
    return Offset.zero;
  }

  var dx = 0.0;
  var dy = 0.0;

  for (final point in points) {
    dx += point.dx;
    dy += point.dy;
  }

  return Offset(dx / points.length, dy / points.length);
}
