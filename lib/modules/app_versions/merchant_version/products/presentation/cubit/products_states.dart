abstract class MerchantProductsStates {}

class MerchantProductsInitialState extends MerchantProductsStates {}

class MerchantProductsNetworkErrorState extends MerchantProductsStates {}

// ================== LOCATION STATES ============================= //
class ServiceNotEnabledState extends MerchantProductsStates {}

class PermissionDeniedState extends MerchantProductsStates {}

class PermissionDeniedForEverState extends MerchantProductsStates {}

class CurrentPreciseLocationLoadingState extends MerchantProductsStates {}

class CurrentPreciseLocationSuccessState extends MerchantProductsStates {}

class CurrentPreciseLocationFailState extends MerchantProductsStates {}

// ========================  GET CATEGORIES  ========================== //

class GetCategoriesLoadingState extends MerchantProductsStates {}

class GetCategoriesSuccessState extends MerchantProductsStates {}

class GetCategoriesFailedState extends MerchantProductsStates {
  final String msg;

  GetCategoriesFailedState({required this.msg});
}

// ========================  GET PRODUCTS  ========================== //

class GetProductsLoadingState extends MerchantProductsStates {}

class GetProductsSuccessState extends MerchantProductsStates {}

class GetProductsFailedState extends MerchantProductsStates {
  final String message;

  GetProductsFailedState({required this.message});
}

// ========================  GET CLIENTS  ========================== //

class GetClientsLoadingState extends MerchantProductsStates {}

class GetClientsSuccessState extends MerchantProductsStates {}

class GetClientsFailedState extends MerchantProductsStates {
  final String message;

  GetClientsFailedState({required this.message});
}

// ========================  DELETE NEW PRODUCT  ========================== //
class DeleteProductLoadingState extends MerchantProductsStates {}

class DeleteProductSuccessState extends MerchantProductsStates {}

class DeleteProductFailState extends MerchantProductsStates {
  final String message;

  DeleteProductFailState({required this.message});
}

// ========================  ADD NEW PRODUCT  ========================== //

class AddProductLoadingState extends MerchantProductsStates {}

class AddProductSuccessState extends MerchantProductsStates {}

class AddProductFailState extends MerchantProductsStates {
  final String message;

  AddProductFailState({required this.message});
}

// ====================== //
class UpdateImageSelectionState extends MerchantProductsStates {}

// ======================================== //
class UpdateProductToCartState extends MerchantProductsStates {}

// ================= ORDER STATES ====================== //
class AddOrderLoadingState extends MerchantProductsStates {}

class AddOrderSuccessState extends MerchantProductsStates {
  final String orderId;

  AddOrderSuccessState({required this.orderId});
}

class AddOrderFailState extends MerchantProductsStates {
  final String message;

  AddOrderFailState({required this.message});
}

// ================== PRODUCT CATEGORIES STATES ============== //
class ProductCategoriesLoadingState extends MerchantProductsStates {}

class ProductCategoriesSuccessState extends MerchantProductsStates {}

class ProductCategoriesFailState extends MerchantProductsStates {
  final String message;

  ProductCategoriesFailState({required this.message});
}

// ========================  GET GOVERNORATE ========================== //

class GetGovernorateLoadingState extends MerchantProductsStates {}

class GetGovernorateSuccessState extends MerchantProductsStates {}

class GetGovernorateFailState extends MerchantProductsStates {
  final String message;

  GetGovernorateFailState({required this.message});
}
// ========================  GET GOVERNORATE ========================== //

class GetCitiesLoadingState extends MerchantProductsStates {}

class GetCitiesSuccessState extends MerchantProductsStates {}

class GetCitiesFailState extends MerchantProductsStates {
  final String message;

  GetCitiesFailState({required this.message});
}

class ChangeCityPriceState extends MerchantProductsStates {}

class ChangeRequestDriverTotalPrice extends MerchantProductsStates {}

class ChangeLocationState extends MerchantProductsStates {}

class ConfigLoadingState extends MerchantProductsStates {}

class ConfigSuccessState extends MerchantProductsStates {}

class ConfigFailState extends MerchantProductsStates {
  final String message;

  ConfigFailState({required this.message});
}
