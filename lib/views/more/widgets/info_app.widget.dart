import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';

class InfoApp extends StatelessWidget {
  const InfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Thông tin ứng dụng',
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phiên bản ứng dụng",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      fontWeight: AppFontWeight.bold),
                ),
                Text(
                  "1.0",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      color: AppColor.unSelectColor),
                )
              ],
            ),
            Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nhà phát triển ứng dụng",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      fontWeight: AppFontWeight.bold),
                ),
                Text(
                  "XEP",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      color: AppColor.primaryColor),
                )
              ],
            ),
            Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Website",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      fontWeight: AppFontWeight.bold),
                ),
                Text(
                  "xep.vn",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      color: AppColor.primaryColor),
                )
              ],
            ),
            Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Số điện thoại",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      fontWeight: AppFontWeight.bold),
                ),
                Text(
                  "096 899 6877",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      color: AppColor.primaryColor),
                )
              ],
            ),
            Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Địa chỉ Email",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      fontWeight: AppFontWeight.bold),
                ),
                Text(
                  "info@xep.vn",
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      color: AppColor.primaryColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
