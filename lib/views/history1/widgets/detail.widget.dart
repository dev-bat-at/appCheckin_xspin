import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/api.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_user_checkin.vm.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class DetailTicket1 extends StatefulWidget {
  final Users user;
  final HistoryCheckinViewModel usersViewModel;

  DetailTicket1({super.key, required this.user, required this.usersViewModel});

  @override
  State<DetailTicket1> createState() => _DetailTicket1State();
}

class _DetailTicket1State extends State<DetailTicket1> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(), // Sử dụng LoginViewModel
      onViewModelReady: (loginViewModel) async {
        await loginViewModel.loadUser(); // Tải dữ liệu từ loginViewModel
      },
      builder: (context, loginViewModel, child) {
        return BasePage(
          title: 'Mã QR: ${widget.user.maQR}',
          body: loginViewModel.isBusy
              ? Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColor.primaryColor,
                    size: 50,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Field 2 đến Field 15
                        _buildFieldSection(loginViewModel.userLogin?.field2,
                            widget.user.field2),
                        _buildFieldSection(loginViewModel.userLogin?.field3,
                            widget.user.field3),
                        _buildFieldSection(loginViewModel.userLogin?.field4,
                            widget.user.field4),
                        _buildFieldSection(loginViewModel.userLogin?.field5,
                            widget.user.field5),
                        _buildFieldSection(loginViewModel.userLogin?.field6,
                            widget.user.field6),
                        _buildFieldSection(loginViewModel.userLogin?.field7,
                            widget.user.field7),
                        _buildFieldSection(loginViewModel.userLogin?.field8,
                            widget.user.field8),
                        _buildFieldSection(loginViewModel.userLogin?.field9,
                            widget.user.field9),
                        _buildFieldSection(loginViewModel.userLogin?.field10,
                            widget.user.field10),
                        _buildFieldSection(loginViewModel.userLogin?.field11,
                            widget.user.field11),
                        _buildFieldSection(loginViewModel.userLogin?.field12,
                            widget.user.field12),
                        _buildFieldSection(loginViewModel.userLogin?.field13,
                            widget.user.field13),
                        _buildFieldSection(loginViewModel.userLogin?.field14,
                            widget.user.field14),
                        _buildFieldSection(loginViewModel.userLogin?.field15,
                            widget.user.field15),

                        // Thời gian Checkin
                        Text(
                          'Thời gian checkin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.sizeSmall,
                          ),
                        ),
                        SizedBox(height: 8),
                        widget.user.ngayCheckin != ''
                            ? Text(
                                widget.user.ngayCheckin!,
                                style: TextStyle(
                                    color: AppColor.successQRCode,
                                    fontSize: AppFontSize.sizeSmall),
                              )
                            : Text(
                                'QR chưa checkin',
                                style: TextStyle(
                                    fontSize: AppFontSize.sizeSmall,
                                    color: AppColor.selectColor,
                                    fontWeight: FontWeight.bold),
                              ),
                        Divider(height: 32, thickness: 1),
                        Text(
                          'Trạng thái',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSize.sizeSmall,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.user.tinhTrang == Api.DaCheckin
                              ? "Đã checkin"
                              : "Chưa checkin",
                          style: TextStyle(
                            color: widget.user.tinhTrang == Api.DaCheckin
                                ? AppColor.successQRCode
                                : AppColor.selectColor,
                            fontSize: AppFontSize.sizeSmall,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  // Hàm để xây dựng các phần hiển thị cho từng field
  Widget _buildFieldSection(String? loginField, String? userField,
      {bool isImportant = false}) {
    if (loginField == null && userField == null) {
      return SizedBox.shrink(); // Không hiển thị nếu cả hai đều là null
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loginField != null) ...[
          Text(
            loginField,
            style: TextStyle(
                fontSize: AppFontSize.sizeSmall,
                // fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
                fontWeight: AppFontWeight.bold),
          ),
        ],
        SizedBox(height: 8),
        if (userField != null && userField.isNotEmpty) ...[
          Text(
            userField,
            style: TextStyle(
              fontSize: AppFontSize.sizeSmall,
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
        Divider(height: 32, thickness: 1),
      ],
    );
  }
}
