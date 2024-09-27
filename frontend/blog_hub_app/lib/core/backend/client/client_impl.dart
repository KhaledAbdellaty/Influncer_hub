part of "client.dart";

class DioClientImpl extends DioClient {
  final Dio dio;

  DioClientImpl(this.dio) {
    // dio.interceptors.add(AppInterceptor());
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          responseBody: true,
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
      // dio.options = BaseOptions(
      //   baseUrl: Endpoints.accounts,
      //   connectTimeout: Duration(seconds: 30),
      //   receiveTimeout: Duration(seconds: 30),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // );
    }
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

  @override
  Future<Response> post(
    String path, {
    data,
    bool isUrlEncoded = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      dio.post(
        path,
        data: isUrlEncoded ? jsonEncode(data) : FormData.fromMap(data),
        queryParameters: queryParameters,
        options: options,
      );

  @override
  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool isUrlEncoded = false,
    Options? options,
  }) {
    data["_method"] = "PUT";
    return dio.post(
      path,
      data: isUrlEncoded ? jsonEncode(data) : FormData.fromMap(data),
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      dio.delete(
        path,
        data: data != null ? FormData.fromMap(data) : null,
        queryParameters: queryParameters,
        options: options,
      );

  static DioClient get instance => Modular.get();
}
