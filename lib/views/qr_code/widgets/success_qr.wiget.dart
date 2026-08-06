import 'dart:async';

import 'package:checkin/app/app_language.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class SuccessScreenQR extends StatefulWidget {
  final QRCodeViewModel qrCodeViewModel;
  final bool autoClose;
  final Duration autoCloseDuration;

  const SuccessScreenQR({
    super.key,
    required this.qrCodeViewModel,
    this.autoClose = false,
    this.autoCloseDuration = const Duration(milliseconds: 2500),
  });

  @override
  State<SuccessScreenQR> createState() => _SuccessScreenQRState();
}

class _SuccessScreenQRState extends State<SuccessScreenQR> {
  bool _isLoading = false; // Trạng thái đang tải
  String? errorMessage; // Thông báo lỗi nếu có
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    if (widget.autoClose) {
      _dismissTimer = Timer(widget.autoCloseDuration, _closeIfMounted);
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _closeIfMounted() {
    if (!mounted) {
      return;
    }
    Navigator.maybePop(context);
  }

  Future<void> _onContinuePressed() async {
    setState(() {
      _isLoading = true; // Hiển thị spinner
      errorMessage = null; // Xóa lỗi nếu có trước đó
    });

    try {
      // Bắt đầu bộ đếm thời gian 30 giây
      final timeout = Future.delayed(Duration(seconds: 30), () {
        if (_isLoading && mounted) {
          setState(() {
            _isLoading = false;
            _showSnackBar(AppLanguage.getText('SuCoInternet')); // Hiển thị SnackBar
          });
        }
      });
      if (AppSP.get(AppSPKey.loaiCheckin) == 'NL') {
        await widget.qrCodeViewModel.indexViewModel.usersViewModel
            .getCountUserCheckIn()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () => throw TimeoutException(AppLanguage.getText(
                  'SuCoInternet')),
            );
        await widget.qrCodeViewModel.indexViewModel.usersViewModel
            .getUsers()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
            );
        if (mounted) {
          Navigator.maybePop(context);
        }
      } else if (AppSP.get(AppSPKey.loaiCheckin) == '1L') {
        await widget.qrCodeViewModel.indexViewModel.historyViewModel
            .getCountUserCheckIn()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
            );
        await widget.qrCodeViewModel.indexViewModel.historyViewModel
            .reloadUsers()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
            );

