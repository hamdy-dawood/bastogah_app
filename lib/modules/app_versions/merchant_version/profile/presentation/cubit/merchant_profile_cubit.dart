import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/domain/entities/profile.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/repository/base_merchant_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'merchant_profile_states.dart';

class MerchantProfileCubit extends Cubit<MerchantProfileStates> {
  final BaseMerchantProfileRepository baseMerchantProfileRepository;

  MerchantProfileCubit(this.baseMerchantProfileRepository) : super(ProfileInitialState());

  Profile? profile;

  Future getProfile() async {
    emit(ProfileLoadingState());

    final Either<ServerError, Profile> result = await baseMerchantProfileRepository.getProfile();

    result.fold((l) => emit(ProfileFailState(message: l.errorMessageModel.message)), (r) {
      profile = r;
      emit(MerchantProfileSuccessState());
    });
  }

  // ========================  GET PRODUCT CATEGORIES  ========================== //

  List<ProductCategories>? productCategories;

  Future getProductCategories() async {
    emit(GetProductCategoriesLoadingState());
    final Either<ServerError, List<ProductCategories>> response =
        await baseMerchantProfileRepository.getProductCategories();

    response.fold(
      (l) => emit(GetProductCategoriesFailedState(message: l.errorMessageModel.message)),
      (r) {
        productCategories = r;
        emit(GetProductCategoriesSuccessState());
      },
    );
  }

  //===========================  ADD PRODUCT CATEGORY  ===========================//

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  Future addProductCategory({required String name}) async {
    // if (formKey.currentState!.validate()) {
    emit(AddProductCategoryLoadingState());

    final Either<ServerError, String> response = await baseMerchantProfileRepository
        .addProductCategory(name: name);

    response.fold(
      (l) => emit(AddProductCategoryFailedState(message: l.errorMessageModel.message)),
      (r) {
        emit(AddProductCategorySuccessState());
      },
    );
    // }
  }

  //===========================  EDIT PRODUCT CATEGORY  ===========================//

  Future editProductCategory({required String productCategoryId, required String name}) async {
    // if (formKey.currentState!.validate()) {
    emit(AddProductCategoryLoadingState());

    final Either<ServerError, String> response = await baseMerchantProfileRepository
        .editProductCategory(productCategoryId: productCategoryId, name: name);

    response.fold(
      (l) => emit(AddProductCategoryFailedState(message: l.errorMessageModel.message)),
      (r) {
        emit(AddProductCategorySuccessState());
      },
    );
    // }
  }

  //===========================  DELETE PRODUCT CATEGORY  ===========================//

  Future deleteProductCategory({required String productCategoryId}) async {
    emit(DeleteProductCategoryLoadingState());

    final Either<ServerError, String> response = await baseMerchantProfileRepository
        .deleteProductCategory(productCategoryId: productCategoryId);

    response.fold(
      (l) => emit(DeleteProductCategoryFailedState(message: l.errorMessageModel.message)),
      (r) {
        emit(DeleteProductCategorySuccessState());
      },
    );
  }

  Future saveCategories({
    required List<String> namesToAdd,
    required Map<String, String> namesToEdit,
  }) async {
    emit(AddProductCategoryLoadingState());

    bool hasError = false;
    String errorMessage = "";

    // Edit existing
    for (var entry in namesToEdit.entries) {
      final result = await baseMerchantProfileRepository.editProductCategory(
        productCategoryId: entry.key,
        name: entry.value,
      );
      result.fold((l) {
        hasError = true;
        errorMessage = l.errorMessageModel.message;
      }, (r) {});
    }

    // Add new
    for (var name in namesToAdd) {
      if (name.trim().isEmpty) continue;
      final result = await baseMerchantProfileRepository.addProductCategory(name: name);
      result.fold((l) {
        hasError = true;
        errorMessage = l.errorMessageModel.message;
      }, (r) {});
    }

    if (hasError) {
      emit(
        AddProductCategoryFailedState(
          message: errorMessage.isNotEmpty ? errorMessage : "حدث خطأ ما",
        ),
      );
    } else {
      emit(AddProductCategorySuccessState());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
