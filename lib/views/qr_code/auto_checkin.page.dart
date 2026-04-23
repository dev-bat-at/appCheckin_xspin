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

const _defaultAutoCheckinBackgroundUrl =
    'https://xspin.vn/images/phan-mem-check-in.jpg';

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
    final loginViewModel = widget.indexViewModel.loginViewModel;
    _qrViewModel.initScanner(
      facing: _resolveCameraFacing(loginViewModel.userLogin?.cameraCheckin),
    );
    WidgetsBinding.instance.addObserver(this);
    if (loginViewModel.userLogin == null) {
      unawaited(
        loginViewModel.loadUser().then((_) => _syncPreferredCamera()),
      );
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

  CameraFacing _resolveCameraFacing(String? cameraSetting) {
    switch (cameraSetting?.trim()) {
      case 'CameraSau':
        return CameraFacing.back;
      case 'CameraTruoc':
      default:
        return CameraFacing.front;
    }
  }

  Future<void> _syncPreferredCamera() async {
    if (!mounted) {
      return;
    }

    await _qrViewModel.configureScannerFacing(
      _resolveCameraFacing(
        widget.indexViewModel.loginViewModel.userLogin?.cameraCheckin,
      ),
    );
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
          body: ViewModelBuilder<LoginViewModel>.reactive(
            disposeViewModel: false,
            viewModelBuilder: () => widget.indexViewModel.loginViewModel,
            builder: (context, loginViewModel, child) {
              return LayoutBuilder(
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

                  final scanner = MobileScanner(
                    controller: viewModel.scannerController!,
                    fit: BoxFit.cover,
                    onDetect: _handleDetection,
                  );

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      viewModel.isFrontCamera
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: scanner,
                            )
                          : scanner,
                      _AutoCheckinBackgroundLayer(
                        imageQr: loginViewModel.userLogin?.imageQr,
                        cutoutRect: scanWindow,
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
                                      color: Colors.white.withValues(
                                        alpha: 0.14,
                                      ),
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
                    ],
                  );
                },
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

class _AutoCheckinBackgroundLayer extends StatelessWidget {
  const _AutoCheckinBackgroundLayer({
    required this.imageQr,
    required this.cutoutRect,
  });

  final String? imageQr;
  final Rect cutoutRect;

  @override
  Widget build(BuildContext context) {
    final backgroundImage = _buildImageContent();
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundImage != null)
            ClipPath(
              clipper: _InvertedCutoutClipper(cutoutRect),
              child: backgroundImage,
            ),
          CustomPaint(
            painter: _ScannerOverlayPainter(
              cutoutRect,
              overlayColor: backgroundImage == null
                  ? Colors.black.withValues(alpha: 0.42)
                  : Colors.black.withValues(alpha: 0.18),
            ),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }

  Widget? _buildImageContent() {
    final rawImage = (imageQr?.trim().isNotEmpty ?? false)
        ? imageQr!.trim()
        : _defaultAutoCheckinBackgroundUrl;
    if (rawImage.isEmpty) {
      return null;
    }

    if (rawImage.startsWith('http://') || rawImage.startsWith('https://')) {
      return Image.network(
        rawImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }

    final bytes = _tryDecodeImage(rawImage);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    }

    return null;
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

class _InvertedCutoutClipper extends CustomClipper<Path> {
  const _InvertedCutoutClipper(this.cutoutRect);

  final Rect cutoutRect;

  @override
  Path getClip(Size size) {
    final fullRect = Path()..addRect(Offset.zero & size);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          cutoutRect,
          const Radius.circular(28),
        ),
      );

    return Path.combine(
      PathOperation.difference,
      fullRect,
      cutoutPath,
    );
  }

  @override
  bool shouldReclip(covariant _InvertedCutoutClipper oldClipper) {
    return oldClipper.cutoutRect != cutoutRect;
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter(
    this.cutoutRect, {
    required this.overlayColor,
  });

  final Rect cutoutRect;
  final Color overlayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = overlayColor;
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
    return oldDelegate.cutoutRect != cutoutRect ||
        oldDelegate.overlayColor != overlayColor;
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
