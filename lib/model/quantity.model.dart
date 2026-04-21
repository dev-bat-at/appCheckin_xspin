class CountDataModel {
  final int countData;

  CountDataModel({required this.countData});

  // Tạo một factory method để ánh xạ từ JSON
  factory CountDataModel.fromJson(Map<String, dynamic> json) {
    return CountDataModel(
      countData: json['CountData'] as int,
    );
  }

  // Hàm chuyển đổi từ model về JSON
  Map<String, dynamic> toJson() {
    return {
      'CountData': countData,
    };
  }
}
