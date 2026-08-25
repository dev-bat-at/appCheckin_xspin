import 'package:checkin/app/app_language.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_users.vm.dart';
import 'package:flutter/material.dart';

class ItemTicketQR extends StatefulWidget {
  final VoidCallback onTap;
  final Users user;
  UsersViewModel usersViewModel;
  ItemTicketQR(
      {super.key,
      required this.onTap,
      required this.user,
      required this.usersViewModel});

  @override
  State<ItemTicketQR> createState() => _ItemTicketQRState();
}

class _ItemTicketQRState extends State<ItemTicketQR> {
  bool get _isManualCheckin =>
      AppSP.get(AppSPKey.isCheckinThuCong)?.toString() == '1';

  Color get _maQrColor =>
      widget.user.hasCheckedIn ? AppColor.successQRCode : AppColor.primaryColor;

  @override
  Widget build(BuildContext context) {
    final showManualActions = _isManualCheckin && widget.user.canManualCheckIn;
    final accentColor = _maQrColor;

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
                Container(width: 4, color: accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.user.maQR,
                                    style: TextStyle(
                                      fontSize: AppFontSize.sizeSuperSmall,
                                      fontWeight: AppFontWeight.bold,
                                      color: accentColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    widget.user.field2 ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${AppLanguage.getText('LuotCheckinToiDa')}: ${widget.user.soLuotCheckIntoida ?? 0}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: AppFontSize.sizeStatus,
                                      color: AppColor.oriColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${AppLanguage.getText('DaCheckin')}: ${widget.user.dacheckIn ?? 0}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: AppFontSize.sizeStatus,
                                      color: AppColor.successQRCode,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${AppLanguage.getText('ChuaCheckin')}: ${widget.user.chuaCheckin ?? 0}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: AppFontSize.sizeStatus,
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
