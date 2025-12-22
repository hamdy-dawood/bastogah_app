// import 'package:bastoga/modules/app_versions/client_version/home/data/models/config_model.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/product_model.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/data/models/clients_model.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/domain/entities/add_product_request_body.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/models/product_categories_model.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/networking/dio.dart';
import '../../../../../../core/networking/endpoints.dart';
import '../../../../../../core/networking/errors/errors_models/error_message_model.dart';
import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../../../core/utils/constance.dart';
import 'base_remote_merchant_products_data_source.dart';

class RemoteMerchantProductsDataSource extends BaseRemoteMerchantProductsDataSource {
  final dioManager = DioManager();

  @override
  Future<List<ProductModel>> getProducts({
    required int page,
    required String productCategory,
    required String search,
  }) async {
    final response = await dioManager.get(
      ApiConstants.merchantProducts,
      queryParameters: {
        "skip": page,
        if (search.isNotEmpty) "searchText": search,
        "category": productCategory,
        "merchant": Caching.getData(key: AppConstance.loggedInUserKey),
      },
    );

    if (response.statusCode == 200) {
      return List<ProductModel>.from(response.data.map((e) => ProductModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<String> addProduct({required AddProductRequestBody addProductRequestBody}) async {
    final response = await dioManager.post(
      ApiConstants.merchantProducts,
      data: {
        "images": addProductRequestBody.images,
        "name": addProductRequestBody.name,
        "desc": addProductRequestBody.description,
        "price": addProductRequestBody.price,
        "finalPrice": addProductRequestBody.price,
        "popular": addProductRequestBody.isPopular,
        "new": addProductRequestBody.isNew,
        "category": addProductRequestBody.categoryId,
      },
    );

    if (response.statusCode == 201) {
      return 'تم إضافة المنتج بنجاح';
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<String> editProduct({required AddProductRequestBody addProductRequestBody}) async {
    final response = await dioManager.put(
      '${ApiConstants.merchantProducts}/${addProductRequestBody.productId}',
      data: {
        "images": addProductRequestBody.images,
        "name": addProductRequestBody.name,
        "desc": addProductRequestBody.description,
        "price": addProductRequestBody.price,
        "finalPrice": addProductRequestBody.finalPrice,
        "popular": addProductRequestBody.isPopular,
        "active": !addProductRequestBody.isActive,
        "new": addProductRequestBody.isNew,
        "category": addProductRequestBody.categoryId,
      },
    );

    if (response.statusCode == 200) {
      return 'تم تعديل المنتج بنجاح';
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<String>> uploadImages({required FormData data}) async {
    final response = await dioManager.post(ApiConstants.uploadImages, data: data);

    if (response.statusCode == 201) {
      return List<String>.from(response.data['images'].map((e) => e));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ClientsModel>> getClients({required int page}) async {
    final response = await dioManager.get(ApiConstants.clients, queryParameters: {"skip": page});

    if (response.statusCode == 200) {
      return List<ClientsModel>.from(response.data.map((e) => ClientsModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
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
  }) async {
    print('---------- $items');
    final response = await dioManager.post(
      ApiConstants.orders,
      data: {
        "items": items,
        "itemsPrice": itemsPrice,
        "totalDiscount": totalDiscount,
        "totalAppliedDiscount": totalAppliedDiscount,
        // "discountDiff": discountDiff,
        "shippingPrice": shippingPrice,
        "clientPrice": clientPrice,
        "client": clientId.isNotEmpty ? clientId : null,
        "clientName": clientName,
        "address": address,
        "region": region,
        "city": city,
        "phone": phone,
        "locationLat": locationLat,
        "locationLng": locationLng,
        "merchant": merchantId,
        "notes": notes,
        if (maxDiscount != -1) "maxDiscount": maxDiscount,
      },
    );

    if (response.statusCode == 201) {
      return response.data['_id'];
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ProductCategoriesModel>> getProductCategories() async {
    final response = await dioManager.get(
      ApiConstants.merchantProductCategories,
      queryParameters: {"merchant": Caching.getData(key: AppConstance.loggedInUserKey)},
    );

    if (response.statusCode == 200) {
      return List<ProductCategoriesModel>.from(
        response.data.map((e) => ProductCategoriesModel.fromJson(e)),
      );
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<RegionAndCityModel>> getGovernorate() async {
    final response = await dioManager.get(ApiConstants.regions);

    if (response.statusCode == 200) {
      return List<RegionAndCityModel>.from(
        response.data.map((e) => RegionAndCityModel.fromJson(e)),
      );
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<RegionAndCityModel>> getCities({required String region}) async {
    final response = await dioManager.get(
      ApiConstants.cities,
      queryParameters: {
        "region": region,
        "merchant": Caching.getData(key: AppConstance.loggedInUserKey),
      },
    );

    if (response.statusCode == 200) {
      return List<RegionAndCityModel>.from(
        response.data.map((e) => RegionAndCityModel.fromJson(e)),
      );
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<void> deleteProduct({required String id}) async {
    final response = await dioManager.delete('${ApiConstants.merchantProducts}/$id');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  //   @override
  //   Future<ConfigModel> getConfig() async {
  //     final response = await DioHelper.getData(
  //       baseUrl: AppApis.baseUrl,
  //       path: AppApis.config,
  //       // headers: {
  // //          "Authorization": Caching.getData(key: AppConstance.accessTokenKey),
  // //        },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return ConfigModel.fromJson(response.data);
  //     } else {
  //       throw ServerError(ErrorMessageModel.fromJson(response.data));
  //     }
  //   }
}
