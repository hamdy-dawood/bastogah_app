import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/networking/dio.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:bastoga/core/networking/errors/errors_models/error_message_model.dart';
import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/data/models/profile_model.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/models/product_categories_model.dart';

import 'base_remote_merchant_profile_data_source.dart';

class RemoteMerchantProfileDataSource extends BaseRemoteMerchantProfileDataSource {
  final dioManager = DioManager();

  @override
  Future<ProfileModel> getProfile() async {
    final response = await dioManager.get(ApiConstants.profile);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  // ========================  GET PRODUCT CATEGORIES  ========================== //

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

  //===========================  Add PRODUCT CATEGORY  ===========================//

  @override
  Future addProductCategory({required String name}) async {
    final response = await dioManager.post(
      ApiConstants.merchantProductCategories,
      data: {"name": name},
    );

    if (response.statusCode == 201) {
      return "";
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  //===========================  Edit PRODUCT CATEGORY  ===========================//

  @override
  Future editProductCategory({required String productCategoryId, required String name}) async {
    final response = await dioManager.put(
      "${ApiConstants.merchantProductCategories}/$productCategoryId",
      data: {"name": name},
    );

    if (response.statusCode == 200) {
      return "";
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  //===========================  DELETE PRODUCT CATEGORY  ===========================//

  @override
  Future deleteProductCategory({required String productCategoryId}) async {
    final response = await dioManager.delete(
      "${ApiConstants.merchantProductCategories}/$productCategoryId",
    );

    if (response.statusCode == 200) {
      return "";
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }
}
