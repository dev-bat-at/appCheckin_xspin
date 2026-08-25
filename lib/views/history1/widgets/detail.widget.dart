import 'package:checkin/app/app_language.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/api.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_user_checkin.vm.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:checkin/views/history/widgets/confirm_checkin.widget.dart';
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
  bool get _isManualCheckin =>
      AppSP.get(AppSPKey.isCheckinThuCong)?.toString() == '1';

  Future<void> _openConfirmCheckin() async {
    widget.usersViewModel.viewContext = context;
    // Replace detail so confirm→success→back lands on list in one stack.
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmCheckinPage(
          user: widget.user,
          onConfirm: widget.usersViewModel.manualCheckIn,
          onBackToList: widget.usersViewModel.reloadUsers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (loginViewModel) async {
        await loginViewModel.loadUser();
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
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field2,
                                  widget.user.field2),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field3,
                                  widget.user.field3),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field4,
                                  widget.user.field4),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field5,
                                  widget.user.field5),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field6,
                                  widget.user.field6),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field7,
                                  widget.user.field7),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field8,
                                  widget.user.field8),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field9,
                                  widget.user.field9),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field10,
                                  widget.user.field10),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field11,
                                  widget.user.field11),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field12,
                                  widget.user.field12),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field13,
                                  widget.user.field13),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field14,
                                  widget.user.field14),
                              _buildFieldSection(
                                  loginViewModel.userLogin?.field15,
                                  widget.user.field15),
                              Text(
                                AppLanguage.getText('ThoiGianCheckin'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSize.sizeSmall,
                                ),
                              ),
                              const SizedBox(height: 8),
                              widget.user.ngayCheckin != null &&
                                      widget.user.ngayCheckin!.isNotEmpty
                                  ? Text(
                                      widget.user.ngayCheckin!,
                                      style: TextStyle(
                                          color: AppColor.successQRCode,
                                          fontSize: AppFontSize.sizeSmall),
                                    )
                                  : Text(
                                      AppLanguage.getText('ChuaCheckin'),
                                      style: TextStyle(
                                          fontSize: AppFontSize.sizeSmall,
                                          color: AppColor.selectColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                              const Divider(height: 32, thickness: 1),
                              Text(
                                AppLanguage.getText('TrangThai'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSize.sizeSmall,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.user.tinhTrang == Api.DaCheckin
                                    ? AppLanguage.getText('DaCheckin')
                                    : AppLanguage.getText('ChuaCheckin'),
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
                    ),
                    if (_isManualCheckin && widget.user.canManualCheckIn)
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _openConfirmCheckin,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColor.primaryColor,
                                side: BorderSide(
                                  color: AppColor.primaryColor,
                                  width: 1.5,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                AppLanguage.getText('Checkin').toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFieldSection(String? loginField, String? userField,
      {bool isImportant = false}) {
    if (loginField == null && userField == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loginField != null) ...[
          Text(
            loginField,
            style: TextStyle(
                fontSize: AppFontSize.sizeSmall,
                fontWeight: AppFontWeight.bold),
          ),
        ],
        const SizedBox(height: 8),
        if (userField != null && userField.isNotEmpty) ...[
          Text(
            userField,
            style: TextStyle(
              fontSize: AppFontSize.sizeSmall,
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
        const Divider(height: 32, thickness: 1),
      ],
    );
  }
}
