import 'package:checkin/model/user.model.dart';
import 'package:checkin/viewmodel/history_users.vm.dart';
import 'package:checkin/views/history/widgets/item.widget.dart';
import 'package:flutter/material.dart';

class QRCodeHistoryList extends StatefulWidget {
  final UsersViewModel usersViewModel;
  final List<Users> users;
  QRCodeHistoryList(
      {super.key, required this.usersViewModel, required this.users});

  @override
  State<QRCodeHistoryList> createState() => _QRCodeHistoryListState();
}

class _QRCodeHistoryListState extends State<QRCodeHistoryList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.users.length, (index) {
          return ItemTicketQR(
            onTap: () {
              widget.usersViewModel.detailUser = widget.users[index];
              widget.usersViewModel
                  .loadQrCode(widget.usersViewModel.detailUser!.maQR);
              widget.usersViewModel.viewContext = context;
              widget.usersViewModel.nextDetailTicket();
            },
            usersViewModel: widget.usersViewModel,
            user: widget.users[index],
          );
        }),
      ],
    );
  }
}
