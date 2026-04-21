import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_user_checkin.vm.dart';
import 'package:checkin/views/history1/widgets/item.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ListUserCheckin extends StatefulWidget {
  final HistoryCheckinViewModel usersViewModel;
  final List<Users> users;
  ListUserCheckin(
      {super.key, required this.usersViewModel, required this.users});

  @override
  State<ListUserCheckin> createState() => _ListUserCheckinState();
}

class _ListUserCheckinState extends State<ListUserCheckin> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.usersViewModel,
      onViewModelReady: (viewModel) {
        viewModel.viewContext = context;
      },
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(widget.users.length, (index) {
                return ItemTicket(
                  onTap: () {
                    viewModel.detailUser = widget.users[index];
                    viewModel.viewContext = context;
                    viewModel.nextDetailTicket();
                  },
                  usersViewModel: viewModel,
                  user: widget.users[index],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
