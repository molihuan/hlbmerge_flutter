import 'package:get/get.dart';

/// GetX 网络请求工具类
class GetxHttpUtils extends GetConnect {
  static final GetxHttpUtils _instance = GetxHttpUtils._internal();
  factory GetxHttpUtils() => _instance;
  GetxHttpUtils._internal();

  @override
  void onInit() {
    httpClient.baseUrl = "https://jsonplaceholder.typicode.com"; // 基础地址
    httpClient.timeout = const Duration(seconds: 15); // 超时

    // 请求拦截
    httpClient.addRequestModifier<void>((request) {
      print("➡️ 请求: [${request.method}] ${request.url}");
      print("请求头: ${request.headers}");
      return request;
    });

    // 响应拦截
    httpClient.addResponseModifier((request, response) {
      print("⬅️ 响应: [${request.method}] ${request.url}");
      print("状态码: ${response.statusCode}");
      print("响应体: ${response.body}");
      return response;
    });
  }

  /// GET
  Future<Response<T>> getRequest<T>(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    try {
      return await get<T>(path, query: query);
    } catch (e) {
      return Response(statusCode: -1, statusText: e.toString());
    }
  }

  /// POST
  Future<Response<T>> postRequest<T>(
      String path,
      dynamic body, {
        Map<String, dynamic>? query,
      }) async {
    try {
      return await post<T>(path, body, query: query);
    } catch (e) {
      return Response(statusCode: -1, statusText: e.toString());
    }
  }

  /// PUT
  Future<Response<T>> putRequest<T>(
      String path,
      dynamic body, {
        Map<String, dynamic>? query,
      }) async {
    try {
      return await put<T>(path, body, query: query);
    } catch (e) {
      return Response(statusCode: -1, statusText: e.toString());
    }
  }

  /// DELETE
  Future<Response<T>> deleteRequest<T>(
      String path, {
        Map<String, dynamic>? query,
      }) async {
    try {
      return await delete<T>(path, query: query);
    } catch (e) {
      return Response(statusCode: -1, statusText: e.toString());
    }
  }
}