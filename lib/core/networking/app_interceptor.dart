import 'package:dio/dio.dart';

import '../caching/shared_prefs.dart';
import '../helpers/context_extension.dart';
import '../routing/routes.dart';
import '../utils/constance.dart';
import 'endpoints.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? authToken = Caching.getData(key: AppConstance.accessTokenKey);
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      String? accessToken = Caching.getData(key: AppConstance.accessTokenKey);
      String? refreshToken = Caching.getData(key: AppConstance.refreshTokenKey);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        dio.options.baseUrl = ApiConstants.baseUrl;
        await dio
            .get(ApiConstants.refreshTokenUrl, queryParameters: {"token": refreshToken})
            .then((value) {
              String token = value.data["access_token"];
              Caching.saveData(key: "access_token", value: token);
            })
            .catchError((e) {});
        accessToken = Caching.getData(key: AppConstance.accessTokenKey);
        err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
        return handler.resolve(await dio.fetch(err.requestOptions));
      }
    } else if (err.response?.statusCode == 403) {
      Caching.clearAllData();
      navigatorKey.currentContext!.pushNamedAndRemoveUntil(
        Routes.loginScreen,
        predicate: (_) => false,
      );
    }
    super.onError(err, handler);
  }
}
