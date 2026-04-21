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

  factory StatisticSummary.fromJson(
    Map<String, dynamic> json, {
    required bool isSingleCheckin,
  }) {
    int parseInt(dynamic value) => int.tryParse(value?.toString() ?? '0') ?? 0;

    return StatisticSummary(
      tongNguoiThamDu: parseInt(json['TongNguoiThamDu']),
      daCheckin: isSingleCheckin ? 0 : parseInt(json['DaCheckin']),
      chuaCheckin: isSingleCheckin ? 0 : parseInt(json['ChuaCheckin']),
      daCheckinXong: isSingleCheckin ? parseInt(json['DaCheckinXong']) : 0,
      dangCheckin: isSingleCheckin ? parseInt(json['DangCheckin']) : 0,
      chuaTungCheckin: isSingleCheckin ? parseInt(json['ChuaTungCheckin']) : 0,
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
