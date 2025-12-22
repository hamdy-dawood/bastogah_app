import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dio/dio.dart';

// import '../../../../client_version/home/data/models/config_model.dart';
import '../../../../client_version/home/data/models/product_model.dart';
import '../../../profile/data/models/product_categories_model.dart';
import '../../domain/entities/add_product_request_body.dart';
import '../models/clients_model.dart';

abstract class BaseRemoteMerchantProductsDataSource {
  Future<List<ProductModel>> getProducts({
    required int page,
    required String productCategory,
    required String search,
  });

  Future<String> addProduct({required AddProductRequestBody addProductRequestBody});

  Future<String> editProduct({required AddProductRequestBody addProductRequestBody});

  Future<void> deleteProduct({required String id});

  Future<List<String>> uploadImages({required FormData data});

  Future<List<ClientsModel>> getClients({required int page});

  // Future<ConfigModel> getConfig();

  Future<String> addOrder({
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

  Future<List<ProductCategoriesModel>> getProductCategories();

  Future<List<RegionAndCityModel>> getGovernorate();

  Future<List<RegionAndCityModel>> getCities({required String region});
}
