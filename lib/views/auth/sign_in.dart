import 'package:flutter/material.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:checkin/views/auth/widget/button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart'; // Thêm package

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final Uri _url = Uri.parse('https://xspin.vn/dieu-khoan-su-dung');
  String _appVersion = '1.0.0'; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _getAppVersion(); // Lấy version khi khởi tạo
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version; // Lấy version từ packageInfo
    });
  }

  Future<void> launchURL() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColor.primaryColor,
            body: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                decoration: BoxDecoration(
                  color: AppColor.extraColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(5, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Logo
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                      Image.asset(
                        'assets/LOGO_CHECK_IN_XSPIN.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                      // Login Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Đăng Nhập Hệ Thống',
                                style: TextStyle(
                                  fontSize: AppFontSize.sizeLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.selectColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: launchURL,
                                child: Text(
                                  'Điều khoản sử dụng',
                                  style: TextStyle(
                                    fontSize: AppFontSize.sizeSuperSmall,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  'assets/logo_qr.jpg',
                                  width: MediaQuery.of(context).size.width * 0.095,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      // Email Field
                      TextField(
                        controller: viewModel.username,
                        decoration: InputDecoration(
                          hintText: 'Mã sự kiện',
                          filled: true,
                          fillColor: AppColor.extraColor,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                'assets/barcode.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Password Field
                      TextField(
                        controller: viewModel.password,
                        obscureText: viewModel.obscureText,
                        decoration: InputDecoration(
                          hintText: 'Mật khẩu',
                          filled: true,
                          fillColor: AppColor.extraColor,
                          suffixIcon: Icon(
                            Icons.lock,
                            color: AppColor.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      // Login and Register buttons
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ButtonCustom(
                            onPressed: () {
                              viewModel.isBusy
                                  ? Center(
                                      child: LoadingAnimationWidget
                                          .threeRotatingDots(
                                        color: AppColor.primaryColor,
                                        size: 50,
                                      ),
                                    )
                                  : viewModel.showSignInSuccessDialog(
                                      context,
                                      viewModel.username.text,
                                      viewModel.password.text);
                            },
                            nameButton: 'Đăng nhập',
                            color: AppColor.primaryColor,
                            colorName: AppColor.extraColor),
                      ),
                      SizedBox(height: 10),
                      // Version Text
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                          child: Text(
                            'Phiên bản $_appVersion',
                            style: TextStyle(
                              fontSize: AppFontSize.sizeSuperSmall,
                              color: Colors.black,
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
        });
  }
}