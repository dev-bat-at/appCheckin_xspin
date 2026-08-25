class CheckinHistory {
  String? thoiDiemCheckin;
  CheckinHistory({this.thoiDiemCheckin});
  factory CheckinHistory.fromJson(Map<String, dynamic> json) {
    return CheckinHistory(
      thoiDiemCheckin: json['ThoiDiemCheckin'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ThoiDiemCheckin': thoiDiemCheckin,
    };
  }
}

int? _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  if (value is num) {
    return value != 0;
  }
  return false;
}

class Users {
  String maQR;
  String? tenTinhTrang;
  String? maTinhTrang;
  bool isCheckin;
  String idNguoiThamDu;
  String? thoiDiemCheckin;
  String? tinhTrang;
  String? field2;
  String? field3;
  String? field4;
  String? field5;
  String? field6;
  String? field7;
  String? field8;
  String? field9;
  String? field10;
  String? field11;
  String? field12;
  String? field13;
  String? field14;
  String? field15;
  int? soLuotCheckIntoida;
  String? ngayCheckin;
  int? dacheckIn;
  int? chuaCheckin;
  List<CheckinHistory>? lichSuCheckin;

  Users({
    required this.maQR,
    required this.isCheckin,
    required this.idNguoiThamDu,
    this.thoiDiemCheckin,
    this.field2,
    this.field3,
    this.tenTinhTrang,
    this.maTinhTrang,
    this.tinhTrang,
    this.field4,
    this.field5,
    this.field6,
    this.field7,
    this.field8,
    this.ngayCheckin,
    this.field9,
    this.field10,
    this.field11,
    this.field12,
    this.chuaCheckin,
    this.dacheckIn,
    this.soLuotCheckIntoida,
    this.field13,
    this.field14,
    this.field15,
    this.lichSuCheckin,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        maQR: json['MaThamDu'] ?? '',
        idNguoiThamDu: json['idNguoiThamDu'] ?? '',
        isCheckin: _parseBool(json['isCheckin']),
        thoiDiemCheckin: json['ThoiDiemCheckin'],
        chuaCheckin: _parseInt(json['ChuaCheckin']),
        dacheckIn: _parseInt(json['DaCheckin']),
        soLuotCheckIntoida: _parseInt(json['SoLuotCheckinToiDa']),
        field2: json['Field2'],
        field3: json['Field3'],
        field4: json['Field4'],
        field5: json['Field5'],
        field6: json['Field6'],
        field7: json['Field7'],
        field8: json['Field8'],
        field9: json['Field9'],
        field10: json['Field10'],
        field11: json['Field11'],
        field12: json['Field12'],
        field13: json['Field13'],
        field14: json['Field14'],
        field15: json['Field15'],
        lichSuCheckin: (json['LichSuCheckin'] as List<dynamic>?)
                ?.map((item) => CheckinHistory.fromJson(item))
                .toList() ??
            [],
        tenTinhTrang: json['TenTinhTrang'],
        maTinhTrang: json['MaTinhTrang'],
        tinhTrang: json['TinhTrang'],
        ngayCheckin: json['NgayCheckin']);
  }
  Map<String, dynamic> toJson() {
    return {
      'MaThamDu': maQR,
      'idNguoiThamDu': idNguoiThamDu,
      'isCheckin': isCheckin,
      'ThoiDiemCheckin': thoiDiemCheckin,
      "SoLuotCheckinToiDa": soLuotCheckIntoida,
      "DaCheckin": dacheckIn,
      "ChuaCheckin": chuaCheckin,
      'Field2': field2,
      'Field3': field3,
      'Field4': field4,
      'Field5': field5,
      'Field6': field6,
      'Field7': field7,
      'Field8': field8,
      'Field9': field9,
      'Field10': field10,
      'Field11': field11,
      'Field12': field12,
      'Field13': field13,
      'NgayCheckin': ngayCheckin,
      'TinhTrang': tinhTrang,
      'Field14': field14,
      'Field15': field15,
      'LichSuCheckin': lichSuCheckin?.map((item) => item.toJson()).toList(),
    };
  }

  bool searchName(String field2) {
    return this.field2?.toLowerCase().contains(field2.toLowerCase()) ?? false;
  }

  bool searchQR(String qr) {
    return maQR.toLowerCase().contains(qr.toLowerCase());
  }

  /// True when the attendee has already checked in at least once.
  bool get hasCheckedIn {
    if (isCheckin) return true;
    if (tinhTrang == 'Đã check-in') return true;
    if (maTinhTrang == 'DaCheckinXong' || maTinhTrang == 'DangCheckin') {
      return true;
    }
    if ((dacheckIn ?? 0) > 0) return true;
    if (thoiDiemCheckin != null && thoiDiemCheckin!.isNotEmpty) return true;
    if (ngayCheckin != null && ngayCheckin!.isNotEmpty) return true;
    return false;
  }

  /// True when manual check-in is still allowed for this attendee.
  bool get canManualCheckIn {
    if (maTinhTrang == 'DaCheckinXong') return false;
    if (tinhTrang == 'Đã check-in') return false;
    if (chuaCheckin != null) return chuaCheckin! > 0;
    return !isCheckin;
  }
}
