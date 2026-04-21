import 'package:checkin/app/app_sp.dart';
import 'package:checkin/app/app_sp_key.dart';
import 'package:checkin/model/statistics.model.dart';
import 'package:checkin/requests/statistics.request.dart';
import 'package:stacked/stacked.dart';

class StatisticsViewModel extends BaseViewModel {
  final StatisticsRequest _statisticsRequest = StatisticsRequest();

  List<StatisticGroup> statistics = [];
  StatisticGroup? overview;
  List<StatisticGroup> groupedStatistics = [];

  bool get isSingleCheckin => AppSP.get(AppSPKey.loaiCheckin) == '1L';

  Future<void> loadStatistics() async {
    setBusy(true);
    try {
      statistics = await _statisticsRequest.getStatistics(
        idSuKien: AppSP.get(AppSPKey.idSuKien) ?? '',
        loaiCheckin: AppSP.get(AppSPKey.loaiCheckin) ?? '',
      );

      overview = statistics.cast<StatisticGroup?>().firstWhere(
            (item) => item?.isOverview == true,
            orElse: () => statistics.isNotEmpty ? statistics.first : null,
          );

      groupedStatistics =
          statistics.where((item) => !item.isOverview).toList(growable: false);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }
}
