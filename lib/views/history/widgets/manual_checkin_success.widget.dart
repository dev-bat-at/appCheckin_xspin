import 'package:checkin/app/app_language.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

/// Success screen after manual check-in (same look as [SuccessScreenQR]).
class ManualCheckinSuccessPage extends StatelessWidget {
  final Users user;
  final Future<void> Function()? onBackToList;

  const ManualCheckinSuccessPage({
    super.key,
    required this.user,
    this.onBackToList,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (loginViewModel) async {
        await loginViewModel.loadUser();
      },
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
                        color: AppColor.successQRCode,
                        size: 50,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(pagePadding),
                      child: Center(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: maxContentWidth),
                          child: Column(
                            children: [
                              SizedBox(height: isTablet ? 28 : 20),
                              Text(
                                AppLanguage.getText('CheckInThanhCong'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.successQRCode,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.successQRCode,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        user.maQR,
                                        style: TextStyle(
                                          fontSize: qrFontSize,
                                          color: AppColor.extraColor,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildFieldRow(loginConfig?.field2, user.field2),
                              _buildFieldRow(loginConfig?.field3, user.field3),
                              _buildFieldRow(loginConfig?.field4, user.field4),
                              _buildFieldRow(loginConfig?.field5, user.field5),
                              _buildFieldRow(loginConfig?.field6, user.field6),
                              _buildFieldRow(loginConfig?.field7, user.field7),
                              _buildFieldRow(loginConfig?.field8, user.field8),
                              _buildFieldRow(loginConfig?.field9, user.field9),
                              _buildFieldRow(
                                  loginConfig?.field10, user.field10),
                              _buildFieldRow(
                                  loginConfig?.field11, user.field11),
                              _buildFieldRow(
                                  loginConfig?.field12, user.field12),
                              _buildFieldRow(
                                  loginConfig?.field13, user.field13),
                              _buildFieldRow(
                                  loginConfig?.field14, user.field14),
                              _buildFieldRow(
                                  loginConfig?.field15, user.field15),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () async {
                                  if (onBackToList != null) {
                                    await onBackToList!();
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
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
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldRow(String? loginField, String? userField) {
    if (loginField == null && userField == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loginField != null) ...[
          Text(
            '$loginField:',
            style: TextStyle(
              fontSize: AppFontSize.sizeSmall,
              color: AppColor.successQRCode,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
        const SizedBox(height: 8),
        if (userField != null && userField.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              userField,
              style: TextStyle(
                fontSize: AppFontSize.sizeSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
