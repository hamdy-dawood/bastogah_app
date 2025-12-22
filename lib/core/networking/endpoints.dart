import '../caching/shared_prefs.dart';

class ApiConstants {
  static String get baseUrl => Caching.getData(key: 'domain') ?? 'http://209.250.237.58:4069';

  // static String severLiveDomain = "https://zaitona.md-iraqsoft.com";
  // static String severLive = "http://209.250.237.58:3069";
  // static String severLocal = "http://209.250.237.58:4069";
  // static String localHost = "http://192.168.1.182:4069";

  static String refreshTokenUrl = "/auth/refresh-token";

  /// log in end point
  static const String disable = '/users/disable';
  static const String login = '/auth/login';
  static const String verifications = '/verifications';
  static const String sendOtp = '/verifications/otp';
  static const String forgetPassword = '/auth/reset-password-otp';

  static const String signup = '/auth/register-client';

  static const String regions = '/regions';
  static const String cities = '/cities';
  static const String config = '/config';

  /// home sliders end point
  static const String homeSliders = '/sliders';

  /// profile end point
  static const String profile = '/auth/profile';

  /// categories end point
  static const String merchantCategories = '/merchant-categories';

  /// sub categories end point
  static const String merchantSubCategories = '/merchant-sub-categories';

  /// merchants end point
  static const String merchantsList = '/users/merchants';

  /// merchant products
  static const String merchantProducts = '/products';

  ///
  static const String orders = '/orders';

  /// driver orders with distance
  static const String driverOrders = '/orders/drivers';

  static const String setDriver = '/orders/set-driver';

  /// drivers end point
  static const String drivers = '/users/drivers';

  /// clients end point
  static const String clients = '/users/clients';

  static const String merchantProductCategories = '/products-categories';

  static const String uploadImages = '/upload/images';

  /// full report end point
  static const String fullReport = '/orders/full-report';

  static String notificationsUrl = "/firebase/notifications";
}
