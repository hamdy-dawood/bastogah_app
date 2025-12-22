part of 'client_home_cubit.dart';

abstract class ClientHomeStates {}

class ClientHomeInitial extends ClientHomeStates {}

// =======================================================//
class DisableAccountLoadingState extends ClientHomeStates {}

class DisableAccountSuccessState extends ClientHomeStates {}

class DisableAccountFailState extends ClientHomeStates {
  final String message;

  DisableAccountFailState({required this.message});
}

// ================== LOCATION STATES ============================= //
class ServiceNotEnabledState extends ClientHomeStates {}

class PermissionDeniedState extends ClientHomeStates {}

class PermissionDeniedForEverState extends ClientHomeStates {}

class CurrentPreciseLocationLoadingState extends ClientHomeStates {}

class CurrentPreciseLocationSuccessState extends ClientHomeStates {}

class CurrentPreciseLocationFailState extends ClientHomeStates {}

// =============================================== //

class ProfileLoadingState extends ClientHomeStates {}

class ClientProfileSuccessState extends ClientHomeStates {}

class ProfileFailState extends ClientHomeStates {
  final String message;

  ProfileFailState({required this.message});
}
// =============================================== //

class ConfigLoadingState extends ClientHomeStates {}

class ConfigSuccessState extends ClientHomeStates {}

class ConfigFailState extends ClientHomeStates {
  final String message;

  ConfigFailState({required this.message});
}
// =============================================== //

class LoadingState extends ClientHomeStates {}

class CategoriesSuccessState extends ClientHomeStates {}

class CategoriesFailState extends ClientHomeStates {
  final String message;

  CategoriesFailState({required this.message});
}

class SlidersSuccessState extends ClientHomeStates {}

class SlidersFailState extends ClientHomeStates {
  final String message;

  SlidersFailState({required this.message});
}

class SubCategoriesLoadingState extends ClientHomeStates {}

class SubCategoriesSuccessState extends ClientHomeStates {}

class SubCategoriesFailState extends ClientHomeStates {
  final String message;

  SubCategoriesFailState({required this.message});
}

class PaginationLoadingState extends ClientHomeStates {}

class PopularMerchantSuccessState extends ClientHomeStates {}

class PopularMerchantFailState extends ClientHomeStates {
  final String message;

  PopularMerchantFailState({required this.message});
}

class MerchantLoadingState extends ClientHomeStates {}

class MerchantMoreLoadingState extends ClientHomeStates {}

class MerchantSuccessState extends ClientHomeStates {}

class MerchantFailState extends ClientHomeStates {
  final String message;

  MerchantFailState({required this.message});
}

class MerchantProductsSuccessState extends ClientHomeStates {}

class MerchantProductsFailState extends ClientHomeStates {
  final String message;

  MerchantProductsFailState({required this.message});
}

// ========================  GET DISCOUNT MERCHANTS ========================== //

class DiscountMerchantLoadingState extends ClientHomeStates {}

class DiscountMerchantMoreLoadingState extends ClientHomeStates {}

class DiscountMerchantSuccessState extends ClientHomeStates {}

class DiscountMerchantFailState extends ClientHomeStates {
  final String message;

  DiscountMerchantFailState({required this.message});
}

// ================================================= //

class UpdateProductToCartState extends ClientHomeStates {}

class AddOrderLoadingState extends ClientHomeStates {}

class AddOrderSuccessState extends ClientHomeStates {}

class AddOrderFailState extends ClientHomeStates {
  final String message;

  AddOrderFailState({required this.message});
}

class GetProductCategoriesLoadingState extends ClientHomeStates {}

class GetProductCategoriesSuccessState extends ClientHomeStates {}

class GetProductCategoriesFailState extends ClientHomeStates {
  final String message;

  GetProductCategoriesFailState({required this.message});
}

// ========================  GET GOVERNORATE ========================== //

class GetGovernorateLoadingState extends ClientHomeStates {}

class GetGovernorateSuccessState extends ClientHomeStates {}

class GetGovernorateFailState extends ClientHomeStates {
  final String message;

  GetGovernorateFailState({required this.message});
}

// ========================  GET GOVERNORATE ========================== //

class GetCitiesLoadingState extends ClientHomeStates {}

class GetCitiesSuccessState extends ClientHomeStates {}

class GetCitiesFailState extends ClientHomeStates {
  final String message;

  GetCitiesFailState({required this.message});
}

// ======================== PRODUCT DETAILS ========================== //

class GetProductDetailsLoadingState extends ClientHomeStates {}

class GetProductDetailsSuccessState extends ClientHomeStates {}

class GetProductDetailsFailState extends ClientHomeStates {
  final String message;

  GetProductDetailsFailState({required this.message});
}

class ChangeCityPriceState extends ClientHomeStates {}

// ======================== GET CART PRODUCTS ========================== //

class GetCartProductsLoadingState extends ClientHomeStates {}

class GetCartProductsSuccessState extends ClientHomeStates {}

class GetCartProductsFailState extends ClientHomeStates {
  final String message;

  GetCartProductsFailState({required this.message});
}
