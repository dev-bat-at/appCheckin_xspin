import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:flutter/material.dart';
import 'package:checkin/constants/app_color.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });
  final int currentIndex;
  final Future<void> Function(int) onTabSelected;

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.transparent
                .withOpacity(0.1), // Hoặc màu mong muốn cho gạch ngang
            width: 1.0, // Độ rộng của gạch ngang
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.extraColor,
        currentIndex: widget.currentIndex,
        fixedColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.darkColor,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
        onTap: (index) async {
          await widget.onTabSelected(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: AppSP.get(AppSPKey.loaiCheckin) == 'NL'
                ? 'Người tham dự'
                : 'Người tham dự',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: AppColor.selectColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Icon(
                  Icons.qr_code,
                  color: Colors.white, // Màu của icon
                  size: 30.0, // Kích thước icon
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded, size: 24),
            label: 'Danh mục',
          ),
        ],
      ),
    );
  }
}
