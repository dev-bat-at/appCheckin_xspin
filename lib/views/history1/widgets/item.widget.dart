import 'package:checkin/constants/api.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_user_checkin.vm.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 15.0,
                    ),
                    decoration: BoxDecoration(
                      color: widget.user.tinhTrang == Api.DaCheckin
                          ? AppColor.successQRCode
                          : AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.user.maQR,
                      style: TextStyle(
                        fontWeight: AppFontWeight.bold,
                        color: AppColor.extraColor,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Hiển thị dấu ba chấm nếu chữ quá dài
                    ),
                  ),
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
              )),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.user.tinhTrang == Api.DaCheckin
                      ? Text(
                          'Đã checkin',
                          style: TextStyle(
                              fontSize: AppFontSize.sizeSuperSmall,
                              fontWeight: FontWeight.bold,
                              color: AppColor.successQRCode),
                        )
                      : Text(
                          'Chưa checkin',
                          style: TextStyle(
                              fontSize: AppFontSize.sizeSuperSmall,
                              fontWeight: FontWeight.bold,
                              color: AppColor.selectColor),
                        ),
                  Text(
                    widget.user.ngayCheckin!,
                    style: TextStyle(
                        color: AppColor.successQRCode,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ))
            ],
          ),
        ),
        // child: ListTile(
        //   title: Container(
        //     padding: const EdgeInsets.symmetric(
        //       vertical: 5.0,
        //       horizontal: 15.0,
        //     ),
        //     decoration: BoxDecoration(
        //       color: AppColor.successQRCode,
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     child: Text(
        //       widget.user.maQR,
        //       style: TextStyle(
        //         fontWeight: AppFontWeight.bold,
        //         color: AppColor.extraColor,
        //       ),
        //       overflow:
        //           TextOverflow.ellipsis, // Hiển thị dấu ba chấm nếu chữ quá dài
        //     ),
        //   ),
        //   subtitle: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       SizedBox(
        //         height: 10,
        //       ),
        //       widget.user.ngayCheckin != ''
        //           ? Text(
        //               widget.user.ngayCheckin!,
        //               overflow: TextOverflow.ellipsis,
        //             )
        //           : Text(
        //               'Chưa checkin',
        //               style: TextStyle(color: AppColor.selectColor),
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //       Text(
        //         widget.user.field2!,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //     ],
        //   ),
        //   trailing: Text(
        //     widget.user.tinhTrang == Api.DaCheckin
        //         ? "Đã checkin"
        //         : "Chưa checkin",
        //     style: TextStyle(
        //         fontSize: AppFontSize.sizeSuperSmall,
        //         color: widget.user.tinhTrang == Api.DaCheckin
        //             ? AppColor.successQRCode
        //             : AppColor.selectColor),
        //     overflow:
        //         TextOverflow.ellipsis, // Áp dụng tương tự cho phần trạng thái
        //   ),
        // ),
      ),
    );
  }
}
