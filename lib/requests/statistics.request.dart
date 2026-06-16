import 'package:checkin/constants/api.dart';
import 'package:checkin/model/statistics.model.dart';
import 'package:checkin/services/api_services.dart';

class StatisticsRequest {
  Future<List<StatisticGroup>> getStatistics({
    required String idSuKien,
    required String loaiCheckin,
  }) async {
    final Map<String, dynamic> body = {
      'idSuKien': idSuKien,
    };

    final bool isSingleCheckin = loaiCheckin == '1L';
    final String endpoint =
        isSingleCheckin ? Api.getThongKe_1L : Api.getThongKe_NL;
    final String url = '${Api.hostApi}$endpoint';

    print(
      'Get statistics request: url=$url, queryParameters=$body, loaiCheckin=$loaiCheckin',
    );

    try {
      final response = await ApiService().getUsers(
        url,
        queryParameters: body,
      );

      print('Get statistics response status: ${response.statusCode}');
      print('Get statistics response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['LThongke'] is List) {
          final items = data['LThongke'] as List<dynamic>;
          print('Get statistics parsed items count: ${items.length}');
          return items
              .map(
                (item) => StatisticGroup.fromJson(
                  item as Map<String, dynamic>,
                  isSingleCheckin: isSingleCheckin,
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      print('Get statistics failed: $e');
    }

    return [];
  }
}
