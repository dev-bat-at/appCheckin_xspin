import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:checkin/views/qr_code/widgets/failed_qr.widget.dart';
import 'package:flutter/material.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';

import 'package:checkin/model/user.model.dart';
import 'package:checkin/requests/history_user.requets.dart';
import 'package:checkin/requests/qrcode.request.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/views/qr_code/widgets/auto_checkin_result.page.dart';
import 'package:checkin/views/qr_code/widgets/success_qr.wiget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stacked/stacked.dart';

enum QRCodeFlowMode { manual, automatic }

class QRCodeViewModel extends BaseViewModel {
  late BuildContext viewContext;
  QRCodeRequest qrCodeRequest = QRCodeRequest();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Users>? listUser;
  Users? currentUser;
  String? currentQRCode;
  bool? scanQrCode;
  // late Users detailUser;
  UserRequest userRequest = UserRequest();
  MobileScannerController? scannerController;
  late IndexViewModel indexViewModel;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool isScanQr = false;
  String? lastScannedQRCode;
  bool _isScannerPageActive = false;

  @override
  void dispose() {
    unawaited(disposeScanner());
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    print('hi pass');
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource('pass.mp3'));
  }

  Future<void> _playErrorSound() async {
    print('hi ngheeeeee');
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource('fail.mp3'));
  }

  void bindScannerPage(BuildContext context) {
    viewContext = context;
    _isScannerPageActive = true;
    initScanner();
  }

  void unbindScannerPage() {
    _isScannerPageActive = false;
  }

  void initScanner({CameraFacing facing = CameraFacing.back}) {
    if (scannerController == null) {
      scannerController = MobileScannerController(
        autoStart: false,
        facing: facing,
        detectionSpeed: DetectionSpeed.noDuplicates,
        detectionTimeoutMs: 500,
      );
    }
  }

  Future<void> startScannerSafely() async {
    final controller = scannerController;
    if (!_isScannerPageActive || controller == null) {
      return;
    }
    if (controller.value.isRunning || controller.value.isStarting) {
      return;
    }

    try {
      await controller.start();
    } catch (e) {
      debugPrint('Start scanner skipped: $e');
    }
  }

  Future<void> stopScannerSafely() async {
    final controller = scannerController;
    if (controller == null) {
      return;
    }
    if (!controller.value.isInitialized || !controller.value.isRunning) {
      return;
    }

    try {
      await controller.stop();
    } catch (e) {
      debugPrint('Stop scanner skipped: $e');
    }
  }

  Future<void> disposeScanner() async {
    final controller = scannerController;
    scannerController = null;
    isScanQr = false;
    isFlashOn = false;
    _isScannerPageActive = false;

    if (controller == null) {
      return;
    }

    try {
      if (controller.value.isInitialized && controller.value.isRunning) {
        await controller.stop();
      }
    } catch (e) {
      debugPrint('Stop scanner before dispose skipped: $e');
    }

    try {
      await controller.dispose();
    } catch (e) {
      debugPrint('Dispose scanner skipped: $e');
    }
  }

  Future<void> toggleTorchSafely() async {
    final controller = scannerController;
    if (controller == null ||
        !controller.value.isInitialized ||
        !controller.value.isRunning) {
      return;
    }

    try {
      await controller.toggleTorch();
    } catch (e) {
      debugPrint('Toggle torch skipped: $e');
    }
  }

  Future<void> refreshCheckinData() async {
    final loaiCheckin = AppSP.get(AppSPKey.loaiCheckin);

    try {
      if (loaiCheckin == 'NL') {
        await Future.wait([
          indexViewModel.usersViewModel.getCountUserCheckIn(),
          indexViewModel.usersViewModel.getUsers(),
        ]);
        return;
      }

      if (loaiCheckin == '1L') {
        await Future.wait([
          indexViewModel.historyViewModel.getCountUserCheckIn(),
          indexViewModel.historyViewModel.reloadUsers(),
        ]);
      }
    } catch (e) {
      debugPrint('Refresh check-in data skipped: $e');
    }
  }

  Future<void> loadQrCode(String maQR) async {
    currentUser = await qrCodeRequest.checkIn(
      idSuKien: AppSP.get(AppSPKey.idSuKien),
      maQR: maQR,
      idLineCheckin: AppSP.get(AppSPKey.idLineCheckin),
    );
  }

  Users _mergeUserData({
    required Users originalUser,
    Users? checkedInUser,
  }) {
    if (checkedInUser == null) {
      return originalUser;
    }

    return Users(
      maQR: checkedInUser.maQR.isNotEmpty
          ? checkedInUser.maQR
          : originalUser.maQR,
      isCheckin: checkedInUser.isCheckin,
      idNguoiThamDu: checkedInUser.idNguoiThamDu.isNotEmpty
          ? checkedInUser.idNguoiThamDu
          : originalUser.idNguoiThamDu,
      thoiDiemCheckin:
          checkedInUser.thoiDiemCheckin ?? originalUser.thoiDiemCheckin,
      tenTinhTrang: checkedInUser.tenTinhTrang ?? originalUser.tenTinhTrang,
      maTinhTrang: checkedInUser.maTinhTrang ?? originalUser.maTinhTrang,
      tinhTrang: checkedInUser.tinhTrang ?? originalUser.tinhTrang,
      field2: checkedInUser.field2 ?? originalUser.field2,
      field3: checkedInUser.field3 ?? originalUser.field3,
      field4: checkedInUser.field4 ?? originalUser.field4,
      field5: checkedInUser.field5 ?? originalUser.field5,
      field6: checkedInUser.field6 ?? originalUser.field6,
      field7: checkedInUser.field7 ?? originalUser.field7,
      field8: checkedInUser.field8 ?? originalUser.field8,
      field9: checkedInUser.field9 ?? originalUser.field9,
      field10: checkedInUser.field10 ?? originalUser.field10,
      field11: checkedInUser.field11 ?? originalUser.field11,
      field12: checkedInUser.field12 ?? originalUser.field12,
      field13: checkedInUser.field13 ?? originalUser.field13,
      field14: checkedInUser.field14 ?? originalUser.field14,
      field15: checkedInUser.field15 ?? originalUser.field15,
      soLuotCheckIntoida:
          checkedInUser.soLuotCheckIntoida ?? originalUser.soLuotCheckIntoida,
      ngayCheckin: checkedInUser.ngayCheckin ?? originalUser.ngayCheckin,
      dacheckIn: checkedInUser.dacheckIn ?? originalUser.dacheckIn,
      chuaCheckin: checkedInUser.chuaCheckin ?? originalUser.chuaCheckin,
      lichSuCheckin: checkedInUser.lichSuCheckin != null &&
              checkedInUser.lichSuCheckin!.isNotEmpty
          ? checkedInUser.lichSuCheckin
          : originalUser.lichSuCheckin,
    );
  }

  Future<void> getUsers({
    QRCodeFlowMode flowMode = QRCodeFlowMode.manual,
  }) async {
    final qrCode = currentQRCode;
    if (qrCode == null || qrCode.isEmpty) {
      return;
    }

    setBusy(true);
    print('Vô get');
    try {
      final userDetail = await qrCodeRequest.getUser(
        idSuKien: AppSP.get(AppSPKey.idSuKien),
        maQR: qrCode,
      );

      if (userDetail != null) {
        currentUser = userDetail;
        final checkedInCount = userDetail.dacheckIn ?? 0;
        final maxCheckinCount = userDetail.soLuotCheckIntoida ?? 1;

        if (checkedInCount < maxCheckinCount) {
          final checkedInUser = await qrCodeRequest.checkIn(
            idSuKien: AppSP.get(AppSPKey.idSuKien),
            maQR: qrCode,
            idLineCheckin: AppSP.get(AppSPKey.idLineCheckin),
          );
          currentUser = _mergeUserData(
            originalUser: userDetail,
            checkedInUser: checkedInUser,
          );
          setBusy(false);
          notifyListeners();
          unawaited(refreshCheckinData());
          await _playSuccessSound();
          if (flowMode == QRCodeFlowMode.automatic) {
            showAutomaticResult(isSuccess: true);
          } else {
            showSuccessScanQrCode();
          }
        } else {
          setBusy(false);
          notifyListeners();
          await _playErrorSound();
          final desc = AppSP.get(AppSPKey.loaiCheckin) == 'NL'
              ? 'Mã QR $qrCode đã hết lượt check-in!'
              : 'Mã QR $qrCode đã được check-in rồi!';
          if (flowMode == QRCodeFlowMode.automatic) {
            showAutomaticResult(
              isSuccess: false,
              description: desc,
            );
          } else {
            _showResultPage(
              FailedQrCode(
                qrCodeViewModel: this,
                title: 'Thông báo',
                desc: desc,
              ),
            );
          }
        }
      } else {
        setBusy(false);
        notifyListeners();
        await _playErrorSound();
        if (flowMode == QRCodeFlowMode.automatic) {
          showAutomaticResult(
            isSuccess: false,
            description: 'Mã QR Code không tồn tại',
          );
        } else {
          _showResultPage(
            FailedQrCode(
              qrCodeViewModel: this,
              title: 'Thông báo',
              desc: 'Mã QR Code không tồn tại',
            ),
          );
        }
      }
    } catch (e) {
      String errorMessage =
          'Có lỗi xảy ra, vui lòng kiểm tra lại kết nối internet hoặc Mã QrCode không tồn tại!';
      if (e.toString().contains('Lỗi kết nối internet')) {
        errorMessage =
            'Lỗi kết nối internet. Vui lòng kiểm tra Wi-Fi hoặc dữ liệu di động.';
      }

      setBusy(false);
      notifyListeners();
      await _playErrorSound();
      if (flowMode == QRCodeFlowMode.automatic) {
        showAutomaticResult(
          isSuccess: false,
          description: errorMessage,
        );
      } else {
        _showResultPage(
          FailedQrCode(
            qrCodeViewModel: this,
            title: 'Thông báo',
            desc: errorMessage,
          ),
        );
      }
    }
  }

  Future<void> _showResultPage(
    Widget page, {
    bool restartScannerAfterClose = false,
  }) async {
    await stopScannerSafely();
    if (!_isScannerPageActive || !viewContext.mounted) {
      return;
    }

    await Navigator.push(
      viewContext,
      MaterialPageRoute(builder: (context) => page),
    );

    if (!restartScannerAfterClose ||
        !_isScannerPageActive ||
        !viewContext.mounted) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 120));
    await startScannerSafely();
  }

  Future<void> showSuccessScanQrCode() async {
    print('Nhảy');
    await _showResultPage(SuccessScreenQR(qrCodeViewModel: this));
  }

  Future<void> showAutomaticResult({
    required bool isSuccess,
    String? description,
  }) async {
    await _showResultPage(
      AutoCheckinResultPage(
        qrCodeViewModel: this,
        isSuccess: isSuccess,
        description: description,
      ),
      restartScannerAfterClose: true,
    );
  }

  void showQRCodeAlreadyScannedDialog(BuildContext context, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: 'Mã đã quét',
      desc: desc,
      btnOkOnPress: () {
        unawaited(startScannerSafely());
        // Navigator.maybePop(context);
      },
      dismissOnTouchOutside: false,
    )..show();
  }

  void showQRCodeFailed(BuildContext context, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: 'QRCode Không tồn tại',
      desc: desc,
      btnOkOnPress: () {
        unawaited(startScannerSafely());
      },
      dismissOnTouchOutside: false,
    )..show();
  }
}
