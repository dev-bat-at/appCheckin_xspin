import 'package:checkin/viewmodel/qr_code.vm.dart';
import 'package:flutter/material.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/base/nav_bar.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:stacked/stacked.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late IndexViewModel indexViewModel;
  @override
  void initState() {
    super.initState();
    indexViewModel = IndexViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IndexViewModel>.reactive(
      viewModelBuilder: () => indexViewModel,
      builder: (context, viewModel, child) => BasePage(
        showAppBar: false,
        body: IndexedStack(
          index: viewModel.currentIndex,
          children: viewModel.getPages(),
        ),
        bottomNav: HomeNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTabSelected: (index) => viewModel.setIndex(index),
        ),
      ),
    );
  }
}
