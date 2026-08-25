import 'package:checkin/app/app_language.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:checkin/views/history/widgets/manual_checkin_success.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class ConfirmCheckinPage extends StatefulWidget {
  final Users user;
  final Future<bool> Function(Users user) onConfirm;
  final Future<void> Function()? onBackToList;

  const ConfirmCheckinPage({
    super.key,
    required this.user,
    required this.onConfirm,
    this.onBackToList,
  });

  @override
  State<ConfirmCheckinPage> createState() => _ConfirmCheckinPageState();
}

class _ConfirmCheckinPageState extends State<ConfirmCheckinPage> {
  bool _isSubmitting = false;

  Future<void> _handleConfirm() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      final success = await widget.onConfirm(widget.user);
      if (!mounted) return;
      if (success) {
        // One transition: replace confirm with success (no flash back to list).
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ManualCheckinSuccessPage(
              user: widget.user,
              onBackToList: widget.onBackToList,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (loginViewModel) async {
        await loginViewModel.loadUser();
      },
      builder: (context, loginViewModel, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: loginViewModel.isBusy
                  ? Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: AppColor.primaryColor,
                        size: 50,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            AppLanguage.getText('XacNhanCheckin').toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.successQRCode,
                              fontSize: AppFontSize.sizeMedium ?? 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field2,
                                    widget.user.field2,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field3,
                                    widget.user.field3,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field4,
                                    widget.user.field4,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field5,
                                    widget.user.field5,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field6,
                                    widget.user.field6,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field7,
                                    widget.user.field7,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field8,
                                    widget.user.field8,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field9,
                                    widget.user.field9,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field10,
                                    widget.user.field10,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field11,
                                    widget.user.field11,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field12,
                                    widget.user.field12,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field13,
                                    widget.user.field13,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field14,
                                    widget.user.field14,
                                  ),
                                  _buildFieldSection(
                                    loginViewModel.userLogin?.field15,
                                    widget.user.field15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _isSubmitting ? null : _handleConfirm,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColor.successQRCode,
                                side: BorderSide(
                                  color: AppColor.successQRCode,
                                  width: 1.5,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isSubmitting
                                  ? SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColor.successQRCode,
                                      ),
                                    )
                                  : Text(
                                      AppLanguage.getText('XacNhan')
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () => Navigator.pop(context),
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
                                AppLanguage.getText('Dong').toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldSection(String? loginField, String? userField) {
    if ((loginField == null || loginField.isEmpty) &&
        (userField == null || userField.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loginField != null && loginField.isNotEmpty)
          Text(
            loginField,
            style: TextStyle(
              fontSize: AppFontSize.sizeSmall,
              fontWeight: AppFontWeight.bold,
              color: AppColor.darkColor,
            ),
          ),
        const SizedBox(height: 8),
        if (userField != null && userField.isNotEmpty)
          Text(
            userField,
            style: TextStyle(
              fontSize: AppFontSize.sizeSmall,
              color: AppColor.darkColor,
            ),
          ),
        const Divider(height: 32, thickness: 1),
      ],
    );
  }
}
