import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';

class CustomMenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const CustomMenuButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.extraColor, // Màu nền của nút
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColor.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColor.darkColor,
                  fontSize: AppFontSize.sizeSmall,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColor.primaryColor),
          ],
        ),
      ),
    );
  }
}
