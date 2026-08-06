import 'package:flutter/material.dart';
import 'package:checkin/app/app_language.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class ProfilePage extends StatefulWidget {
  final IndexViewModel indexViewModel;
  final LoginViewModel loginViewModel;

  const ProfilePage(
      {super.key, required this.indexViewModel, required this.loginViewModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _refreshData() async {
    await widget.loginViewModel.loadUser();
    await _loadCounters();
  }

  bool isExpanded = false;

  Future<void> _loadCounters() async {
    if (AppSP.get(AppSPKey.loaiCheckin) == '1L') {
      await widget.indexViewModel.historyViewModel.getCountUser();
      await widget.indexViewModel.historyViewModel.getCountUserCheckIn();
      return;
    }

    await widget.indexViewModel.usersViewModel.getCountUser();
    await widget.indexViewModel.usersViewModel.getCountUserCheckIn();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.loginViewModel,
      onViewModelReady: (viewModel) {
        viewModel.viewContext = context;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) {
            return;
          }
          await viewModel.loadUser();
          await _loadCounters();
        });
      },
      builder: (context, viewModel, child) {
        final isSingleLine = AppSP.get(AppSPKey.loaiCheckin) == '1L';
        final totalCheckin = isSingleLine
            ? widget.indexViewModel.historyViewModel.countCheckin?.countData
            : widget.indexViewModel.usersViewModel.countCheckin?.countData;
        final totalUsers = isSingleLine
            ? widget.indexViewModel.historyViewModel.count?.countData
            : widget.indexViewModel.usersViewModel.count?.countData;

        return BasePage(
          title: AppLanguage.getText('ThongTin'),
          showLogout: true,
          showLogo: true,
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColor.primaryColor,
            child: ListView(children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        AppLanguage.getText('SoLuotDaCheckin'),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppFontSize.sizeLarge),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${totalCheckin ?? 0}',
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeTitle,
                                  color: AppColor.successQRCode,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '/',
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeTitle,
                                  color: AppColor.darkColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${totalUsers ?? 0}',
                              style: TextStyle(
                                  fontSize: AppFontSize.sizeTitle,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLanguage.getText('MaKhachHang'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.sizeSmall,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                                color:
                                    AppColor.extraColor.withValues(alpha: 0.85),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                    leading: const Icon(Icons.account_circle),
                                    title: Text(
                                        viewModel.userLogin?.maKhachHang ??
                                            ''))),
                            SizedBox(height: 10),
                            Text(
                              AppLanguage.getText('MaSuKien'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.sizeSmall,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                                color:
                                    AppColor.extraColor.withValues(alpha: 0.85),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                    leading: const Icon(Icons.account_circle),
                                    title:
                                        Text('${AppSP.get(AppSPKey.tenTK)}'))),
                            SizedBox(height: 10),
                            Text(
                              AppLanguage.getText('TenSuKien'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.sizeSmall,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                                color:
                                    AppColor.extraColor.withValues(alpha: 0.85),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                      Icons.label_important_outline_sharp),
                                  title: viewModel
                                              .userLogin?.tenSukien?.isEmpty ??
                                          true
                                      ? LoadingAnimationWidget
                                          .threeRotatingDots(
                                          color: AppColor.primaryColor,
                                          size: 50,
                                        )
                                      : Text(
                                          viewModel.userLogin?.tenSukien ?? ''),
                                )),
                            if ((AppSP.get(AppSPKey.tenLineCheckin) ?? '')
                                .isNotEmpty) ...[
                              SizedBox(height: 10),
                              Text(
                                AppLanguage.getText('LineCheckin'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSize.sizeSmall,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Card(
                                color:
                                    AppColor.extraColor.withValues(alpha: 0.85),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.alt_route),
                                  title:
                                      Text(AppSP.get(AppSPKey.tenLineCheckin)!),
                                  subtitle: Text(
                                    'ID Line: ${AppSP.get(AppSPKey.idLineCheckin) ?? ''}',
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: 10),
                            Text(
                              AppLanguage.getText('ThoiGianCheckin'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.sizeSmall,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              color:
                                  AppColor.extraColor.withValues(alpha: 0.85),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                        Icons.calendar_month_outlined),
                                    title: Text(
                                        viewModel.userLogin?.ngayDienRa ?? ''),
                                  ),
                                  const Divider(height: 1),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLanguage.getText('DiaDiem'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSize.sizeSmall,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              color:
                                  AppColor.extraColor.withValues(alpha: 0.85),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.location_on),
                                    title: Text(
                                        viewModel.userLogin?.diaDiem ?? ''),
                                  ),
                                  const Divider(height: 1),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 10),
                            // Center(
                            //   child: SizedBox(
                            //     width: MediaQuery.of(context).size.width * 0.5,
                            //     child: ButtonCustom(
                            //       onPressed: () {
                            //         viewModel.showLogOut(context);
                            //       },
                            //       nameButton: 'Đăng xuất',
                            //       color: AppColor.primaryColor,
                            //       colorName: AppColor.extraColor,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