        if (mounted) {
          Navigator.maybePop(context);
        }
      } else {
        throw Exception('Không thể tải dữ liệu người dùng.');
      }
      await timeout; // Chờ thời gian kết thúc
    } catch (e) {
      if (mounted) {
        _showSnackBar('Có lỗi xảy ra: $e'); // Hiển thị SnackBar khi có lỗi
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Dừng hiển thị spinner
        });
      }
    }
  }

  Future<void> _onContinuePressedHistory() async {
    setState(() {
      _isLoading = true; // Hiển thị spinner
      errorMessage = null; // Xóa lỗi nếu có trước đó
    });

    try {
      // Bắt đầu bộ đếm thời gian 30 giây
      final timeout = Future.delayed(Duration(seconds: 30), () {
        if (_isLoading && mounted) {
          setState(() {
            _isLoading = false;
            _showSnackBar(AppLanguage.getText('SuCoInternet')); // Hiển thị SnackBar
          });
        }
      });
      if (AppSP.get(AppSPKey.loaiCheckin) == 'NL') {
        await widget.qrCodeViewModel.indexViewModel.usersViewModel
            .getUsers()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () => throw TimeoutException(AppLanguage.getText(
                  'SuCoInternet')),
            );
        await widget.qrCodeViewModel.indexViewModel.usersViewModel
            .getCountUserCheckIn()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
            );

        if (mounted) {
          setState(() {
            widget.qrCodeViewModel.indexViewModel.setIndex(0);
            widget.qrCodeViewModel.indexViewModel.usersViewModel.getUsers();
            Navigator.maybePop(context);
          });
        }
      } else if (AppSP.get(AppSPKey.loaiCheckin) == '1L') {
        await widget.qrCodeViewModel.indexViewModel.historyViewModel
            .getUsers()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
            );
        await widget.qrCodeViewModel.indexViewModel.historyViewModel
            .getCountUserCheckIn()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
            );

        if (mounted) {
          setState(() {
            widget.qrCodeViewModel.indexViewModel.setIndex(0);
            widget.qrCodeViewModel.indexViewModel.historyViewModel.getUsers();
            Navigator.maybePop(context);
          });
        }
      }
      await timeout; // Chờ thời gian kết thúc
    } catch (e) {
      if (mounted) {
        _showSnackBar('Có lỗi xảy ra: $e'); // Hiển thị SnackBar khi có lỗi
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Dừng hiển thị spinner
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.qrCodeViewModel,
      onViewModelReady: (viewModel) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) {
            return;
          }
          await viewModel.indexViewModel.loginViewModel.loadUser();
        });
      },
      builder: (context, viewModel, child) {
        return ViewModelBuilder<LoginViewModel>.reactive(
          disposeViewModel: false,
          viewModelBuilder: () => viewModel.indexViewModel.loginViewModel,
          builder: (context, loginViewModel, child) {
            final mediaQuery = MediaQuery.of(context);
            final isTablet = mediaQuery.size.shortestSide >= 600;
            final maxContentWidth = isTablet ? 620.0 : double.infinity;
            final pagePadding = isTablet ? 32.0 : 20.0;
            final titleFontSize = isTablet
                ? (AppFontSize.sizeLarge ?? 24) + 4
                : (AppFontSize.sizeLarge ?? 24);
            final qrFontSize = isTablet
                ? (AppFontSize.sizeSuperLarge ?? 32) + 2
                : (AppFontSize.sizeSuperLarge ?? 32);
            final buttonFontSize = isTablet
                ? (AppFontSize.sizeMedium ?? 20) + 1
                : (AppFontSize.sizeMedium ?? 20);
            final loginConfig = loginViewModel.userLogin;

            return SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(pagePadding),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Column(
                        children: [
                          SizedBox(height: isTablet ? 28 : 20),
                          viewModel.isBusy
                              ? LoadingAnimationWidget.threeRotatingDots(
                                  color: AppColor.successQRCode,
                                  size: 50,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (viewModel.currentUser != null) ...[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Check-in thành công!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            fontWeight: FontWeight.w900,
                                            color: AppColor.successQRCode,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${AppLanguage.getText('MaQR')}:',
                                            style: TextStyle(
                                              fontSize: qrFontSize,
                                              fontWeight: FontWeight.w900,
                                              color: AppColor.successQRCode,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.successQRCode,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              viewModel.currentUser!.maQR,
                                              style: TextStyle(
                                                fontSize: qrFontSize,
                                                color: AppColor.extraColor,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildFieldRow(
                                        loginConfig?.field2,
                                        viewModel.currentUser!.field2,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field3,
                                        viewModel.currentUser!.field3,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field4,
                                        viewModel.currentUser!.field4,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field5,
                                        viewModel.currentUser!.field5,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field6,
                                        viewModel.currentUser!.field6,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field7,
                                        viewModel.currentUser!.field7,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field8,
                                        viewModel.currentUser!.field8,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field9,
                                        viewModel.currentUser!.field9,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field10,
                                        viewModel.currentUser!.field10,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field11,
                                        viewModel.currentUser!.field11,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field12,
                                        viewModel.currentUser!.field12,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field13,
                                        viewModel.currentUser!.field13,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field14,
                                        viewModel.currentUser!.field14,
                                      ),
                                      _buildFieldRow(
                                        loginConfig?.field15,
                                        viewModel.currentUser!.field15,
                                      ),
                                    ] else ...[
                                      Text(
                                        "",
                                        style: TextStyle(
                                          fontSize: AppFontSize.sizeSmall,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                          const SizedBox(height: 30),
                          if (widget.autoClose)
                            Text(
                              'Tự động đóng sau 3 giây....',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet
                                    ? (AppFontSize.sizeSmall ?? 16)
                                    : (AppFontSize.sizeSuperSmall ?? 14),
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            )
                          else if (_isLoading)
                            LoadingAnimationWidget.threeRotatingDots(
                              color: AppColor.successQRCode,
                              size: 50,
                            )
                          else
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: _onContinuePressed,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 36,
                                      ),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) {
                                        if (states
                                            .contains(WidgetState.pressed)) {
                                          return Colors.greenAccent.shade400;
                                        }
                                        return AppColor.successQRCode;
                                      },
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    elevation: WidgetStateProperty.all(10),
                                  ),
                                  child: Text(
                                    AppLanguage.getText('TiepTucCheckIn'),
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _onContinuePressedHistory,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 18,
                                      ),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) {
                                        if (states
                                            .contains(WidgetState.pressed)) {
                                          return Colors.red.shade400;
                                        }
                                        return AppColor.primaryColor;
                                      },
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    elevation: WidgetStateProperty.all(10),
                                  ),
                                  child: Text(
                                    AppLanguage.getText('QuayLaiDanhSach'),
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Hàm để xây dựng dòng cho các field
  Widget _buildFieldRow(String? loginField, String? userField,
      {bool isImportant = false}) {
    if (loginField == null && userField == null) {
      return SizedBox.shrink(); // Không hiển thị nếu cả hai đều là null
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loginField != null) ...[
          Text(
            '${loginField}:',
            style: TextStyle(
                fontSize: AppFontSize.sizeSmall,
                color: AppColor.successQRCode,
                // fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
                fontWeight: FontWeight.w900),
          ),
        ],
        SizedBox(height: 8),
        if (userField != null && userField.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green, // Màu của viền
                width: 1.5, // Độ dày của viền
              ),
              borderRadius: BorderRadius.circular(8.0), // Bo góc viền
            ),
            child: Text(
              userField,
              style: TextStyle(
                fontSize: AppFontSize.sizeMedium,
                fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
        Divider(height: 15, thickness: 0.1),
      ],
    );
  }
}
