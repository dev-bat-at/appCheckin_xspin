import 'package:checkin/app/app_language.dart';
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

  void _showAutoCheckinUpgradeDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFE58A2C),
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                AppLanguage.getText('NangCapGoiChuyenNghiep'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF7A1621),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLanguage.getText('ThongBaoNangCapGoi'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    AppLanguage.getText('DaHieu'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          title: AppLanguage.getText('DanhMuc'),
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
                                Text(
                                  AppLanguage.getText('TrungTamDieuHuong'),
                                  style: const TextStyle(
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
                                      AppLanguage.getText('LineHienTai'),
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
                                  child: Text(AppLanguage.getText('DoiLine')),
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
                    AppLanguage.getText('TacVuChinh'),
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
                  title: AppLanguage.getText('ThongTinSuKien'),
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
                  title: AppLanguage.getText('ThongKe'),
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
                  title: AppLanguage.getText('CheckinTuDong'),
                  accentColor: const Color(0xFF127A67),
                  backgroundColor: const Color(0xFFF1FBF8),
                  onTap: () async {
                    await widget.loginViewModel.loadUser();
                    if (!mounted) {
                      return;
                    }
                    if (AppSP.get(AppSPKey.isCheckinTuDong) != '1') {
                      _showAutoCheckinUpgradeDialog();
                      return;
                    }
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    AppLanguage.getText('TaiKhoan'),
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
                  title: AppLanguage.getText('DangXuat'),
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
  });

  final IconData icon;
  final String title;
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
