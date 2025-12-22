import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
// import '../../../../client_version/home/domain/entities/config.dart';
import '../../../../client_version/home/domain/entities/product.dart';
import '../../../profile/domain/entities/product_categories.dart';
import '../entities/add_product_request_body.dart';
import '../entities/clients.dart';

abstract class BaseMerchantProductsRepository {
  Future<Either<ServerError, List<Product>>> getProducts({
    required int page,
    required String productCategory,
    required String search,
  });

  Future<Either<ServerError, String>> addProduct({
    required AddProductRequestBody addProductRequestBody,
  });

  Future<Either<ServerError, String>> editProduct({
    required AddProductRequestBody addProductRequestBody,
  });

  Future<Either<ServerError, void>> deleteProduct({required String id});

  Future<Either<ServerError, List<String>>> uploadImages({required FormData data});

  Future<Either<ServerError, List<Clients>>> getClients({required int page});

  // Future<Either<ServerError, Config>> getConfig();

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

  Future<Either<ServerError, List<ProductCategories>>> getProductCategories();

  Future<Either<ServerError, List<RegionAndCityModel>>> getGovernorate();

  Future<Either<ServerError, List<RegionAndCityModel>>> getCities({required String region});
}
