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

  /// Parse "dd/MM/yyyy HH:mm" or similar into date + time parts.
  (String date, String time) _splitDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return ('', '');
    }
    final value = raw.trim();
    final parts = value.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts.first, parts.sublist(1).join(' '));
    }
    if (value.contains(':')) {
      return ('', value);
    }
    return (value, '');
  }

  @override
  Widget build(BuildContext context) {
    final showManualActions = _isManualCheckin && widget.user.canManualCheckIn;
    final (dateText, timeText) = _splitDateTime(widget.user.ngayCheckin);

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
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.user.maQR,
                                style: TextStyle(
                                  fontWeight: AppFontWeight.bold,
                                  color: _accentColor,
                                  fontSize: AppFontSize.sizeSuperSmall,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _checkedIn ? _lightGreenBg : _lightRedBg,
                                borderRadius: BorderRadius.circular(8),
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
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.user.field2 ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: AppFontWeight.bold,
                            fontSize: AppFontSize.sizeSmall,
                            color: AppColor.darkColor,
                          ),
                        ),
                        if (dateText.isNotEmpty || timeText.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Spacer(),
                              if (dateText.isNotEmpty) ...[
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: _mutedGrey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  dateText,
                                  style: const TextStyle(
                                    color: _mutedGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              if (dateText.isNotEmpty && timeText.isNotEmpty)
                                const SizedBox(width: 10),
                              if (timeText.isNotEmpty) ...[
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: _mutedGrey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  timeText,
                                  style: const TextStyle(
                                    color: _mutedGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                        if (showManualActions) ...[
                          const SizedBox(height: 12),
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
