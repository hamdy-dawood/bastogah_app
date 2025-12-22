import 'package:bastoga/modules/app_versions/merchant_version/profile/data/models/product_categories_model.dart';

import '../../../../client_version/my_profile/data/models/profile_model.dart';

abstract class BaseRemoteMerchantProfileDataSource {
  Future<ProfileModel> getProfile();

  Future<List<ProductCategoriesModel>> getProductCategories();

  Future addProductCategory({required String name});

  Future editProductCategory({required String productCategoryId, required String name});

  Future deleteProductCategory({required String productCategoryId});
}
