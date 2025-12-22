import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';
import 'package:dartz/dartz.dart';

import '../../../../client_version/my_profile/domain/entities/profile.dart';

abstract class BaseMerchantProfileRepository {
  Future<Either<ServerError, Profile>> getProfile();

  Future<Either<ServerError, List<ProductCategories>>> getProductCategories();

  Future<Either<ServerError, String>> addProductCategory({required String name});

  Future<Either<ServerError, String>> editProductCategory({
    required String productCategoryId,
    required String name,
  });

  Future<Either<ServerError, String>> deleteProductCategory({required String productCategoryId});
}
