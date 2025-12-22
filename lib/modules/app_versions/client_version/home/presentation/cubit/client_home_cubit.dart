import 'package:bastoga/core/caching/local_cart.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../my_profile/domain/entities/profile.dart';
import '../../domain/entities/categories.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/slider.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/repository/base_client_home_repository.dart';

part 'client_home_state.dart';

class ClientHomeCubit extends Cubit<ClientHomeStates> {
  final BaseClientHomeRepository baseClientHomeRepository;

  ClientHomeCubit(this.baseClientHomeRepository) : super(ClientHomeInitial());

  Future disableAccount() async {
    emit(DisableAccountLoadingState());

    final Either<ServerError, void> result = await baseClientHomeRepository.disableAccount();

    result.fold(
      (l) => emit(DisableAccountFailState(message: l.errorMessageModel.message)),
      (r) => emit(DisableAccountSuccessState()),
    );
  }

  // ====================================================//

  // Config? config;
  //
  // Future getConfig() async {
  //   emit(ConfigLoadingState());
  //
  //   final Either<ServerError, Config> result = await baseClientHomeRepository.getConfig();
  //
  //   result.fold(
  //         (l) => emit(ConfigFailState(message: l.errorMessageModel.message)),
  //         (r) {
  //       config = r;
  //       emit(ConfigSuccessState());
  //     },
  //   );
  // }

  // ====================================================//

  Profile? profile;

  Future getProfile() async {
    emit(ProfileLoadingState());

    final Either<ServerError, Profile> result = await baseClientHomeRepository.getProfile();

    result.fold((l) => emit(ProfileFailState(message: l.errorMessageModel.message)), (r) {
      profile = r;
      emit(ClientProfileSuccessState());
    });
  }

  //======================= LOCATION ========================//
  double? selectedLat;
  double? selectedLng;
  Position? devicePosition;
  List<Marker> markers = [];

  void changeMarkerPosition({required double latitude, required double longitude}) {
    selectedLat = latitude;
    selectedLng = longitude;
    markers.clear();
    markers.add(Marker(markerId: const MarkerId('1'), position: LatLng(latitude, longitude)));
    emit(CurrentPreciseLocationSuccessState());
  }

  Future checkLocationService() async {
    devicePosition = await myCheckLocation();
    if (devicePosition != null) {
      changeMarkerPosition(
        latitude: devicePosition!.latitude,
        longitude: devicePosition!.longitude,
      );
      emit(CurrentPreciseLocationSuccessState());
    }
  }

