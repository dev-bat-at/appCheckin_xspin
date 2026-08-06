import 'package:checkin/app/app_language.dart';
import 'package:flutter/material.dart';
import 'package:checkin/base/base_page.dart';
import 'package:checkin/views/more/widgets/custombutton.widget.dart';
import 'package:checkin/views/more/widgets/info_app.widget.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
        title: AppLanguage.getText('Khac'),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              CustomMenuButton(
                  icon: Icons.info,
                  text: AppLanguage.getText('ThongTinUngDung'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InfoApp()),
                    );
                  }),
              CustomMenuButton(
                  icon: Icons.share,
                  text: AppLanguage.getText('ChiaSeUngDung'),
                  onTap: () {}),
            ],
          ),
        ));
  }
}
