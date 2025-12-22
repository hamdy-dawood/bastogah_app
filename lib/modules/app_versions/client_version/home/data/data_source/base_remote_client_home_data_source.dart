import 'package:bastoga/modules/auth/data/models/region_city_model.dart';

import '../../../../merchant_version/profile/data/models/product_categories_model.dart';
import '../../../my_profile/data/models/profile_model.dart';
import '../models/categories_model.dart';
import '../models/merchant_model.dart';
import '../models/product_model.dart';
import '../models/slider_model.dart';
import '../models/sub_category_model.dart';

abstract class BaseRemoteClientHomeDataSource {
  Future<List<SliderModel>> getSliders();

  Future<List<CategoriesModel>> getCategories();

  Future<List<SubCategoryModel>> getSubCategory({required String category});

  Future<List<MerchantModel>> getMerchants({
    required String search,
    required String category,
    required String subCategory,
    required int page,
  });

  Future<List<MerchantModel>> getDiscountMerchants({required int page});

  Future<List<MerchantModel>> getPopularMerchants({required int page});

  Future<List<ProductCategoriesModel>> getProductCategories({required String merchantId});

  Future<List<ProductModel>> getProducts({
    required String? merchantId,
    required bool? discount,
    required String? offerId,
    required String? productCategory,
    required String? search,
    required int page,
  });

  // Future<ConfigModel> getConfig();

  Future<ProfileModel> getProfile();

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

  Future<List<RegionAndCityModel>> getGovernorate();

  Future<List<RegionAndCityModel>> getCities({required String region, required String merchant});

  Future<void> disableAccount();

  Future<List<ProductModel>> getCartProductsData({required String ids});
}