  Future myCheckLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(ServiceNotEnabledState());
      return;
    }

    // here we check permission to show popup to the user
    permission = await Geolocator.checkPermission();
    emit(CurrentPreciseLocationLoadingState());

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(PermissionDeniedState());
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(PermissionDeniedForEverState());
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    return position;
  }

  //=============================================//

  List<Sliders>? homeSliders;

  Future getSliders() async {
    emit(LoadingState());

    final Either<ServerError, List<Sliders>> result = await baseClientHomeRepository.getSliders();

    result.fold((l) => emit(SlidersFailState(message: l.errorMessageModel.message)), (r) {
      homeSliders = r;
      emit(SlidersSuccessState());
    });
  }

  //=============================================//

  List<Categories>? categoriesList;

  Future getCategories() async {
    emit(LoadingState());

    final Either<ServerError, List<Categories>> result =
        await baseClientHomeRepository.getCategories();

    result.fold((l) => emit(CategoriesFailState(message: l.errorMessageModel.message)), (r) {
      categoriesList = r;
      emit(CategoriesSuccessState());
    });
  }

  //===========================================//

  List<SubCategory>? subCategoriesList;

  Future getSubCategories({required String category}) async {
    emit(SubCategoriesLoadingState());

    final Either<ServerError, List<SubCategory>> result = await baseClientHomeRepository
        .getSubCategories(category: category);

    result.fold((l) => emit(SubCategoriesFailState(message: l.errorMessageModel.message)), (r) {
      subCategoriesList = r;
      emit(SubCategoriesSuccessState());
    });
  }

  //==========================================//
  bool merchantHasMore = true;
  bool isLoadingPagination = false;
  List<Merchant>? merchantList;

  Future getMerchants({
    required String search,
    required String category,
    required String subCategory,
    required int page,
  }) async {
    if (page == 0) {
      emit(MerchantLoadingState());

      final Either<ServerError, List<Merchant>> result = await baseClientHomeRepository
          .getMerchants(search: search, category: category, subCategory: subCategory, page: page);

      result.fold((l) => emit(MerchantFailState(message: l.errorMessageModel.message)), (r) {
        merchantList = r;
        if (r.length < 10) {
          merchantHasMore = false;
        }
        emit(MerchantSuccessState());
      });
    } else {
      isLoadingPagination = true;
      emit(PaginationLoadingState());
      final Either<ServerError, List<Merchant>> result = await baseClientHomeRepository
          .getMerchants(search: search, category: category, subCategory: subCategory, page: page);

      result.fold(
        (l) {
          isLoadingPagination = false;
          emit(MerchantFailState(message: l.errorMessageModel.message));
        },
        (r) {
          merchantList!.addAll(r);
          if (r.length < 10) {
            merchantHasMore = false;
          }
          isLoadingPagination = false;
          emit(MerchantSuccessState());
        },
      );
    }
  }

  //========================= GET DISCOUNT MERCHANTS ===========================//

  int page = 1;
  bool hasReachedMax = false;
  List<Merchant> discountMerchantList = [];

  Future<void> getDiscountMerchants() async {
    if (hasReachedMax) {
      return;
    }
    page == 1 ? emit(DiscountMerchantLoadingState()) : emit(DiscountMerchantMoreLoadingState());
    final response = await baseClientHomeRepository.getDiscountMerchants(page: page);

    response.fold((l) => emit(DiscountMerchantFailState(message: l.errorMessageModel.message)), (
      r,
    ) {
      if (r.isEmpty && page == 1) {
        emit(DiscountMerchantSuccessState());
        return;
      }

      if (r.isEmpty || r.length < 10) {
        hasReachedMax = true;
        discountMerchantList.addAll(r);
        emit(DiscountMerchantSuccessState());
        return;
      }
      page == 1 ? discountMerchantList = r : discountMerchantList.addAll(r);

      page++;
      emit(DiscountMerchantSuccessState());
    });
  }

  void resetDiscountMerchants() {
    page = 1;
    hasReachedMax = false;
    discountMerchantList.clear();
    getDiscountMerchants();
  }

  //==========================================//

  List<Merchant>? popularMerchantsList;
  bool popularHasMore = false;

  Future getPopularMerchants({required int page}) async {
    if (page == 0) {
      emit(LoadingState());

      final Either<ServerError, List<Merchant>> result = await baseClientHomeRepository
          .getPopularMerchants(page: page);

      result.fold((l) => emit(PopularMerchantFailState(message: l.errorMessageModel.message)), (r) {
        popularMerchantsList = r;
        popularHasMore = true;
        emit(PopularMerchantSuccessState());
      });
    } else {
      final Either<ServerError, List<Merchant>> result = await baseClientHomeRepository
          .getPopularMerchants(page: page);

      result.fold((l) => emit(PopularMerchantFailState(message: l.errorMessageModel.message)), (r) {
        if (r.length < 10) {
          popularHasMore = false;
        }
        popularMerchantsList!.addAll(r);
        emit(PopularMerchantSuccessState());
      });
    }
  }

  List<ProductCategories>? productCategories;

  Future getProductCategories({required String merchantId}) async {
    emit(GetProductCategoriesLoadingState());

    final Either<ServerError, List<ProductCategories>> result = await baseClientHomeRepository
        .getProductCategories(merchantId: merchantId);

    result.fold((l) => emit(GetProductCategoriesFailState(message: l.errorMessageModel.message)), (
      r,
    ) {
      productCategories = r;
      emit(GetProductCategoriesSuccessState());
    });
  }

  List<Product>? products;
  bool isProductPagination = false;

  Future getProducts({
    String? merchantId,
    String? productCategory,
    bool? discount,
    String? offerId,
    String? search,
    required int page,
  }) async {
    if (page == 0) {
      emit(LoadingState());

      final Either<ServerError, List<Product>> result = await baseClientHomeRepository.getProducts(
        merchantId: merchantId,
        discount: discount,
        offerId: offerId,
        productCategory: productCategory,
        search: search,
        page: page,
      );

      result.fold((l) => emit(MerchantProductsFailState(message: l.errorMessageModel.message)), (
        r,
      ) {
        products = r;
        emit(MerchantProductsSuccessState());
      });
    } else {
      isProductPagination = true;
      emit(PaginationLoadingState());
      final Either<ServerError, List<Product>> result = await baseClientHomeRepository.getProducts(
        merchantId: merchantId,
        discount: discount,
        offerId: offerId,
        productCategory: productCategory,
        search: search,
        page: page,
      );

      result.fold(
        (l) {
          isProductPagination = false;
          emit(MerchantProductsFailState(message: l.errorMessageModel.message));
        },
        (r) {
          products!.addAll(r);
          isProductPagination = false;
          emit(MerchantProductsSuccessState());
        },
      );
    }
  }

  List<Product> cubitCartCount = [];

  void addProductInCartCubit(Product product) {
    increaseProductInCart(product: product);
    cubitCartCount.add(product);
    print('---- ${cubitCartCount.length}');
    emit(UpdateProductToCartState());
  }

  void increaseProductInCartCubit(Product product) {
    final result = cart.where((p) => p.id == product.id).toList();
    if (result.isNotEmpty) {
      // product is in cart
      increaseProductInCart(product: product);
    } else {
      product.quantity++;
      product.mySellPrice = product.finalPrice * product.quantity;
    }
    emit(UpdateProductToCartState());
  }

  void decreaseProductFromCartCubit(Product product) {
    if (product.quantity > 1) {
      final result = cart.where((p) => p.id == product.id).toList();
      if (result.isNotEmpty) {
        // product is in cart
        decreaseProductInCart(product: product);
      } else {
        product.quantity--;
        product.mySellPrice = product.finalPrice * product.quantity;
      }
    } else {
      final result = cart.where((p) => p.id == product.id).toList();
      if (result.isNotEmpty) {
        // product is in cart
        cubitCartCount.removeWhere((p) => p.id == product.id);
        removeProductInCart(product: product);
      }
    }
    emit(UpdateProductToCartState());
  }

  void removeProductFromCartCubit(Product product) {
    final result = cart.where((p) => p.id == product.id).toList();
    if (result.isNotEmpty) {
      // product is in cart
      cubitCartCount.removeWhere((p) => p.id == product.id);
      removeProductInCart(product: product);
    }
    emit(UpdateProductToCartState());
  }

  void clearAllCart() {
    for (int i = 0; i < cart.length; i++) {
      cart[i].quantity = 1;
      cart[i].mySellPrice = cart[i].finalPrice;
    }
    cubitCartCount.clear();
    cart.clear();
    updateCartStorage();
    emit(UpdateProductToCartState());
  }

  Future addOrder({
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
    emit(AddOrderLoadingState());

    final Either<ServerError, String> result = await baseClientHomeRepository.addOrder(
      items: items,
      totalDiscount: totalDiscount,
      totalAppliedDiscount: totalAppliedDiscount,
      discountDiff: discountDiff,
      itemsPrice: itemsPrice,
      shippingPrice: shippingPrice,
      clientPrice: clientPrice,
      clientName: clientName,
      clientId: clientId,
      address: address,
      region: region,
      city: city,
      phone: phone,
      locationLat: locationLat,
      locationLng: locationLng,
      merchantId: merchantId,
      notes: notes,
      maxDiscount: maxDiscount,
    );

    result.fold((l) => emit(AddOrderFailState(message: l.errorMessageModel.message)), (r) {
      emit(AddOrderSuccessState());
    });
  }

  // ========================  GET GOVERNORATE ========================== //
  List<RegionAndCityModel>? searchGovernorates;

  void getSearchGovernorate(String? v) {
    if (v!.isNotEmpty) {
      var list = governorates!.where((x) => x.name.contains(v)).toList();
      searchGovernorates = list;
    } else {
      searchGovernorates = null;
    }
    emit(GetGovernorateSuccessState());
  }

  List<RegionAndCityModel>? governorates;

  Future getGovernorate() async {
    emit(GetGovernorateLoadingState());

    final Either<ServerError, List<RegionAndCityModel>> response =
        await baseClientHomeRepository.getGovernorate();

    response.fold((l) => emit(GetGovernorateFailState(message: l.errorMessageModel.message)), (r) {
      governorates = r;
      emit(GetGovernorateSuccessState());
    });
  }

  // ========================  GET CITIES ========================== //
  //search
  List<RegionAndCityModel>? searchCities;

  void getSearchCities(String? v) {
    if (v!.isNotEmpty) {
      var list = cities!.where((x) => x.name.contains(v)).toList();
      searchCities = list;
    } else {
      searchCities = null;
    }
    emit(GetGovernorateSuccessState());
  }

  List<RegionAndCityModel>? cities;

  Future getCities({required String region, required String merchant}) async {
    if (region.isEmpty) {
      cities = null;
      emit(GetCitiesFailState(message: 'Please select a region first'));
      return;
    }
    emit(GetCitiesLoadingState());

    final Either<ServerError, List<RegionAndCityModel>> response = await baseClientHomeRepository
        .getCities(region: region, merchant: merchant);

    response.fold((l) => emit(GetCitiesFailState(message: l.errorMessageModel.message)), (r) {
      cities = r;
      emit(GetCitiesSuccessState());
    });
  }

  // ========================  GET CART PRODUCTS ========================== //

  List<Product> productsList = [];

  Future<void> getCartProductsData({required String ids}) async {
    emit(GetCartProductsLoadingState());

    final response = await baseClientHomeRepository.getCartProductsData(ids: ids);

    response.fold((l) => emit(GetCartProductsFailState(message: l.errorMessageModel.message)), (r) {
      productsList = r;
      emit(GetCartProductsSuccessState());
    });
  }
}
