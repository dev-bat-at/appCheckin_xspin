import 'package:dio/dio.dart';
import 'package:checkin/constants/api.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/services/api_services.dart';
import 'dart:async'; // Để sử dụng TimeoutException

class QRCodeCheckInResult {
  const QRCodeCheckInResult({
    required this.status,
    this.user,
    this.message,
  });

  final int status;
  final Users? user;
  final String? message;
}

class QRCodeRequest {
  final Dio dio = Dio();

  int? _parseStatus(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  String? _parseMessage(Map<String, dynamic> data) {
    final message = data['Messege'] ?? data['Message'];
    if (message is String) {
      final trimmedMessage = message.trim();
      if (trimmedMessage.isNotEmpty) {
        return trimmedMessage;
      }
    }
    return null;
  }

  bool _looksLikeUserPayload(Map<String, dynamic> data) {
    return data.containsKey('MaThamDu') ||
        data.containsKey('idNguoiThamDu') ||
        data.containsKey('Field2');
  }

  Future<QRCodeCheckInResult> checkIn(
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
      print('Check-in response statusCode: ${response.statusCode}');
      print('Check-in response data: ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return const QRCodeCheckInResult(status: 0);
        }

        final status = _parseStatus(data['Status']) ?? 0;
        final message = _parseMessage(data);
        print(data['Status']);
        if (status == 1) {
          print('Check-in thành công: ${data['Status']}');
          return QRCodeCheckInResult(
            status: status,
            user: Users.fromJson(data),
            message: message,
          );
        }

        print('Check-in không thành công: ${data['Status']}');
        return QRCodeCheckInResult(
          status: status,
          message: message,
        );
      } else {
        print('Check-in failed: ${response.statusCode}');
        throw Exception('Check-in failed: HTTP ${response.statusCode}');
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
      print('GetUser response statusCode: ${response.statusCode}');
      print('GetUser response data: ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data == "Error") {
          print("User không tồn tại");
          return null; // Mã QR không tồn tại
        }
        if (data is! Map<String, dynamic>) {
          return null;
        }

        print('status data: ${data['Status']}');
        final status = _parseStatus(data['Status']);
        if (status != null && status <= 0) {
          throw Exception(_parseMessage(data) ?? 'QR Code không hợp lệ!');
        }
        if (!_looksLikeUserPayload(data)) {
          throw Exception(_parseMessage(data) ?? 'QR Code không hợp lệ!');
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
