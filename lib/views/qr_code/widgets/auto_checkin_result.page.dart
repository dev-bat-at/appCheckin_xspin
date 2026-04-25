import 'dart:async';

import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/login.model.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AutoCheckinResultPage extends StatefulWidget {
  const AutoCheckinResultPage({
    super.key,
    required this.qrCodeViewModel,
    required this.isSuccess,
    this.description,
  });

  final QRCodeViewModel qrCodeViewModel;
  final bool isSuccess;
  final String? description;

  @override
  State<AutoCheckinResultPage> createState() => _AutoCheckinResultPageState();
}

class _AutoCheckinResultPageState extends State<AutoCheckinResultPage> {
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLoginInfoIfNeeded());
    _dismissTimer = Timer(
      const Duration(milliseconds: 2500),
      _closeIfMounted,
    );
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLoginInfoIfNeeded() async {
    if (widget.qrCodeViewModel.indexViewModel.loginViewModel.userLogin !=
        null) {
      return;
    }

    await widget.qrCodeViewModel.indexViewModel.loginViewModel.loadUser();
    if (mounted) {
      setState(() {});
    }
  }

  void _closeIfMounted() {
    if (!mounted) {
      return;
    }
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isTablet = mediaQuery.size.shortestSide >= 600;
    final accentColor = widget.isSuccess ? Colors.green : AppColor.primaryColor;
    final softBackground = widget.isSuccess
        ? const Color.fromARGB(255, 240, 251, 243)
        : const Color(0xFFFFF4F3);
    final horizontalPadding = isTablet ? 40.0 : 20.0;
    final cardPadding = isTablet ? 28.0 : 20.0;
    final maxCardWidth = isTablet ? 620.0 : double.infinity;
    final titleFontSize = isTablet
        ? (AppFontSize.sizeSuperLarge ?? 32)
        : (AppFontSize.sizeLarge ?? 24);
    final messageFontSize = isTablet
        ? (AppFontSize.sizeSmall ?? 16)
        : (AppFontSize.sizeSuperSmall ?? 14);
    final footerFontSize = isTablet
        ? (AppFontSize.sizeSmall ?? 16)
        : (AppFontSize.sizeSuperSmall ?? 14);
    final iconBoxSize = isTablet ? 104.0 : 88.0;
    final iconSize = isTablet ? 60.0 : 52.0;

    return ViewModelBuilder<QRCodeViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.qrCodeViewModel,
      builder: (context, viewModel, child) {
        final currentUser = viewModel.currentUser;
        final loginInfo = viewModel.indexViewModel.loginViewModel.userLogin;
        final currentLineName =
            AppSP.get<String>(AppSPKey.tenLineCheckin) ?? '';

        return Scaffold(
          backgroundColor: const Color(0xFFF7F4EE),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isTablet ? 28 : 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxCardWidth),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.14),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            decoration: BoxDecoration(
                              color: softBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.isSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.error_outline_rounded,
                              color: accentColor,
                              size: iconSize,
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 22 : 18),
                        Center(
                          child: Text(
                            widget.isSuccess
                                ? 'Check-in thành công'
                                : 'Không thể check-in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 10 : 8),
                        Center(
                          child: Text(
                            widget.isSuccess
                                ? 'Hệ thống sẽ tự quay lại để tiếp tục quét.'
                                : (widget.description ??
                                    'Vui lòng thử lại với mã QR khác.'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: messageFontSize,
                              height: 1.45,
                            ),
                          ),
                        ),
                        if (widget.isSuccess && currentUser != null) ...[
                          SizedBox(height: isTablet ? 26 : 22),
                          _AutoInfoTile(
                            label: 'Mã QR',
                            value: currentUser.maQR,
                            accentColor: accentColor,
                            backgroundColor: softBackground,
                            isTablet: isTablet,
                          ),
                          if (currentLineName.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: isTablet ? 14 : 12),
                              child: _AutoInfoTile(
                                label: 'Line check-in',
                                value: currentLineName,
                                accentColor: accentColor,
                                backgroundColor: softBackground,
                                isTablet: isTablet,
                              ),
                            ),
                          SizedBox(height: isTablet ? 18 : 16),
                          ..._buildFieldTiles(
                            loginInfo: loginInfo,
                            currentUser: currentUser,
                            accentColor: accentColor,
                            backgroundColor: softBackground,
                            isTablet: isTablet,
                          ),
                        ],
                        SizedBox(height: isTablet ? 20 : 18),
                        Center(
                          child: Text(
                            'Tự động đóng sau giây lát...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: footerFontSize,
                              fontStyle: FontStyle.italic,
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

  List<Widget> _buildFieldTiles({
    required Login? loginInfo,
    required Users currentUser,
    required Color accentColor,
    required Color backgroundColor,
    required bool isTablet,
  }) {
    final fieldPairs = <MapEntry<String, String>>[];

    void addField(String? label, String? value, int index) {
      final cleanValue = value?.trim() ?? '';
      if (cleanValue.isEmpty) {
        return;
      }

      final cleanLabel = label?.trim();
      fieldPairs.add(
        MapEntry(
          (cleanLabel == null || cleanLabel.isEmpty)
              ? 'Thông tin $index'
              : cleanLabel,
          cleanValue,
        ),
      );
    }

    addField(loginInfo?.field2, currentUser.field2, 1);
    addField(loginInfo?.field3, currentUser.field3, 2);
    addField(loginInfo?.field4, currentUser.field4, 3);
    addField(loginInfo?.field5, currentUser.field5, 4);
    addField(loginInfo?.field6, currentUser.field6, 5);
    addField(loginInfo?.field7, currentUser.field7, 6);
    addField(loginInfo?.field8, currentUser.field8, 7);
    addField(loginInfo?.field9, currentUser.field9, 8);
    addField(loginInfo?.field10, currentUser.field10, 9);
    addField(loginInfo?.field11, currentUser.field11, 10);
    addField(loginInfo?.field12, currentUser.field12, 11);
    addField(loginInfo?.field13, currentUser.field13, 12);
    addField(loginInfo?.field14, currentUser.field14, 13);
    addField(loginInfo?.field15, currentUser.field15, 14);

    return fieldPairs
        .map(
          (field) => Padding(
            padding: EdgeInsets.only(bottom: isTablet ? 14 : 12),
            child: _AutoInfoTile(
              label: field.key,
              value: field.value,
              accentColor: accentColor,
              backgroundColor: backgroundColor,
              isTablet: isTablet,
            ),
          ),
        )
        .toList();
  }
}

class _AutoInfoTile extends StatelessWidget {
  const _AutoInfoTile({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.backgroundColor,
    required this.isTablet,
  });

  final String label;
  final String value;
  final Color accentColor;
  final Color backgroundColor;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontSize:
                  isTablet ? AppFontSize.sizeSmall : AppFontSize.sizeSuperSmall,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 6),
          Text(
            value,
            style: TextStyle(
              color: Colors.green,
              fontSize:
                  isTablet ? AppFontSize.sizeTable : AppFontSize.sizeSmall,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
