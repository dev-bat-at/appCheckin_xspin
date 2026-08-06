import 'package:checkin/app/app_language.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_users.vm.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class DetailTicket extends StatefulWidget {
  final Users user;
  final UsersViewModel usersViewModel;
  // final QRCodeViewModel qrCodeViewModel;

  DetailTicket(
      {super.key,
      // required this.qrCodeViewModel,
      required this.user,
      required this.usersViewModel});

  @override
  State<DetailTicket> createState() => _DetailTicketState();
}

class _DetailTicketState extends State<DetailTicket> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (loginViewModel) async {
        await loginViewModel.loadUser();
        await loginViewModel.loadQrCode(widget.user.maQR);
        // await widget.usersViewModel.loadQrCode(widget.user.maQR);
        // await widget.usersViewModel.getUsers();
      },
      builder: (context, loginViewModel, child) {
        return BasePage(
          title: '${AppLanguage.getText('MaQR')}: ${widget.user.maQR}',
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
                        if (widget.user.thoiDiemCheckin != null)
                          Text(
                            'Thời gian checkin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppFontSize.sizeSmall,
                            ),
                          ),
                        SizedBox(height: 8),
                        if (widget.user.thoiDiemCheckin != null)
                          widget.user.thoiDiemCheckin != ''
                              ? Text(
                                  widget.user.thoiDiemCheckin!,
                                  style: TextStyle(
                                      fontSize: AppFontSize.sizeSmall,
                                      color: AppColor.successQRCode),
                                )
                              : Text(
                                  AppLanguage.getText('ChuaCheckin'),
                                  style: TextStyle(
                                      fontSize: AppFontSize.sizeSmall,
                                      color: AppColor.selectColor,
                                      fontWeight: FontWeight.bold),
                                )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppLanguage.getText('LuotCheckinToiDa')}: ${widget.user.soLuotCheckIntoida}',
                                style: TextStyle(
                                    fontSize: AppFontSize.sizeSmall,
                                    color: AppColor.oriColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${AppLanguage.getText('DaCheckin')}: ${widget.user.dacheckIn}',
                                style: TextStyle(
                                    fontSize: AppFontSize.sizeSmall,
                                    color: AppColor.successQRCode,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${AppLanguage.getText('ChuaCheckin')}: ${widget.user.chuaCheckin}',
                                style: TextStyle(
                                    fontSize: AppFontSize.sizeSmall,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        Divider(height: 32, thickness: 1),
                        if (widget.user.thoiDiemCheckin == null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLanguage.getText('LichSuCheckin'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSize.sizeSmall,
                                ),
                              ),
                              widget.usersViewModel.detailUser?.lichSuCheckin ==
                                          null ||
                                      widget.usersViewModel.detailUser!
                                          .lichSuCheckin!.isEmpty
                                  ? Text(
                                      'Chưa có lịch sử checkin',
                                      style: TextStyle(
                                        fontSize: AppFontSize.sizeSmall,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: widget.usersViewModel
                                          .detailUser!.lichSuCheckin!.length,
                                      itemBuilder: (context, index) {
                                        final checkin = widget.usersViewModel
                                            .detailUser!.lichSuCheckin![index];
                                        return ListTile(
                                          leading: Icon(Icons.access_time,
                                              color: AppColor.successQRCode),
                                          title: Text(
                                            checkin.thoiDiemCheckin ??
                                                'Không có dữ liệu',
                                            style: TextStyle(
                                              fontSize: AppFontSize.sizeSmall,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
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
