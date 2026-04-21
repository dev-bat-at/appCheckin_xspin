import 'dart:async';

import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class SuccessScreenQR extends StatefulWidget {
  final QRCodeViewModel qrCodeViewModel;

  SuccessScreenQR({super.key, required this.qrCodeViewModel});

  @override
  State<SuccessScreenQR> createState() => _SuccessScreenQRState();
}

class _SuccessScreenQRState extends State<SuccessScreenQR> {
  bool _isLoading = false; // Trạng thái đang tải
  String? errorMessage; // Thông báo lỗi nếu có

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
            _showSnackBar(
                'Sự cố internet. Vui lòng thử lại.'); // Hiển thị SnackBar
          });
        }
      });
      if (AppSP.get(AppSPKey.loaiCheckin) == 'NL') {
        await widget.qrCodeViewModel.indexViewModel.usersViewModel
            .getCountUserCheckIn()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
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
            _showSnackBar(
                'Sự cố internet. Vui lòng thử lại.'); // Hiển thị SnackBar
          });
        }
      });
      if (AppSP.get(AppSPKey.loaiCheckin) == 'NL') {
        await widget.qrCodeViewModel.indexViewModel.usersViewModel
            .getUsers()
            .timeout(
              Duration(seconds: 30),
              onTimeout: () =>
                  throw TimeoutException('Sự cố internet. Vui lòng thử lại.'),
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
        onViewModelReady: (viewModel) async {
          Future.microtask(() async {
            await viewModel.indexViewModel.loginViewModel.loadUser();
          });
        },
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      viewModel.isBusy
                          ? LoadingAnimationWidget.threeRotatingDots(
                              color: AppColor.successQRCode,
                              size: 50,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (viewModel.currentUser != null) ...[
                                  // _buildFieldRow('Mã QR Code',
                                  //     viewModel.currentUser!.maaaQR),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Check-in thành công!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: AppFontSize.sizeLarge,
                                          fontWeight: FontWeight.w900,
                                          color: AppColor.successQRCode),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mã QR:',
                                        style: TextStyle(
                                            fontSize:
                                                AppFontSize.sizeSuperLarge,
                                            fontWeight: FontWeight.w900,
                                            color: AppColor.successQRCode),
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                            horizontal: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.successQRCode,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            viewModel.currentUser!.maQR,
                                            style: TextStyle(
                                              fontSize:
                                                  AppFontSize.sizeSuperLarge,
                                              color: AppColor.extraColor,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field2,
                                      viewModel.currentUser!.field2),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field3,
                                      viewModel.currentUser!.field3),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field4,
                                      viewModel.currentUser!.field4),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field5,
                                      viewModel.currentUser!.field5),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field6,
                                      viewModel.currentUser!.field6),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field7,
                                      viewModel.currentUser!.field7),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field8,
                                      viewModel.currentUser!.field8),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field9,
                                      viewModel.currentUser!.field9),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field10,
                                      viewModel.currentUser!.field10),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field11,
                                      viewModel.currentUser!.field11),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field12,
                                      viewModel.currentUser!.field12),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field13,
                                      viewModel.currentUser!.field13),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field14,
                                      viewModel.currentUser!.field14),
                                  _buildFieldRow(
                                      viewModel.indexViewModel.loginViewModel
                                          .userLogin!.field15,
                                      viewModel.currentUser!.field15),
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
                      _isLoading
                          ? LoadingAnimationWidget.threeRotatingDots(
                              color: AppColor.successQRCode,
                              size: 50,
                            )
                          : Container(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: _onContinuePressed,
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 36)),
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.greenAccent
                                              .shade400; // Màu khi nhấn
                                        }
                                        return AppColor
                                            .successQRCode; // Màu mặc định
                                      }),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      elevation: MaterialStateProperty.all(10),
                                    ),
                                    child: Text(
                                      "TIẾP TỤC CHECK IN",
                                      style: TextStyle(
                                        fontSize: AppFontSize.sizeMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _onContinuePressedHistory,
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 18)),
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors
                                              .red.shade400; // Màu khi nhấn
                                        }
                                        return AppColor
                                            .primaryColor; // Màu mặc định
                                      }),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      elevation: MaterialStateProperty.all(10),
                                    ),
                                    child: Text(
                                      "QUAY LẠI DANH SÁCH",
                                      style: TextStyle(
                                        fontSize: AppFontSize.sizeMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
            width: MediaQuery.of(context).size.width * 0.9,
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
