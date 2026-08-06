import 'package:checkin/app/app_language.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_users.vm.dart';
import 'package:flutter/material.dart';

class ItemTicketQR extends StatefulWidget {
  // final String? qrCodeUrl;

  final VoidCallback onTap;
  final Users user;
  UsersViewModel usersViewModel;
  ItemTicketQR(
      {super.key,
      // this.qrCodeUrl,
      required this.onTap,
      required this.user,
      required this.usersViewModel});

  @override
  State<ItemTicketQR> createState() => _ItemTicketQRState();
}

class _ItemTicketQRState extends State<ItemTicketQR> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
          elevation: 2,
          color: AppColor.extraColor,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.user.maQR == ''
                          ? Text(
                              widget.user.maQR,
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeSuperSmall,
                                  color: AppColor.darkColor,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          : (widget.user.maQR.length > 20
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  child: Text(
                                    widget.user.maQR,
                                    style: TextStyle(
                                      fontSize: AppFontSize.sizeSuperSmall,
                                      fontWeight: AppFontWeight.bold,
                                      color: AppColor.darkColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 15.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.usersViewModel.selectedStatus ==
                                            'all'
                                        ? (widget.user.maTinhTrang ==
                                                'DaCheckinXong'
                                            ? AppColor.successQRCode
                                            : AppColor.oriColor)
                                        : (widget.usersViewModel.selectedStatus ==
                                                'DaCheckinXong'
                                            ? AppColor.successQRCode
                                            : AppColor.oriColor),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    widget.user.maQR,
                                    style: TextStyle(
                                      fontWeight: AppFontWeight.bold,
                                      color: AppColor.extraColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.user.field2!,
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
                  child: widget.user.thoiDiemCheckin != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppLanguage.getText('DaCheckin'),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeSuperSmall,
                                  color: AppColor.successQRCode,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ), // widget.user.thoiDiemCheckin != ''
                            Text(
                              widget.user.thoiDiemCheckin!,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: AppColor.successQRCode,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${AppLanguage.getText('LuotCheckinToiDa')}: ${widget.user.soLuotCheckIntoida}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeStatus,
                                  color: AppColor.oriColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${AppLanguage.getText('DaCheckin')}: ${widget.user.dacheckIn}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeStatus,
                                  color: AppColor.successQRCode,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${AppLanguage.getText('ChuaCheckin')}: ${widget.user.chuaCheckin}',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeStatus,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          )),
    );
  }
}
