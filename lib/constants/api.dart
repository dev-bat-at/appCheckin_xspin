class Api {
  static const String hostApi = 'https://api.xspin.vn/api/ci';

  // static const lstUser = '/getListNguoiThamDu';
// NHIỀU LẦN
  static const Users = '/getListNguoiThamDu';

  static const login = '/DangNhap';

  static const infoUser = '/getThongTinNguoiThamDu';

  static const checkIn = '/checkin';

  static const autoCheckIn = '/checkinTuDong';

  static const getQRCode = '/GetMaQR';

  static const getCountUser = '/getDemSoLuotCheckin';

  static const getCountNguoiThamDu = '/getDemSoNguoiThamDu';

  static const getCheckin = '/getTinhTrangCheckin';

  static const getHistoryCheckin = '/getListLichSuCheckin';

// MỘT LẦN

  static const getlstUser_1L = '/getListNguoiThamDu_1L';

  static const getCountUser_1L = '/getDemSoNguoiThamDu_1L';

// UPDATE MỚI

  static const getLineCheckin = '/getLineCheckin';

  static const getThongKe_NL = '/getThongKe_NL';

  static const getThongKe_1L = '/getThongKe_1L';

  static const DaCheckin = 'Đã check-in';
  static const ChuaCheckin = 'Chưa check-in';
}
