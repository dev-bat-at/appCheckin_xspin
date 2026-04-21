import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Trang chủ',
      body: Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: AppColor.primaryColor,
          size: 50,
          
        ),
      ),
    );
  }
}
