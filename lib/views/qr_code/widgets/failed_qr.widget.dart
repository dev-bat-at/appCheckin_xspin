import 'dart:async';

import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:flutter/material.dart';

class FailedQrCode extends StatefulWidget {
  final QRCodeViewModel qrCodeViewModel;
  final String title;
  final String desc;
  FailedQrCode(
      {super.key,
      required this.qrCodeViewModel,
      required this.title,
      required this.desc});

  @override
  State<FailedQrCode> createState() => _FailedQrCodeState();
}

class _FailedQrCodeState extends State<FailedQrCode> {
  Future<void> _onContinuePressed() async {
    if (mounted) {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                // Decorative icon
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: AppColor.primaryColor.withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSize.sizeSuperLarge,
                    fontWeight: FontWeight.w900,
                    color: AppColor.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  widget.desc,
                  textAlign: TextAlign.center,
                  softWrap: true, // Allow text to wrap
                  style: TextStyle(
                    fontSize: AppFontSize.sizeMedium,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryColor.withOpacity(0.7),
                    height: 1.5, // Improve readability
                  ),
                ),
                const SizedBox(height: 40),
                // Continue Button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor,
                        AppColor.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _onContinuePressed,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(
                          0), // Elevation handled by boxShadow
                    ),
                    child: Text(
                      "TIẾP TỤC CHECK IN",
                      style: TextStyle(
                        fontSize: AppFontSize.sizeMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
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
