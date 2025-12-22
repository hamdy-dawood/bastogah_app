import 'package:bastoga/core/networking/dio.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/categories_model.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/merchant_model.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/product_model.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/slider_model.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/sub_category_model.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/models/product_categories_model.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/networking/errors/errors_models/error_message_model.dart';
import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../my_profile/data/models/profile_model.dart';
import 'base_remote_client_home_data_source.dart';

class RemoteClientHomeDataSource extends BaseRemoteClientHomeDataSource {
  final dioManager = DioManager();

  @override
  Future<List<SliderModel>> getSliders() async {
    try {
      final response = await dioManager.get(ApiConstants.homeSliders);

      if (response.statusCode == 200) {
        return List<SliderModel>.from(response.data.map((e) => SliderModel.fromJson(e)));
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: AppConstance.someThingWentWrongMessage));
    }
  }

  @override
  Future<List<CategoriesModel>> getCategories() async {
    final response = await dioManager.get(ApiConstants.merchantCategories);

    if (response.statusCode == 200) {
      return List<CategoriesModel>.from(response.data.map((e) => CategoriesModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<SubCategoryModel>> getSubCategory({required String category}) async {
    final response = await dioManager.get(
      ApiConstants.merchantSubCategories,
      queryParameters: {"category": category},
    );

    if (response.statusCode == 200) {
      return List<SubCategoryModel>.from(response.data.map((e) => SubCategoryModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<MerchantModel>> getMerchants({
    required String search,
    required String category,
    required String subCategory,
    required int page,
  }) async {
    try {
      final response = await dioManager.get(
        ApiConstants.merchantsList,
        queryParameters: {
          if (search.isNotEmpty) "searchText": search,
          "category": category,
          "subCategory": subCategory,
          "skip": page,
        },
      );

      if (response.statusCode == 200) {
        return List<MerchantModel>.from(response.data.map((e) => MerchantModel.fromJson(e)));
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: AppConstance.someThingWentWrongMessage));
    }
  }

  @override
  Future<List<MerchantModel>> getDiscountMerchants({required int page}) async {
    try {
      final response = await dioManager.get(
        ApiConstants.merchantsList,
        queryParameters: {"discount": true, "skip": (page - 1) * 20},
      );

      if (response.statusCode == 200) {
        return List<MerchantModel>.from(response.data.map((e) => MerchantModel.fromJson(e)));
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: AppConstance.someThingWentWrongMessage));
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    final response = await dioManager.get(ApiConstants.profile);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ProductModel>> getProducts({
    required String? merchantId,
    required bool? discount,
    required String? offerId,
    required String? productCategory,
    required String? search,
    required int page,
  }) async {
    final response = await dioManager.get(
      ApiConstants.merchantProducts,
      queryParameters: {
        if (merchantId != null) "merchant": merchantId,
        if (discount != null) "discount": discount,
        if (offerId != null) "offer": offerId,
        if (productCategory != null && productCategory.isNotEmpty) "category": productCategory,
        if (search != null && search.isNotEmpty) "searchText": search,
        "skip": page,
      },
    );

    if (response.statusCode == 200) {
      return List<ProductModel>.from(response.data.map((e) => ProductModel.fromJson(e)));
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
        "client": clientId,
        "clientName": clientName,
        "address": address,
        "region": region,
        "city": city,
        "phone": phone,
        "locationLat": locationLat,
        "locationLng": locationLng,
        "merchant": merchantId,
        "notes": notes,
        "maxDiscount": maxDiscount,
      },
    );

    if (response.statusCode == 201) {
      return 'تم الإضافه';
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<MerchantModel>> getPopularMerchants({required int page}) async {
    try {
      final response = await dioManager.get(
        ApiConstants.merchantsList,
        queryParameters: {"popular": true, "skip": page},
      );

      if (response.statusCode == 200) {
        return List<MerchantModel>.from(response.data.map((e) => MerchantModel.fromJson(e)));
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: AppConstance.someThingWentWrongMessage));
    }
  }

  @override
  Future<List<ProductCategoriesModel>> getProductCategories({required String merchantId}) async {
    final response = await dioManager.get(
      ApiConstants.merchantProductCategories,
      queryParameters: {"merchant": merchantId},
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
  Future<List<RegionAndCityModel>> getCities({
    required String region,
    required String merchant,
  }) async {
    final response = await dioManager.get(
      ApiConstants.cities,
      queryParameters: {"region": region, "merchant": merchant},
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
  Future<void> disableAccount() async {
    final response = await dioManager.post(ApiConstants.disable);

    if (response.statusCode == 201) {
      return;
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ProductModel>> getCartProductsData({required String ids}) async {
    final response = await dioManager.get(
      ApiConstants.merchantProducts,
      queryParameters: {
        "skip": -1,
        "_id": ids,
        // "_id": "6913000da8e93dcaf037bcc9,68f5f45dc83ca13460358311",
      },
    );

    if (response.statusCode == 200) {
      return List<ProductModel>.from(response.data.map((e) => ProductModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }
}
