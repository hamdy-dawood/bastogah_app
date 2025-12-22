part of 'merchant_profile_cubit.dart';

abstract class MerchantProfileStates {}

class ProfileInitialState extends MerchantProfileStates {}

class ProfileNetworkErrorState extends MerchantProfileStates {}

// ========================  GET PROFILE DATA  ========================== //

class ProfileLoadingState extends MerchantProfileStates {}

class MerchantProfileSuccessState extends MerchantProfileStates {}

class ProfileFailState extends MerchantProfileStates {
  final String message;

  ProfileFailState({required this.message});
}

// ========================  GET PRODUCT CATEGORIES  ========================== //

class GetProductCategoriesLoadingState extends MerchantProfileStates {}

class GetProductCategoriesSuccessState extends MerchantProfileStates {}

class GetProductCategoriesFailedState extends MerchantProfileStates {
  final String message;

  GetProductCategoriesFailedState({required this.message});
}

// ========================  ADD PRODUCT CATEGORY  ========================== //

class AddProductCategoryLoadingState extends MerchantProfileStates {}

class AddProductCategorySuccessState extends MerchantProfileStates {}

class AddProductCategoryFailedState extends MerchantProfileStates {
  final String message;

  AddProductCategoryFailedState({required this.message});
}

// ========================  ADD PRODUCT CATEGORY  ========================== //

class DeleteProductCategoryLoadingState extends MerchantProfileStates {}

class DeleteProductCategorySuccessState extends MerchantProfileStates {}

class DeleteProductCategoryFailedState extends MerchantProfileStates {
  final String message;

  DeleteProductCategoryFailedState({required this.message});
}
