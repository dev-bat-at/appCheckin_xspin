import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/viewmodel/login.vm.dart';
import 'package:checkin/views/auth/line_selection.page.dart';
import 'package:checkin/views/auth/profile/profile.page.dart';
import 'package:checkin/views/qr_code/auto_checkin.page.dart';
import 'package:checkin/views/statistics/statistics.page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    super.key,
    required this.indexViewModel,
    required this.loginViewModel,
  });

  final IndexViewModel indexViewModel;
  final LoginViewModel loginViewModel;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<void> _openLineSelection() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LineSelectionPage(allowBack: true),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.loginViewModel,
      builder: (context, viewModel, child) {
        final currentLine = AppSP.get(AppSPKey.tenLineCheckin) ?? '';
        final canChangeLine = AppSP.get(AppSPKey.isNhieuLine) == '1';
        const menuBackground = Color(0xFFF8F3F1);
        const deepRose = Color(0xFF7A1621);

        return BasePage(
          title: 'Danh Mục',
          showLogo: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  menuBackground,
                  Colors.white,
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor,
                        deepRose,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withValues(alpha: 0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.dashboard_customize_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Trung tâm điều hướng',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (currentLine.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.alt_route_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Line hiện tại',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentLine,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (canChangeLine)
                                TextButton(
                                  onPressed: _openLineSelection,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.12),
                                  ),
                                  child: const Text('Đổi line'),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Tác vụ chính',
                    style: TextStyle(
                      color: deepRose,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.info_outline,
                  title: 'Thông tin sự kiện',
                  accentColor: AppColor.primaryColor,
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          indexViewModel: widget.indexViewModel,
                          loginViewModel: widget.loginViewModel,
                        ),
                      ),
                    );
                  },
                ),
                _MenuCard(
                  icon: Icons.query_stats,
                  title: 'Thống kê',
                  accentColor: const Color(0xFFE58A2C),
                  backgroundColor: const Color(0xFFFFF8EF),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StatisticsPage(),
                      ),
                    );
                  },
                ),
                _MenuCard(
                  icon: Icons.qr_code_scanner_outlined,
                  title: 'Check-in tự động',
                  accentColor: const Color(0xFF127A67),
                  backgroundColor: const Color(0xFFF1FBF8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AutoCheckinPage(
                          indexViewModel: widget.indexViewModel,
                        ),
                      ),
                    );
                  },
                ),
                // if (canChangeLine)
                //   _MenuCard(
                //     icon: Icons.sync_alt_rounded,
                //     title: 'Đổi line check-in',
                //     subtitle: currentLine.isEmpty
                //         ? 'Chọn line hoạt động hiện tại'
                //         : 'Đang dùng $currentLine',
                //     accentColor: deepRose,
                //     backgroundColor: softRose,
                //     onTap: _openLineSelection,
                //   ),
                // const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Tài khoản',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  accentColor: Colors.redAccent,
                  backgroundColor: const Color(0xFFFFF3F2),
                  onTap: () => widget.loginViewModel.showLogOut(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.accentColor,
    required this.backgroundColor,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color accentColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColor.extraColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
