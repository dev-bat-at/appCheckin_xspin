import 'dart:async';

import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
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
      Duration(milliseconds: widget.isSuccess ? 1700 : 1500),
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
    final accentColor =
        widget.isSuccess ? const Color(0xFF0F7B6C) : AppColor.primaryColor;
    final softBackground =
        widget.isSuccess ? const Color(0xFFF0FBF8) : const Color(0xFFFFF4F3);

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
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: softBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isSuccess
                                ? Icons.check_circle_rounded
                                : Icons.error_outline_rounded,
                            color: accentColor,
                            size: 52,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          widget.isSuccess
                              ? 'Check-in thành công'
                              : 'Không thể check-in',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          widget.isSuccess
                              ? 'Hệ thống sẽ tự quay lại để tiếp tục quét.'
                              : (widget.description ??
                                  'Vui lòng thử lại với mã QR khác.'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.45,
                          ),
                        ),
                      ),
                      if (widget.isSuccess && currentUser != null) ...[
                        const SizedBox(height: 22),
                        _AutoInfoTile(
                          label: 'Mã QR',
                          value: currentUser.maQR,
                          accentColor: accentColor,
                          backgroundColor: softBackground,
                        ),
                        if (currentLineName.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: _AutoInfoTile(
                              label: 'Line check-in',
                              value: currentLineName,
                              accentColor: accentColor,
                              backgroundColor: softBackground,
                            ),
                          ),
                        const SizedBox(height: 16),
                        ..._buildFieldTiles(
                          loginInfo: loginInfo,
                          currentUser: currentUser,
                          accentColor: accentColor,
                          backgroundColor: softBackground,
                        ),
                      ],
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          'Tự động đóng sau giây lát...',
                          style: TextStyle(
                            color: Colors.grey[600],
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
        );
      },
    );
  }

  List<Widget> _buildFieldTiles({
    required Login? loginInfo,
    required Users currentUser,
    required Color accentColor,
    required Color backgroundColor,
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
            padding: const EdgeInsets.only(bottom: 12),
            child: _AutoInfoTile(
              label: field.key,
              value: field.value,
              accentColor: accentColor,
              backgroundColor: backgroundColor,
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
  });

  final String label;
  final String value;
  final Color accentColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
