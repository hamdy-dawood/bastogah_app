import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../caching/shared_prefs.dart';
import '../utils/constance.dart';
import 'app_interceptor.dart';
import 'endpoints.dart';

class DioManager {
  Dio? _dioInstance;

  Dio? get dio {
    _dioInstance ??= initDio();
    return _dioInstance;
  }

  Dio initDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
      ),
    );

    dio.interceptors.add(AppInterceptors(dio: dio));

    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          request: true,
          responseBody: true,
          responseHeader: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }

    String token = Caching.getData(key: AppConstance.accessTokenKey) ?? "";

    token.isNotEmpty ? dio.options.headers["Authorization"] = "Bearer $token" : null;

    return dio;
  }

  void update() => _dioInstance = initDio();

  Future<Response> get(
    String url, {
    dynamic data,
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio!.get(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: header),
    );
  }

  Future<Response> post(
    String url, {
    Map<String, dynamic>? header,
    Map<String, dynamic>? json,
    dynamic data,
  }) {
    return dio!.post(url, data: data, queryParameters: json, options: Options(headers: header));
  }

  Future<Response> put(String url, {Map<String, dynamic>? header, dynamic data}) {
    return dio!.put(url, data: data, options: Options(headers: header));
  }

  Future<Response> delete(String url, {Map<String, dynamic>? header, dynamic data}) {
    return dio!.delete(url, data: data, options: Options(headers: header));
  }

  void setBaseUrl(String baseUrl) {
    dio!.options.baseUrl = baseUrl;
  }
}
