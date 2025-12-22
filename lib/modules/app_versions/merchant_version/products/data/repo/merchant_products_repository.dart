import 'package:bastoga/core/networking/errors/server_errors.dart';
// import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/config.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/product.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/domain/entities/add_product_request_body.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/domain/entities/clients.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/base_merchant_products_repository.dart';
import '../data_source/base_remote_merchant_products_data_source.dart';

class MerchantProductsRepository extends BaseMerchantProductsRepository {
  final BaseRemoteMerchantProductsDataSource dataSource;

  MerchantProductsRepository(this.dataSource);

  @override
  Future<Either<ServerError, List<Product>>> getProducts({
    required int page,
    required String productCategory,
    required String search,
  }) async {
    try {
      final result = await dataSource.getProducts(
        page: page,
        search: search,
        productCategory: productCategory,
      );

      return Right(result);
    } on ServerError catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<ServerError, String>> addProduct({
    required AddProductRequestBody addProductRequestBody,
  }) async {
    try {
      final result = await dataSource.addProduct(addProductRequestBody: addProductRequestBody);

      return Right(result);
    } on ServerError catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<ServerError, String>> editProduct({
    required AddProductRequestBody addProductRequestBody,
  }) async {
    try {
      final result = await dataSource.editProduct(addProductRequestBody: addProductRequestBody);

      return Right(result);
    } on ServerError catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<ServerError, List<String>>> uploadImages({required FormData data}) async {
    try {
      final result = await dataSource.uploadImages(data: data);

      return Right(result);
    } on ServerError catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<ServerError, List<Clients>>> getClients({required int page}) async {
    try {
      final result = await dataSource.getClients(page: page);

      return Right(result);
    } on ServerError catch (failure) {
      return Left(failure);
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
    } on ServerError catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<ServerError, List<ProductCategories>>> getProductCategories() async {
    try {
      final result = await dataSource.getProductCategories();

      return Right(result);
    } on ServerError catch (failure) {
      return Left(failure);
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
  Future<Either<ServerError, List<RegionAndCityModel>>> getCities({required String region}) async {
    try {
      final result = await dataSource.getCities(region: region);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, void>> deleteProduct({required String id}) async {
    try {
      final result = await dataSource.deleteProduct(id: id);

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
}
