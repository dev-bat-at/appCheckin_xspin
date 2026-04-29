class StatisticSummary {
  final int tongNguoiThamDu;
  final int daCheckin;
  final int chuaCheckin;
  final int daCheckinXong;
  final int dangCheckin;
  final int chuaTungCheckin;

  const StatisticSummary({
    required this.tongNguoiThamDu,
    this.daCheckin = 0,
    this.chuaCheckin = 0,
    this.daCheckinXong = 0,
    this.dangCheckin = 0,
    this.chuaTungCheckin = 0,
  });

  const StatisticSummary.empty()
      : tongNguoiThamDu = 0,
        daCheckin = 0,
        chuaCheckin = 0,
        daCheckinXong = 0,
        dangCheckin = 0,
        chuaTungCheckin = 0;

  StatisticSummary operator +(StatisticSummary other) {
    return StatisticSummary(
      tongNguoiThamDu: tongNguoiThamDu + other.tongNguoiThamDu,
      daCheckin: daCheckin + other.daCheckin,
      chuaCheckin: chuaCheckin + other.chuaCheckin,
      daCheckinXong: daCheckinXong + other.daCheckinXong,
      dangCheckin: dangCheckin + other.dangCheckin,
      chuaTungCheckin: chuaTungCheckin + other.chuaTungCheckin,
    );
  }

  factory StatisticSummary.sum(Iterable<StatisticSummary> items) {
    return items.fold(
      const StatisticSummary.empty(),
      (total, item) => total + item,
    );
  }

  factory StatisticSummary.fromJson(
    Map<String, dynamic> json, {
    required bool isSingleCheckin,
  }) {
    int parseInt(dynamic value) => int.tryParse(value?.toString() ?? '0') ?? 0;
    int firstAvailable(List<String> keys) {
      for (final key in keys) {
        if (json.containsKey(key) && json[key] != null) {
          return parseInt(json[key]);
        }
      }
      return 0;
    }

    return StatisticSummary(
      tongNguoiThamDu: parseInt(json['TongNguoiThamDu']),
      daCheckin: isSingleCheckin ? firstAvailable(['DaCheckin']) : 0,
      chuaCheckin: isSingleCheckin ? firstAvailable(['ChuaCheckin']) : 0,
      daCheckinXong:
          isSingleCheckin ? 0 : firstAvailable(['DaCheckinXong', 'DaCheckin']),
      dangCheckin: isSingleCheckin ? 0 : firstAvailable(['DangCheckin']),
      chuaTungCheckin: isSingleCheckin
          ? 0
          : firstAvailable(['ChuaTungCheckin', 'ChuaCheckin']),
    );
  }
}

class StatisticGroup {
  final String nhomThongKe;
  final StatisticSummary thongKe;

  const StatisticGroup({
    required this.nhomThongKe,
    required this.thongKe,
  });

  bool get isOverview => nhomThongKe.trim().isEmpty;

  String get displayName => isOverview ? 'Tổng quan' : nhomThongKe;

  factory StatisticGroup.fromJson(
    Map<String, dynamic> json, {
    required bool isSingleCheckin,
  }) {
    return StatisticGroup(
      nhomThongKe: json['NhomThongKe']?.toString() ?? '',
      thongKe: StatisticSummary.fromJson(
        (json['LThongKe'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        isSingleCheckin: isSingleCheckin,
      ),
    );
  }
}
