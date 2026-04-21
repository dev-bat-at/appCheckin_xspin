import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:checkin/app/app_route_observer.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stacked/stacked.dart';

class AutoCheckinPage extends StatefulWidget {
  const AutoCheckinPage({
    super.key,
    required this.indexViewModel,
  });

  final IndexViewModel indexViewModel;

  @override
  State<AutoCheckinPage> createState() => _AutoCheckinPageState();
}

class _AutoCheckinPageState extends State<AutoCheckinPage>
    with WidgetsBindingObserver, RouteAware {
  final QRCodeViewModel _qrViewModel = QRCodeViewModel();
  ModalRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    _qrViewModel.indexViewModel = widget.indexViewModel;
    _qrViewModel.initScanner(facing: CameraFacing.front);
    WidgetsBinding.instance.addObserver(this);
    if (widget.indexViewModel.loginViewModel.userLogin == null) {
      unawaited(widget.indexViewModel.loginViewModel.loadUser());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (_route != route && route is PageRoute) {
      if (_route is PageRoute) {
        appRouteObserver.unsubscribe(this);
      }
      _route = route;
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_route is PageRoute) {
      appRouteObserver.unsubscribe(this);
    }
    _qrViewModel.unbindScannerPage();
    unawaited(_qrViewModel.disposeScanner());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_resumeScannerIfVisible());
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _qrViewModel.unbindScannerPage();
      unawaited(_qrViewModel.stopScannerSafely());
    }
  }

  @override
  void didPushNext() {
    _qrViewModel.unbindScannerPage();
    unawaited(_qrViewModel.stopScannerSafely());
  }

  @override
  void didPopNext() {
    unawaited(_resumeScannerIfVisible());
  }

  Future<void> _resumeScannerIfVisible() async {
    if (!mounted) {
      return;
    }

    final isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrentRoute) {
      return;
    }

    _qrViewModel.bindScannerPage(context);
    await _qrViewModel.startScannerSafely();
  }

  Future<void> _closeScanner() async {
    _qrViewModel.unbindScannerPage();
    await _qrViewModel.stopScannerSafely();
    if (mounted) {
      Navigator.maybePop(context);
    }
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_qrViewModel.isScanQr) {
      return;
    }

    final barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final rawValue = barcode.rawValue?.trim();
      if (rawValue == null || rawValue.isEmpty) {
        continue;
      }

      _qrViewModel.isScanQr = true;
      _qrViewModel.currentQRCode = rawValue;
      try {
        await _qrViewModel.getUsers(flowMode: QRCodeFlowMode.automatic);
      } finally {
        _qrViewModel.isScanQr = false;
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QRCodeViewModel>.reactive(
      viewModelBuilder: () => _qrViewModel,
      onViewModelReady: (viewModel) {
        viewModel.bindScannerPage(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_resumeScannerIfVisible());
        });
      },
      builder: (context, viewModel, child) {
        viewModel.bindScannerPage(context);

        return Scaffold(
          backgroundColor: Colors.black,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final scanSize = math.min(
                constraints.maxWidth * 0.76,
                320.0,
              );
              final scanWindow = Rect.fromCenter(
                center: Offset(
                  constraints.maxWidth / 2,
                  constraints.maxHeight / 2,
                ),
                width: scanSize,
                height: scanSize,
              );

              return Stack(
                fit: StackFit.expand,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: MobileScanner(
                      controller: viewModel.scannerController!,
                      fit: BoxFit.cover,
                      onDetect: _handleDetection,
                    ),
                  ),
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _ScannerOverlayPainter(scanWindow),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Positioned.fromRect(
                    rect: scanWindow,
                    child: _ScanGuideFrame(
                      size: scanSize,
                      accentColor: viewModel.isBusy
                          ? AppColor.oriColor
                          : AppColor.primaryColor,
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, right: 16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: _closeScanner,
                            child: Ink(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.42),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.14),
                                ),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 50,
                    child: Center(
                      child: ViewModelBuilder<LoginViewModel>.reactive(
                        disposeViewModel: false,
                        viewModelBuilder: () =>
                            widget.indexViewModel.loginViewModel,
                        builder: (context, loginViewModel, child) {
                          return _AutoCheckinFooter(
                            imageQr: loginViewModel.userLogin?.imageQr,
                          );
                        },
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: scanWindow.bottom + 20,
                  //   left: 24,
                  //   right: 24,
                  //   child: Center(
                  //     child: Container(
                  //       constraints: const BoxConstraints(maxWidth: 280),
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 16,
                  //         vertical: 12,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: Colors.black.withValues(alpha: 0.42),
                  //         borderRadius: BorderRadius.circular(18),
                  //         border: Border.all(
                  //           color: Colors.white.withValues(alpha: 0.1),
                  //         ),
                  //       ),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(
                  //             viewModel.isBusy
                  //                 ? 'Dang xu ly ma QR...'
                  //                 : 'Dua ma QR vao giua khung de quet',
                  //             textAlign: TextAlign.center,
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w700,
                  //               fontSize: 15,
                  //             ),
                  //           ),
                  //           if (currentLine.isNotEmpty) ...[
                  //             const SizedBox(height: 8),
                  //             Text(
                  //               'Line hien tai: $currentLine',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                 color: Colors.white.withValues(alpha: 0.82),
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ],
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ScanGuideFrame extends StatelessWidget {
  const _ScanGuideFrame({
    required this.size,
    required this.accentColor,
  });

  final double size;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Stack(
          children: [
            _FrameCorner(
              alignment: Alignment.topLeft,
              accentColor: accentColor,
            ),
            _FrameCorner(
              alignment: Alignment.topRight,
              accentColor: accentColor,
            ),
            _FrameCorner(
              alignment: Alignment.bottomLeft,
              accentColor: accentColor,
            ),
            _FrameCorner(
              alignment: Alignment.bottomRight,
              accentColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoCheckinFooter extends StatelessWidget {
  const _AutoCheckinFooter({
    required this.imageQr,
  });

  final String? imageQr;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    final rawImage = imageQr?.trim() ?? '';
    if (rawImage.isEmpty) {
      return _FooterPlaceholder();
    }

    if (rawImage.startsWith('http://') || rawImage.startsWith('https://')) {
      return Image.network(
        rawImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _FooterPlaceholder(),
      );
    }

    final bytes = _tryDecodeImage(rawImage);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _FooterPlaceholder(),
      );
    }

    return _FooterPlaceholder();
  }

  Uint8List? _tryDecodeImage(String rawImage) {
    try {
      final commaIndex = rawImage.indexOf(',');
      final base64Value = rawImage.startsWith('data:image')
          ? rawImage.substring(commaIndex + 1)
          : rawImage;
      return base64Decode(base64Value);
    } catch (_) {
      return null;
    }
  }
}

class _FooterPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(
          Icons.qr_code_2_rounded,
          color: Colors.white,
          size: 44,
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter(this.cutoutRect);

  final Rect cutoutRect;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.42);
    final fullRect = Offset.zero & size;
    final cutoutRRect = RRect.fromRectAndRadius(
      cutoutRect,
      const Radius.circular(28),
    );

    final fullPath = Path()..addRect(fullRect);
    final cutoutPath = Path()..addRRect(cutoutRRect);
    final overlayPath = Path.combine(
      PathOperation.difference,
      fullPath,
      cutoutPath,
    );

    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.cutoutRect != cutoutRect;
  }
}

class _FrameCorner extends StatelessWidget {
  const _FrameCorner({
    required this.alignment,
    required this.accentColor,
  });

  final Alignment alignment;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment.x < 0;
    final isTop = alignment.y < 0;

    return Align(
      alignment: alignment,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? BorderSide(color: accentColor, width: 5)
                : BorderSide.none,
            bottom: !isTop
                ? BorderSide(color: accentColor, width: 5)
                : BorderSide.none,
            left: isLeft
                ? BorderSide(color: accentColor, width: 5)
                : BorderSide.none,
            right: !isLeft
                ? BorderSide(color: accentColor, width: 5)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isLeft && isTop ? 28 : 0),
            topRight: Radius.circular(!isLeft && isTop ? 28 : 0),
            bottomLeft: Radius.circular(isLeft && !isTop ? 28 : 0),
            bottomRight: Radius.circular(!isLeft && !isTop ? 28 : 0),
          ),
        ),
      ),
    );
  }
}
