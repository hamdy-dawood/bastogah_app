import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../merchant_version/profile/domain/entities/product_categories.dart';
import '../../../my_profile/domain/entities/profile.dart';
import '../entities/categories.dart';
import '../entities/merchant.dart';
import '../entities/product.dart';
import '../entities/slider.dart';
import '../entities/sub_category.dart';

abstract class BaseClientHomeRepository {
  Future<Either<ServerError, List<Sliders>>> getSliders();

  Future<Either<ServerError, List<Categories>>> getCategories();

  Future<Either<ServerError, List<SubCategory>>> getSubCategories({required String category});

  Future<Either<ServerError, List<Merchant>>> getMerchants({
    required String search,
    required String category,
    required String subCategory,
    required int page,
  });

  Future<Either<ServerError, List<Merchant>>> getDiscountMerchants({required int page});

  Future<Either<ServerError, List<Merchant>>> getPopularMerchants({required int page});

  Future<Either<ServerError, List<ProductCategories>>> getProductCategories({
    required String merchantId,
  });

  Future<Either<ServerError, List<Product>>> getProducts({
    required String? merchantId,
    required bool? discount,
    required String? offerId,
    required String? productCategory,
    required String? search,
    required int page,
  });

  // Future<Either<ServerError, Config>> getConfig();

  Future<Either<ServerError, Profile>> getProfile();

  Future<Either<ServerError, String>> addOrder({
    required List<Map<String, dynamic>> items,
    required double itemsPrice,
    required double totalDiscount,
    required double totalAppliedDiscount,
    required double discountDiff,
    required double shippingPrice,
    required double clientPrice,
    required String clientName,
    required String clientId,
    required String address,
    required String region,
    required String city,
    required String phone,
    required double locationLat,
    required double locationLng,
    required String merchantId,
    required String notes,
    required num maxDiscount,
  });

  Future<Either<ServerError, List<RegionAndCityModel>>> getGovernorate();

  Future<Either<ServerError, List<RegionAndCityModel>>> getCities({
    required String region,
    required String merchant,
  });

  Future<Either<ServerError, void>> disableAccount();

  Future<Either<ServerError, List<Product>>> getCartProductsData({required String ids});
}
