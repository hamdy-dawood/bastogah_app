import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/data_source/base_remote_merchant_profile_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/repository/base_merchant_profile_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../client_version/my_profile/domain/entities/profile.dart';

class MerchantProfileRepository extends BaseMerchantProfileRepository {
  final BaseRemoteMerchantProfileDataSource dataSource;

  MerchantProfileRepository(this.dataSource);

  @override
  Future<Either<ServerError, Profile>> getProfile() async {
    try {
      final result = await dataSource.getProfile();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  // ========================  GET PRODUCT CATEGORIES  ========================== //
  @override
  Future<Either<ServerError, List<ProductCategories>>> getProductCategories() async {
    try {
      final result = await dataSource.getProductCategories();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  //===========================  ADD PRODUCT CATEGORY  ===========================//

  @override
  Future<Either<ServerError, String>> addProductCategory({required String name}) async {
    try {
      final result = await dataSource.addProductCategory(name: name);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  //===========================  Edit PRODUCT CATEGORY  ===========================//

  @override
  Future<Either<ServerError, String>> editProductCategory({
    required String productCategoryId,
    required String name,
  }) async {
    try {
      final result = await dataSource.editProductCategory(
        productCategoryId: productCategoryId,
        name: name,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  //===========================  DELETE PRODUCT CATEGORY  ===========================//

  @override
  Future<Either<ServerError, String>> deleteProductCategory({
    required String productCategoryId,
  }) async {
    try {
      final result = await dataSource.deleteProductCategory(productCategoryId: productCategoryId);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
