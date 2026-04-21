import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:checkin/constants/app_fontsize.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  String nameButton;
  final Color color;
  final Color colorName;
  ButtonCustom(
      {super.key,
      required this.onPressed,
      required this.nameButton,
      required this.color,
      required this.colorName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(
        nameButton,
        style: TextStyle(fontSize: AppFontSize.sizeSmall, color: colorName),
        textAlign: TextAlign.center,
      ),
    );
  }
}
