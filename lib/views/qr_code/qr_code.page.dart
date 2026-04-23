import 'dart:async';

import 'package:checkin/app/app_route_observer.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:checkin/views/qr_code/scan_window_barcode_filter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:stacked/stacked.dart';

class QrCodePage extends StatefulWidget {
  QrCodePage({
    super.key,
    required this.qrViewModel,
    required this.indexViewModel,
  });
  final QRCodeViewModel qrViewModel;
  final IndexViewModel indexViewModel;

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage>
    with WidgetsBindingObserver, RouteAware {
  ModalRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    widget.qrViewModel.initScanner();
    WidgetsBinding.instance.addObserver(this);
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
    widget.qrViewModel.unbindScannerPage();
    unawaited(widget.qrViewModel.disposeScanner());
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
      widget.qrViewModel.unbindScannerPage();
      unawaited(widget.qrViewModel.stopScannerSafely());
    }
  }

  @override
  void didPushNext() {
    widget.qrViewModel.unbindScannerPage();
    unawaited(widget.qrViewModel.stopScannerSafely());
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
    if (!isCurrentRoute || widget.indexViewModel.currentIndex != 1) {
      return;
    }

    widget.qrViewModel.bindScannerPage(context);
    await widget.qrViewModel.startScannerSafely();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.qrViewModel,
      onViewModelReady: (viewModel) async {
        viewModel.indexViewModel = widget.indexViewModel;
        viewModel.bindScannerPage(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_resumeScannerIfVisible());
        });
      },
      builder: (context, viewModel, child) {
        viewModel.bindScannerPage(context);
        return BasePage(
          showLogo: true,
          body: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final scanWindow = Rect.fromCenter(
                            center: Offset(
                              constraints.maxWidth / 2,
                              constraints.maxHeight / 2,
                            ),
                            width: 250,
                            height: 250,
                          );

                          return Stack(
                            children: [
                              MobileScanner(
                                controller: viewModel.scannerController!,
                                scanWindow: scanWindow,
                                scanWindowUpdateThreshold: 8,
                                onDetect: (qrcode) async {
                                  if (!viewModel.isScanQr) {
                                    viewModel.isScanQr = true;
                                    try {
                                      final List<Barcode> barcodes = qrcode
                                          .barcodes
                                          .where(
                                            (barcode) =>
                                                isBarcodeInsideScanWindow(
                                              barcode: barcode,
                                              cameraPreviewSize: qrcode.size,
                                              widgetSize: constraints.biggest,
                                              scanWindow: scanWindow,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          .toList();
                                      for (final barcode in barcodes) {
                                        final String? rawValue =
                                            barcode.rawValue;
                                        if (rawValue != null) {
                                          viewModel.currentQRCode = rawValue;
                                          print('QR Code found: $rawValue');
                                          await viewModel.getUsers();
                                          break;
                                        }
                                      }
                                    } finally {
                                      viewModel.isScanQr = false;
                                    }
                                  }
                                },
                              ),
                              QRScannerOverlay(
                                overlayColor: Colors.black.withOpacity(0.5),
                                scanAreaSize: const Size(250, 250),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.5),
                      ),
                      child: Text(
                        'Hãy đưa mã QR vào giữa khung',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.sizeSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            viewModel.isFlashOn = !viewModel.isFlashOn;
                          });
                          viewModel.toggleTorchSafely();
                        },
                        icon: viewModel.isFlashOn
                            ? Icon(Icons.flash_on_sharp)
                            : Icon(Icons.flash_off_sharp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: 'Checkin QR Code',
        );
      },
    );
  }
}
