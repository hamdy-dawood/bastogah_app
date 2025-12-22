import 'package:dio/dio.dart';

abstract class ServerError {
  final int? statusCode;
  final String message;

  ServerError(this.message, [this.statusCode]);
}

class ServerFailure extends ServerError {
  ServerFailure(super.message, [super.statusCode]);

  factory ServerFailure.fromDiorError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(AppErrorMessage.timeoutError);
      case DioExceptionType.sendTimeout:
        return ServerFailure(AppErrorMessage.timeoutError);
      case DioExceptionType.receiveTimeout:
        return ServerFailure(AppErrorMessage.timeoutError);
      case DioExceptionType.badCertificate:
        return ServerFailure(AppErrorMessage.badRequestError);
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(e.response!.statusCode!, e.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure(AppErrorMessage.cacheError);
      case DioExceptionType.connectionError:
        return ServerFailure(AppErrorMessage.noInternetError);
      case DioExceptionType.unknown:
        return ServerFailure(AppErrorMessage.unknownError);
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    final message = response['message'];
    return ServerFailure(message, statusCode);
  }
}

class AppErrorMessage {
  // error handler
  static const String badRequestError = "طلب غير صالح. حاول مرة أخرى لاحقًا";
  static const String forbiddenError = "طلب محظور. حاول مرة أخرى لاحقًا";
  static const String unauthorizedError = "مستخدم غير مصرح له , حاول مرة أخرى لاحقًا";
  static const String notFoundError = "url غير موجود , حاول مرة أخرى لاحقًا";
  static const String conflictError = "تم العثور على تعارض , حاول مرة أخرى لاحقًا";
  static const String internalServerError = "حدث خطأ ما , حاول مرة أخرى لاحقًا";
  static const String unknownError = "حدث خطأ ما , حاول مرة أخرى لاحقًا";
  static const String timeoutError = "انتهت المهلة , حاول مرة أخرى";
  static const String defaultError = "حدث خطأ ما , حاول مرة أخرى لاحقًا";
  static const String cacheError = "خطأ في ذاكرة التخزين المؤقت , حاول مرة أخرى لاحقًا";
  static const String noInternetError = "يُرجى التحقق من اتصالك بالإنترنت";
}
