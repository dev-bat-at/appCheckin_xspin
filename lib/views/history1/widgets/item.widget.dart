import 'package:checkin/app/app_language.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_user_checkin.vm.dart';
import 'package:flutter/material.dart';

class ItemTicket extends StatefulWidget {
  final String? qrCodeUrl;

  final VoidCallback onTap;
  final Users user;
  HistoryCheckinViewModel usersViewModel;
  ItemTicket(
      {super.key,
      this.qrCodeUrl,
      required this.onTap,
      required this.user,
      required this.usersViewModel});

  @override
  State<ItemTicket> createState() => _ItemTicketQRState();
}

class _ItemTicketQRState extends State<ItemTicket> {
  static const Color _mutedGrey = Color(0xFF9E9E9E);
  static const Color _lightGreenBg = Color(0xFFE8F5E9);
  static const Color _lightRedBg = Color(0xFFFFEBEE);

  bool get _isManualCheckin =>
      AppSP.get(AppSPKey.isCheckinThuCong)?.toString() == '1';

  bool get _checkedIn => widget.user.hasCheckedIn;

  Color get _accentColor =>
      _checkedIn ? AppColor.successQRCode : AppColor.primaryColor;

  String get _dateTimeText {
    final raw = widget.user.ngayCheckin?.trim() ?? '';
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final showManualActions = _isManualCheckin && widget.user.canManualCheckIn;
    final dateTimeText = _dateTimeText;

    return InkWell(
      onTap: showManualActions ? null : widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: _accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.user.maQR,
                                    style: TextStyle(
                                      fontWeight: AppFontWeight.bold,
                                      color: _accentColor,
                                      fontSize: AppFontSize.sizeSuperSmall,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.user.field2 ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontWeight: AppFontWeight.bold,
                                      fontSize: AppFontSize.sizeSmall,
                                      color: AppColor.darkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _checkedIn
                                        ? _lightGreenBg
                                        : _lightRedBg,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    AppLanguage.getText(
                                      _checkedIn ? 'DaCheckin' : 'ChuaCheckin',
                                    ),
                                    style: TextStyle(
                                      fontSize: AppFontSize.sizeStatus,
                                      fontWeight: FontWeight.w700,
                                      color: _accentColor,
                                    ),
                                  ),
                                ),
                                if (dateTimeText.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 13,
                                        color: _mutedGrey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        dateTimeText,
                                        style: const TextStyle(
                                          color: _mutedGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        if (showManualActions) ...[
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  widget.usersViewModel.viewContext = context;
                                  widget.usersViewModel
                                      .nextConfirmCheckin(widget.user);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColor.primaryColor,
                                  side: BorderSide(
                                    color: AppColor.primaryColor,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppLanguage.getText('Checkin'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: AppLanguage.getText('XemChiTiet'),
                                onPressed: widget.onTap,
                                icon: Icon(
                                  Icons.visibility_outlined,
                                  color: AppColor.darkColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
