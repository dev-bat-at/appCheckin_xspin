import 'package:dio/dio.dart';
import 'package:checkin/constants/api.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/services/api_services.dart';
import 'dart:async'; // Để sử dụng TimeoutException

class QRCodeRequest {
  final Dio dio = Dio();

  Future<Users?> checkIn(
      {required String idSuKien,
      required String maQR,
      String? idLineCheckin}) async {
    final Map<String, dynamic> body = {
      'idSuKien': idSuKien,
      'MaThamDu': maQR,
      'idLineCheckin': idLineCheckin
    };
    try {
      final response = await ApiService()
          .QrCode('${Api.hostApi}${Api.checkIn}', queryParameters: body)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'Yêu cầu mất quá nhiều thời gian, kiểm tra kết nối mạng.');
      });
      if (response.statusCode == 200) {
        final data = response.data;
        print(response.data['Status']);
        if (data["Status"] == 1) {
          print('Check-in thành công: ${data['Status']}');
          return Users.fromJson(data);
        } else if (data["Status"] == 2) {
          print('Đã checkin: ${data['Status']}');
          return null;
        } else {
          print('Check-in không thành công: ${data['Status']}');
          return null;
        }
      } else {
        print('Check-in failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Check-in error: $e');
      throw Exception('Có sự cố với kết nối internet vui lòng kiểm tra lại');
    }
  }

  Future<Users?> getUser(
      {required String maQR, required String idSuKien}) async {
    final Map<String, dynamic> body = {
      'idSuKien': idSuKien,
      "MaThamDu": maQR,
    };
    try {
      final response = await ApiService()
          .getUsers('${Api.hostApi}${Api.infoUser}', queryParameters: body);
      if (response.statusCode == 200) {
        final data = response.data;
        print('status data: ${data['Status']}');
        if (data == "Error") {
          print("User không tồn tại");
          return null; // Mã QR không tồn tại
        }
        final qrCodeResponse = Users.fromJson(data);
        return qrCodeResponse;
      } else {
        throw Exception('Failed to load users: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('GetUser error: $e');
      throw Exception('QR Code không hợp lệ!');
    }
  }
}
