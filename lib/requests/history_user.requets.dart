import 'package:checkin/model/checkin.model.dart';
import 'package:checkin/model/count_users.dart';
import 'package:checkin/model/quantity.model.dart';
import 'package:dio/dio.dart';
import 'package:checkin/constants/api.dart';
import 'package:checkin/model/user.model.dart';
import 'package:checkin/services/api_services.dart';

class UserRequest {
  Dio dio = Dio();
  Future<CountDataModel?> getCountUser(
      {required int tinhTrang, required String idSuKien}) async {
    final Map<String, dynamic> body = {
      'idSuKien': idSuKien,
      "TinhTrang": tinhTrang,
    };

    try {
      final response = await ApiService().getUsers(
        '${Api.hostApi}${Api.getCountUser}',
        queryParameters: body,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final countUser = CountDataModel.fromJson(data);
        return countUser;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<CountLstThamDuModel?> getCountLstUser(
      {required String MatinhTrang,
      required String idSuKien,
      required String key}) async {
    final Map<String, dynamic> body = {
      'idSuKien': idSuKien,
      "MaTinhTrang": MatinhTrang,
      "TuKhoa": key,
    };

    try {
      final response = await ApiService().getUsers(
        '${Api.hostApi}${Api.getCountNguoiThamDu}',
        queryParameters: body,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('day la data : $data');
        final countUser = CountLstThamDuModel.fromJson(data);
        return countUser;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<List<Users>> getListUserCheckin(
      {required String idSuKien, String? searchQuery, int? page}) async {
    List<Users> lstUsers = [];
    final Map<String, dynamic> body = {
      "idSuKien": idSuKien,
      "TuKhoa": searchQuery,
      "Page": page
    };
    try {
      // Thực hiện yêu cầu POST với query parameters
      final response = await ApiService().getListUsers(
          '${Api.hostApi}${Api.getHistoryCheckin}',
          queryParameters: body);
      if (response.data is Map && response.data['status'] == 0) {
        print('Lỗi gọi API');
      } else if (response.statusCode == 200) {
        if (response.data['LLichSuCheckin'] is List) {
          List<dynamic> data = response.data['LLichSuCheckin'];
          lstUsers = data.map((json) => Users.fromJson(json)).toList();
        } else {}
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
    }

    return lstUsers;
  }

  Future<List<Users>> getListUser_1L(
      {required String tinhTrang,
      required String idSuKien,
      int? page,
      String? searchQuery}) async {
    List<Users> lstUsers = [];
    final Map<String, dynamic> body = {
      "idSuKien": idSuKien,
      "MaTinhTrang": tinhTrang,
      "TuKhoa": searchQuery,
      "Page": page
    };
    try {
      final response = await ApiService().getListUsers(
          '${Api.hostApi}${Api.getlstUser_1L}',
          queryParameters: body);
      if (response.data is Map && response.data['status'] == 0) {
        print('Lỗi gọi API');
      } else if (response.statusCode == 200) {
        if (response.data['LNguoiThamDu'] is List) {
          List<dynamic> data = response.data['LNguoiThamDu'];
          lstUsers = data.map((json) => Users.fromJson(json)).toList();
        } else {
          //   print('Người dùng đã được quét hết.');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Error: $e');
    }

    return lstUsers;
  }

  Future<List<CheckinModel>> getUserStatus() async {
    List<CheckinModel> lstStatus = [];

    try {
      final response = await ApiService()
          .get('${Api.hostApi}${Api.getCheckin}', queryParameters: {});
      if (response.data is Map && response.data['status'] == 0) {
        print('Lỗi gọi API');
      } else if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        lstStatus = data.map((json) => CheckinModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load status');
      }
    } catch (e) {
      print('Error: $e');
    }

    return lstStatus;
  }

  Future<CountLstThamDuModel?> getCountUser_1L(
      {required String tinhTrang, required String idSuKien}) async {
    final Map<String, dynamic> body = {
      'idSuKien': idSuKien,
      'TuKhoa': '',
      "MaTinhTrang": tinhTrang,
    };

    try {
      final response = await ApiService().getUsers(
        '${Api.hostApi}${Api.getCountUser_1L}',
        queryParameters: body,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final countUser = CountLstThamDuModel.fromJson(data);
        return countUser;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Lỗi: $e');
      return null;
    }
  }

  Future<List<Users>> getListUser(
      {required String maTinhTrang,
      required String idSuKien,
      int? page,
      String? searchQuery}) async {
    List<Users> lstUsers = [];
    final Map<String, dynamic> body = {
      "idSuKien": idSuKien,
      "MaTinhTrang": maTinhTrang,
      "TuKhoa": searchQuery,
      "Page": page
    };
    try {
      // Thực hiện yêu cầu POST với query parameters
      final response = await ApiService()
          .getListUsers('${Api.hostApi}${Api.Users}', queryParameters: body);
      if (response.data is Map && response.data['status'] == 0) {
        print('Lỗi gọi API');
      } else if (response.statusCode == 200) {
        if (response.data['LNguoiThamDu'] is List) {
          List<dynamic> data = response.data['LNguoiThamDu'];
          lstUsers = data.map((json) => Users.fromJson(json)).toList();
        } else {
          //   print('Người dùng đã được quét hết.');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
    }

    return lstUsers;
  }
}
