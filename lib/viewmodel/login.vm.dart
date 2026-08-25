import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:checkin/app/app_language.dart';
import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/constants/app_color.dart';
import 'package:checkin/model/login.model.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/requests/login.request.dart';
import 'package:checkin/requests/qrcode.request.dart';
import 'package:checkin/services/api_services.dart';
import 'package:checkin/viewmodel/index.vm.dart';
import 'package:checkin/views/auth/line_selection.page.dart';
import 'package:checkin/views/auth/sign_in.dart';
import 'package:checkin/views/index/index.page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  late BuildContext viewContext;
  bool _obscureText = true;
  LoginRequest loginRequest = LoginRequest();
  bool get obscureText => _obscureText;
  final apiService = ApiService();
  late IndexViewModel indexViewModel;
  Login? data;
  Users? userdata;
  QRCodeRequest qrCodeRequest = QRCodeRequest();

  late Login responseLogin;
  Login? userLogin;

  void showhidePassword() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  Future<void> loadQrCode(String maQR) async {
    setBusy(true);
    userdata = await qrCodeRequest.getUser(
        idSuKien: AppSP.get(AppSPKey.idSuKien), maQR: maQR);
    print('data tới chơi nè ${userdata!.lichSuCheckin!.length}');
    setBusy(false);
    notifyListeners();
  }

  Future<Login?> loadUser() async {
    setBusy(true);
    userLogin = await loginRequest.getUsers(
        tenSK: AppSP.get(AppSPKey.tenTK), mkSK: AppSP.get(AppSPKey.password));
    if (userLogin != null) {
      await AppSP.set(
          AppSPKey.isCheckinTuDong, userLogin!.isCheckinTuDong ?? '');
      await AppSP.set(
          AppSPKey.isCheckinThuCong, userLogin!.isCheckinThuCong ?? '');
    }

    setBusy(false);
    notifyListeners();
    return userLogin;
  }

  Future<void> showSignInSuccessDialog(
      BuildContext context, String tenSK, String mkSK) async {
    setBusy(true);
    try {
      data = await loginRequest.login(tenSK: tenSK, mkSK: mkSK);

      if (data != null) {
        await AppSP.set(AppSPKey.tenTK, tenSK);
        await AppSP.set(AppSPKey.password, mkSK);
        await AppSP.set(AppSPKey.idSuKien, data!.idSuKien);
        await AppSP.set(AppSPKey.loaiCheckin, data!.loaiCheckin ?? '');
        await AppSP.set(AppSPKey.isNhieuLine, data!.isNhieuLine ?? '');
        await AppSP.set(AppSPKey.isCheckinTuDong, data!.isCheckinTuDong ?? '');
        await AppSP.set(
            AppSPKey.isCheckinThuCong, data!.isCheckinThuCong ?? '');
        await AppSP.set(AppSPKey.idLineCheckin, '');
        await AppSP.set(AppSPKey.tenLineCheckin, '');
        await AppLanguage.fetchLanguages(data!.idSuKien);
        print('Loại checkin ${AppSP.get(AppSPKey.loaiCheckin)}');
        print('${AppSP.get(AppSPKey.idSuKien)}');

        final nextPage = data!.isNhieuLine == '1'
            ? const LineSelectionPage()
            : const IndexPage();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        // Show error message when login fails
        showSignInFailedDialog(
            context, 'Account does not exist or password is incorrect');
      }
    } catch (e) {
      print('Login failed: $e');
      // print('${Api.hostApi}${Api.login}');
      showSignInFailedDialog(
          context, 'An error occurred during login, please try again later');
    }
    setBusy(false);
    notifyListeners();
  }

  void showLogOut(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: AppLanguage.getText('ThongBao'),
      desc: AppLanguage.getText('BanCoMuonDangXuat'),
      btnCancelOnPress: () {},
      btnCancelText: AppLanguage.getText('Huy'),
      btnOkOnPress: () {
        AppSP.set(AppSPKey.tenTK, '');
        AppSP.set(AppSPKey.password, '');
        AppSP.set(AppSPKey.idSuKien, '');
        AppSP.set(AppSPKey.loaiCheckin, '');
        AppSP.set(AppSPKey.isNhieuLine, '');
        AppSP.set(AppSPKey.isCheckinTuDong, '');
        AppSP.set(AppSPKey.isCheckinThuCong, '');
        AppSP.set(AppSPKey.idLineCheckin, '');
        AppSP.set(AppSPKey.tenLineCheckin, '');
        print('ID: ${AppSP.get(AppSPKey.tenTK)}');
        print('Passs: ${AppSP.get(AppSPKey.password)}');
        print('Passs: ${AppSP.get(AppSPKey.idSuKien)}');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInView()),
        );
      },
      btnOkText: AppLanguage.getText('Co'),
    ).show();
  }

  void showSignInFailedDialog(BuildContext context, String desc) {
    AwesomeDialog(
      context: viewContext,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: AppLanguage.getText('DangNhapThatBai'),
      desc: desc,
      btnOkColor: AppColor.selectColor,
      btnOkOnPress: () {},
      btnOkText: AppLanguage.getText('ThuLai'),
    ).show();
  }
}
