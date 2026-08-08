import 'dart:async';

import 'package:checkin/app/app_language.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_user_checkin.vm.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/views/history1/widgets/list.widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class HistoryPage1 extends StatefulWidget {
  final HistoryCheckinViewModel usersViewModel;
  final IndexViewModel indexViewModel;
  const HistoryPage1(
      {super.key, required this.usersViewModel, required this.indexViewModel});

  @override
  State<HistoryPage1> createState() => _HistoryPage1State();
}

class _HistoryPage1State extends State<HistoryPage1>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  late TabController _tabController;
  Timer? _searchDebounce;
  bool _isScrollToTopButtonVisible = false;

  List<bool> _scrollStates = [false, false, false];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    // Lắng nghe sự thay đổi của _searchController và gọi API khi người dùng nhập
    _searchController.addListener(() {
      _onSearchChanged();
    });

    _scrollController.addListener(_scrollListener);

    _tabController.addListener(() {
      // Cập nhật trạng thái của nút khi chuyển tab
      setState(() {
        _isScrollToTopButtonVisible = _scrollStates[_tabController.index];
      });
    });
  }

  void _scrollListener() {
    bool isScrolled = _scrollController.offset >= 200;
    _scrollStates[_tabController.index] = isScrolled;

    if (isScrolled && !_isScrollToTopButtonVisible) {
      setState(() {
        _isScrollToTopButtonVisible = true;
      });
    } else if (!isScrolled && _isScrollToTopButtonVisible) {
      setState(() {
        _isScrollToTopButtonVisible = false;
      });
    }
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      widget.usersViewModel.updateSearchQuery(_searchController.text);

      if (_searchController.text.isEmpty) {
        widget.usersViewModel.resetPagination();
      }

      widget.usersViewModel.getUsers();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await AppLanguage.refreshLanguages();
    setState(() {});
    await widget.usersViewModel.reloadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.usersViewModel,
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
          await viewModel.init();
        },
        builder: (context, viewModel, child) {
          viewModel.viewContext = context;

          return DefaultTabController(
            length: 3, // Số lượng Tab
            child: BasePage(
              showFloating: true,
              showLogo: true,
              floating: _isScrollToTopButtonVisible
                  ? FloatingActionButton(
                      onPressed: () {
                        _scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Icon(
                        Icons.arrow_upward,
                        color: AppColor.darkColor,
                        size: 28,
                      ),
                      backgroundColor: AppColor.unSelectColor.withOpacity(0.5),
                    )
                  : null,
              title: AppLanguage.getText('NguoiThamDu'),
              body: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppColor.primaryColor,
                child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 64,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: AppColor.primaryColor,
                        labelColor: AppColor.darkColor,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8),
                        tabs: [
                          Tab(
                              height: 64,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLanguage.getText('TatCa'),
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  viewModel.isBusy
                                      ? LoadingAnimationWidget.progressiveDots(
                                          color: Colors.orange,
                                          size: 15,
                                        )
                                      : Text(
                                          '(${widget.usersViewModel.count?.countData})',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              )),
                          Tab(
                            height: 64,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLanguage.getText('DaCheckin'),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: _tabController.index == 1
                                          ? AppColor.darkColor
                                          : Colors.grey[700],
                                      fontWeight: _tabController.index == 1
                                          ? FontWeight.bold
                                          : null),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                viewModel.isBusy
                                    ? LoadingAnimationWidget.progressiveDots(
                                        color: AppColor.successQRCode,
                                        size: 15,
                                      )
                                    : Text(
                                        '(${widget.usersViewModel.countCheckin?.countData})',
                                        style: TextStyle(
                                          color: AppColor.successQRCode,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Tab(
                            height: 64,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Chưa Checkin',
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4),
                                viewModel.isBusy
                                    ? LoadingAnimationWidget.progressiveDots(
                                        color: AppColor.primaryColor,
                                        size: 15,
                                      )
                                    : Text(
                                        '(${(widget.usersViewModel.count?.countData ?? 0) - (widget.usersViewModel.countCheckin?.countData ?? 0)})',
                                        style: TextStyle(
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: 'Tìm kiếm theo tên hoặc mã QR',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.primaryColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.primaryColor,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )),
                      ),
                    ),
                    viewModel.isBusy
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.2),
                            child: Center(
                              child: LoadingAnimationWidget.threeRotatingDots(
                                color: AppColor.primaryColor,
                                size: 50,
                              ),
                            ),
                          )
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _tabController.index == 0
                                ? buildUserList(viewModel.lstUsers, 'allTab')
                                : _tabController.index == 1
                                    ? buildUserList(
                                        viewModel.checkInUser, 'checkedInTab')
                                    : buildUserList(viewModel.notCheckIntUser,
                                        'notCheckedInTab'),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildUserList(List<Users> users, String tabKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // key: PageStorageKey(tabKey),
      children: [
        ListUserCheckin(
          usersViewModel: widget.usersViewModel,
          users: users,
        ),
        if (users.length >= 10) // Giả sử mỗi trang trả về tối đa 10 người dùng
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: widget.usersViewModel.isLoadingMoreAll &&
                            tabKey == 'allTab' ||
                        widget.usersViewModel.isLoadingMoreCheckedIn &&
                            tabKey == 'checkedInTab' ||
                        widget.usersViewModel.isLoadingMoreNotCheckedIn &&
                            tabKey == 'notCheckedInTab'
                    ? CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await widget.usersViewModel.loadMoreUsers(tabKey);
                          },
                          child: Text(
                            "Xem thêm",
                            style: TextStyle(
                                color: AppColor.extraColor,
                                fontSize: AppFontSize.sizeSuperSmall),
                          ),
                        ),
                      )),
          ),
      ],
    );
  }
}
