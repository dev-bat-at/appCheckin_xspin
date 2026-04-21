class CheckinModel {
  String? idStatus;
  String? nameStatus;
  CheckinModel({this.idStatus, this.nameStatus});
  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      idStatus: json['MaTinhTrang'] as String?,
      nameStatus: json['TenTinhTrang'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'MaTinhTrang': idStatus,
      'TenTinhTrang': nameStatus,
    };
  }
}
