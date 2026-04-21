import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60), // 10 giây
    receiveTimeout: const Duration(seconds: 60), // 10 giây
  ));

  ApiService() {
    dio.options.headers = {
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  Future<Response> _handleRedirect(Response response,
      {Map<String, dynamic>? queryParameters}) async {
    if (response.statusCode == 302) {
      final newUrl = response.headers['location']?.first;
      if (newUrl != null) {
        response = await dio.post(
          newUrl,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          ),
        );
      } else {
        throw Exception('No redirection URL found');
      }
    }
    return response;
  }

  Future<Response> handleRedirect(Response response,
      {Map<String, dynamic>? queryParameters}) async {
    if (response.statusCode == 302) {
      final newUrl = response.headers['location']?.first;
      if (newUrl != null) {
        response = await dio.get(
          newUrl,
          data: queryParameters,
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
            },
          ),
        );
      } else {
        throw Exception('No redirection URL found');
      }
    }
    return response;
  }

  Future<Response> getRequest(String url,
      {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          response = await dio.get(
            newUrl,
            queryParameters: queryParams,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500; // Allow all status codes below 500
              },
            ),
          );
        } else {
          throw Exception('No redirection URL found');
        }
      }

      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<Response> getListUsers(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(
        url,
        data: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      response =
          await handleRedirect(response, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(
        url,
        data: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      response =
          await handleRedirect(response, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<Response> getUsers(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(
        url,
        data: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      response =
          await handleRedirect(response, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<Response> Login(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.get(
        url,
        data: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      response =
          await handleRedirect(response, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('Get request error: $e');
    }
  }

  Future<Response> QrCode(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await dio.post(
        url,
        data: queryParameters,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-api-key': 'a5f5d562383a6948f729cae3fef292d30b4d4963',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      response =
          await _handleRedirect(response, queryParameters: queryParameters);
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> patchRequest(String url, Map<String, dynamic>? data) async {
    try {
      Response response;
      if (data != null) {
        response = await dio.patch(
          url,
          queryParameters: data,
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500; // Allow all status codes below 500
            },
          ),
        );
        response = await _handleRedirect(response, queryParameters: data);
      } else {
        response = await dio.patch(
          url,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500; // Allow all status codes below 500
            },
          ),
        );
      }

      return response;
    } catch (e) {
      throw Exception('PATCH request error: $e');
    }
  }

  Future<Response> deleteRequest(String url,
      {Map<String, dynamic>? data}) async {
    try {
      Response response = await dio.delete(
        url,
        queryParameters: data,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          response = await dio.delete(
            newUrl,
            queryParameters: data,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500; // Allow all status codes below 500
              },
            ),
          );
        } else {
          throw Exception('No redirection URL found');
        }
      }

      return response;
    } catch (e) {
      throw Exception('DELETE request error: $e');
    }
  }
}
