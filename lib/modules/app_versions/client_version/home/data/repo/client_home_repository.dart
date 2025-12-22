import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/categories.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/merchant.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/product.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/slider.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/sub_category.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/domain/entities/profile.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repository/base_client_home_repository.dart';
import '../data_source/base_remote_client_home_data_source.dart';

class ClientHomeRepository extends BaseClientHomeRepository {
  final BaseRemoteClientHomeDataSource dataSource;

  ClientHomeRepository(this.dataSource);

  @override
  Future<Either<ServerError, List<Sliders>>> getSliders() async {
    try {
      final result = await dataSource.getSliders();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Categories>>> getCategories() async {
    try {
      final result = await dataSource.getCategories();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<SubCategory>>> getSubCategories({
    required String category,
  }) async {
    try {
      final result = await dataSource.getSubCategory(category: category);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Merchant>>> getMerchants({
    required String search,
    required String category,
    required String subCategory,
    required int page,
  }) async {
    try {
      final result = await dataSource.getMerchants(
        search: search,
        category: category,
        subCategory: subCategory,
        page: page,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Merchant>>> getDiscountMerchants({required int page}) async {
    try {
      final result = await dataSource.getDiscountMerchants(page: page);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, Profile>> getProfile() async {
    try {
      final result = await dataSource.getProfile();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  // @override
  // Future<Either<ServerError, Config>> getConfig() async {
  //   try {
  //     final result = await dataSource.getConfig();
  //
  //     return Right(result);
  //   } on ServerError catch (fail) {
  //     return Left(fail);
  //   }
  // }

  @override
  Future<Either<ServerError, List<Product>>> getProducts({
    required String? merchantId,
    required bool? discount,
    required String? offerId,
    required String? productCategory,
    required String? search,
    required int page,
  }) async {
    try {
      final result = await dataSource.getProducts(
        merchantId: merchantId,
        discount: discount,
        offerId: offerId,
        productCategory: productCategory,
        search: search,
        page: page,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
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
  }) async {
    try {
      final result = await dataSource.addOrder(
        items: items,
        itemsPrice: itemsPrice,
        totalDiscount: totalDiscount,
        totalAppliedDiscount: totalAppliedDiscount,
        discountDiff: discountDiff,
        shippingPrice: shippingPrice,
        clientPrice: clientPrice,
        clientName: clientName,
        clientId: clientId,
        address: address,
        region: region,
        city: city,
        phone: phone,
        locationLat: locationLat,
        locationLng: locationLng,
        merchantId: merchantId,
        notes: notes,
        maxDiscount: maxDiscount,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Merchant>>> getPopularMerchants({required int page}) async {
    try {
      final result = await dataSource.getPopularMerchants(page: page);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<ProductCategories>>> getProductCategories({
    required String merchantId,
  }) async {
    try {
      final result = await dataSource.getProductCategories(merchantId: merchantId);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<RegionAndCityModel>>> getGovernorate() async {
    try {
      final result = await dataSource.getGovernorate();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<RegionAndCityModel>>> getCities({
    required String region,
    required String merchant,
  }) async {
    try {
      final result = await dataSource.getCities(region: region, merchant: merchant);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, void>> disableAccount() async {
    try {
      final result = await dataSource.disableAccount();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Product>>> getCartProductsData({required String ids}) async {
    try {
      final result = await dataSource.getCartProductsData(ids: ids);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
