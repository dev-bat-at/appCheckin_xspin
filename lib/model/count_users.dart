class CountLstThamDuModel {
  final int countData;

  CountLstThamDuModel({required this.countData});

  // Tạo một factory method để ánh xạ từ JSON
  factory CountLstThamDuModel.fromJson(Map<String, dynamic> json) {
    return CountLstThamDuModel(
      countData: json['SoNguoiThamDu'] as int,
    );
  }

  // Hàm chuyển đổi từ model về JSON
  Map<String, dynamic> toJson() {
    return {
      'SoNguoiThamDu': countData,
    };
  }
}
