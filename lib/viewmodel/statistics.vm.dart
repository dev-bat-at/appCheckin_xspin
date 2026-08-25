import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/model/statistics.model.dart';
import 'package:checkin/requests/login.request.dart';
import 'package:checkin/requests/statistics.request.dart';
import 'package:stacked/stacked.dart';

class StatisticsViewModel extends BaseViewModel {
  final StatisticsRequest _statisticsRequest = StatisticsRequest();
  final LoginRequest _loginRequest = LoginRequest();

  List<StatisticGroup> statistics = [];
  StatisticGroup? overview;
  List<StatisticGroup> groupedStatistics = [];

  bool get isSingleCheckin => AppSP.get(AppSPKey.loaiCheckin) == '1L';

  Future<void> loadStatistics() async {
    setBusy(true);
    try {
      await _syncCheckinConfiguration();

      statistics = await _statisticsRequest.getStatistics(
        idSuKien: AppSP.get(AppSPKey.idSuKien) ?? '',
        loaiCheckin: AppSP.get(AppSPKey.loaiCheckin) ?? '',
      );

      groupedStatistics = List<StatisticGroup>.from(
        statistics,
        growable: false,
      );

      // if (groupedStatistics.isNotEmpty) {
      //   overview = StatisticGroup(
      //     nhomThongKe: '',
      //     thongKe: StatisticSummary.sum(
      //       groupedStatistics.map((item) => item.thongKe),
      //     ),
      //   );
      // } else {
      //   overview = null;
      // }
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> _syncCheckinConfiguration() async {
    final tenTK = AppSP.get<String>(AppSPKey.tenTK) ?? '';
    final password = AppSP.get<String>(AppSPKey.password) ?? '';

    if (tenTK.isEmpty || password.isEmpty) {
      return;
    }

    final currentLoaiCheckin = AppSP.get<String>(AppSPKey.loaiCheckin) ?? '';
    final currentIsNhieuLine = AppSP.get<String>(AppSPKey.isNhieuLine) ?? '';
    final currentIdSuKien = AppSP.get<String>(AppSPKey.idSuKien) ?? '';

    final latestConfig = await _loginRequest.getUsers(
      tenSK: tenTK,
      mkSK: password,
    );

    if (latestConfig == null) {
      return;
    }

    final nextLoaiCheckin = latestConfig.loaiCheckin ?? '';
    final nextIsNhieuLine = latestConfig.isNhieuLine ?? '';
    final nextIsCheckinTuDong = latestConfig.isCheckinTuDong ?? '';
    final nextIdSuKien = latestConfig.idSuKien;

    final hasCheckinModeChanged = currentLoaiCheckin != nextLoaiCheckin ||
        currentIsNhieuLine != nextIsNhieuLine ||
        currentIdSuKien != nextIdSuKien;

    await AppSP.set(AppSPKey.idSuKien, nextIdSuKien);
    await AppSP.set(AppSPKey.loaiCheckin, nextLoaiCheckin);
    await AppSP.set(AppSPKey.isNhieuLine, nextIsNhieuLine);
    await AppSP.set(AppSPKey.isCheckinTuDong, nextIsCheckinTuDong);
    await AppSP.set(
        AppSPKey.isCheckinThuCong, latestConfig.isCheckinThuCong ?? '');

    if (hasCheckinModeChanged) {
      await AppSP.set(AppSPKey.idLineCheckin, '');
      await AppSP.set(AppSPKey.tenLineCheckin, '');
    }
  }
}
