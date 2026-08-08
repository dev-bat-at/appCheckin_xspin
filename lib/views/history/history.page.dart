import 'dart:async';

import 'package:checkin/app/app_language.dart';
import 'package:checkin/constants/app_fontsize.dart';
import 'package:checkin/model/user.model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:checkin/base/base_page.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/viewmodel/history_users.vm.dart';
import 'package:checkin/views/history/widgets/list.widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

class HistoryPage extends StatefulWidget {
  final UsersViewModel usersViewModel;
  final IndexViewModel indexViewModel;
  const HistoryPage(
      {super.key, required this.usersViewModel, required this.indexViewModel});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
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
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.jumpTo;
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
    _scrollController.offset;
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      widget.usersViewModel.updateSearchQuery(_searchController.text);

      if (_searchController.text.isEmpty) {
        widget.usersViewModel.resetPagination();
      }

      if (widget.usersViewModel.selectedStatus == 'all') {
        widget.usersViewModel.getUsers();
      } else {
        widget.usersViewModel
            .getUsersByStatus(widget.usersViewModel.selectedStatus);
      }
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
            length: 2,
            child: BasePage(
              showLogo: true,
              showFloating: true,
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
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(
                            color: AppColor.oriColor
                                .withOpacity(0.5), // Đường viền bảng
                            width: 1,
                            borderRadius: BorderRadius.circular(20)),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                                color: AppColor.successQRCode,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            children: [
                              _buildCell(AppLanguage.getText('TongLuot'),
                                  AppColor.extraColor),
                              _buildCell(AppLanguage.getText('DaCheckin'),
                                  AppColor.extraColor),
                              _buildCell(AppLanguage.getText('ChuaCheckin'),
                                  AppColor.extraColor),
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(
                                child: viewModel.isBusy
                                    ? LoadingAnimationWidget.progressiveDots(
                                        color: AppColor.oriColor,
                                        size: 15,
                                      )
                                    : Text(
                                        '${widget.usersViewModel.count?.countData ?? 0}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: AppFontSize.sizeTable,
                                          color: AppColor.oriColor,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                              ),
                              Center(
                                child: viewModel.isBusy
                                    ? LoadingAnimationWidget.progressiveDots(
                                        color: AppColor.successQRCode,
                                        size: 15,
                                      )
                                    : Text(
                                        '${widget.usersViewModel.countCheckin?.countData ?? 0}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: AppFontSize.sizeTable,
                                          color: AppColor.successQRCode,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: viewModel.isBusy
                                      ? LoadingAnimationWidget.progressiveDots(
                                          color: AppColor.primaryColor,
                                          size: 15,
                                        )
                                      : Text(
                                          '${(widget.usersViewModel.count?.countData ?? 0) - (widget.usersViewModel.countCheckin?.countData ?? 0)}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: AppFontSize.sizeTable,
                                            color: AppColor.primaryColor,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColor.primaryColor,
                      labelColor: AppColor.darkColor,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                      tabs: [
                        Tab(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  AppLanguage.getText('NguoiThamDu'),
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                                Center(
                                  child: viewModel.isBusy
                                      ? LoadingAnimationWidget.progressiveDots(
                                          color: viewModel.selectedStatus ==
                                                  'DaCheckinXong'
                                              ? AppColor.successQRCode
                                              : AppColor.oriColor,
                                          size: 15,
                                        )
                                      : Text(
                                          '(${widget.usersViewModel.countUser?.countData ?? 0})',
                                          style: TextStyle(
                                            color: viewModel.selectedStatus ==
                                                    'DaCheckinXong'
                                                ? AppColor.successQRCode
                                                : AppColor.oriColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ],
                        )),
                        Tab(
                          child: Text(
                            AppLanguage.getText('LichSuCheckin'),
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (_tabController.index == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                // width: MediaQuery.of(context).size.width / 2.5,
                                height: 40,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                      hintText: AppLanguage.getText('TimKiem'),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                        horizontal: 10.0,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColor.primaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColor.primaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                        },
                                      )),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                height: 40,
                                // width: MediaQuery.of(context).size.width * 0.55,
                                child: DropdownButtonFormField2<String>(
                                  isExpanded: true,
                                  alignment: Alignment.centerLeft,
                                  isDense: true,
                                  // iconStyleData: IconStyleData(iconSize: 15),
                                  value: widget.usersViewModel.selectedStatus,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      // horizontal: 8.0,
                                    ),
                                    fillColor: AppColor.extraColor,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: 'all',
                                      child: Text(
                                        AppLanguage.getText('TatCa'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.darkColor,
                                        ),
                                      ),
                                    ),
                                    // Map các giá trị từ viewModel.userStatus
                                    ...viewModel.userStatus.map((status) {
                                      return DropdownMenuItem<String>(
                                        value: status.idStatus,
                                        child: Text(
                                          AppLanguage.getText(
                                            status.idStatus ?? '',
                                            fallback: status.nameStatus,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.darkColor,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (value) {
                                    if (value == 'all') {
                                      viewModel.isBusy
                                          ? CircularProgressIndicator(
                                              color: AppColor.primaryColor,
                                            )
                                          : widget.usersViewModel.getUsers();
                                      widget.usersViewModel
                                          .getCountUserJoin('');
                                    } else {
                                      viewModel.isBusy
                                          ? CircularProgressIndicator(
                                              color: AppColor.primaryColor,
                                            )
                                          : widget.usersViewModel
                                              .getUsersByStatus(value);
                                      widget.usersViewModel
                                          .getCountUserJoin(value);
                                    }
                                    setState(() {
                                      widget.usersViewModel
                                          .updateSelectedStatus(value!);
                                    });
                                    print(
                                        'Nhấn trạng thái : ${widget.usersViewModel.selectedStatus}');
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 40,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                hintText: AppLanguage.getText('TimKiem'),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )),
                          ),
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
                                : buildUserList(
                                    viewModel.checkInUser, 'checkedInTab'),
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
      children: [
        QRCodeHistoryList(
          usersViewModel: widget.usersViewModel,
          users: users,
        ),
        if (users.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
                child: widget.usersViewModel.isLoadingMoreAll &&
                            tabKey == 'allTab' ||
                        widget.usersViewModel.isLoadingMoreCheckedIn &&
                            tabKey == 'checkedInTab'
                    ? CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      )
                    : widget.usersViewModel.hasMoreData(tabKey)
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await widget.usersViewModel
                                    .loadMoreUsers(tabKey);
                              },
                              child: Text(
                                AppLanguage.getText('XemThem'),
                                style: TextStyle(
                                    color: AppColor.extraColor,
                                    fontSize: AppFontSize.sizeSuperSmall),
                              ),
                            ),
                          )
                        : SizedBox.shrink()),
          ),
      ],
    );
  }
}

Widget _buildCell(String text, Color color) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: 'Inter',
          fontSize: AppFontSize.sizeSmall,
          fontWeight: FontWeight.bold,
          color: color),
    ),
  );
}
