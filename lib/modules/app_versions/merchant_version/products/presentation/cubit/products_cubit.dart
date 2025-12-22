import 'dart:io';

import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/request_driver_price_field.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/networking/errors/server_errors.dart';
// import '../../../../client_version/home/domain/entities/config.dart';
import '../../../../client_version/home/domain/entities/product.dart';
import '../../../../client_version/home/presentation/widgets/city_field.dart';
import '../../../profile/domain/entities/product_categories.dart';
import '../../domain/entities/add_product_request_body.dart';
import '../../domain/entities/clients.dart';
import '../../domain/entities/product_object.dart';
import '../../domain/repository/base_merchant_products_repository.dart';
import '../widgets/product_price_field.dart';
import 'products_states.dart';

class MerchantProductsCubit extends Cubit<MerchantProductsStates> {
  final BaseMerchantProductsRepository baseMerchantProductsRepository;

  MerchantProductsCubit(this.baseMerchantProductsRepository)
    : super(MerchantProductsInitialState());

  num finalPrice = 0;

  void calculateFinalPrice({required ProductObject productObject}) {
    num productPrice = num.parse(ProductPriceField.productPriceController.text);
    finalPrice = productPrice - (productObject.product?.discountAmount ?? 0);
    emit(UpdateImageSelectionState());
  }

  List<ProductCategories>? productCategories;

  Future getProductCategories() async {
    emit(ProductCategoriesLoadingState());

    final Either<ServerError, List<ProductCategories>> result =
        await baseMerchantProductsRepository.getProductCategories();

    result.fold((l) => emit(ProductCategoriesFailState(message: l.errorMessageModel.message)), (r) {
      productCategories = r;
      emit(ProductCategoriesSuccessState());
    });
  }

  List<Product>? products;

  Future getProducts({
    required int page,
    required String productCategory,
    required String search,
  }) async {
    if (page == 0) {
      emit(GetProductsLoadingState());

      final Either<ServerError, List<Product>> result = await baseMerchantProductsRepository
          .getProducts(page: page, search: search, productCategory: productCategory);

      result.fold((l) => emit(GetProductsFailedState(message: l.errorMessageModel.message)), (r) {
        products = r;
        emit(GetProductsSuccessState());
      });
    } else {
      final Either<ServerError, List<Product>> result = await baseMerchantProductsRepository
          .getProducts(page: page, search: search, productCategory: productCategory);

      result.fold((l) => emit(GetProductsFailedState(message: l.errorMessageModel.message)), (r) {
        products!.addAll(r);
        emit(GetProductsSuccessState());
      });
    }
  }

  // ========================= PICK IMAGES ============================= //
  // list of files to save files locally before upload
  List<File> productImages = [];
  List<MultipartFile> productImageFiles = [];

  // list of strings to view in edit page in case need to remove or something
  List<String> myProductImages = [];

  Future pickProductImages() async {
    try {
      List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

      for (XFile image in pickedImages) {
        productImages.add(File(image.path));
        productImageFiles.add(
          MultipartFile.fromFileSync(
            image.path,
            filename: image.name,
            contentType: MediaType('image', image.name.split('.').last),
          ),
        );
      }

      emit(UpdateImageSelectionState());
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void removeProductImages({required int imageIndex}) {
    if (imageIndex < myProductImages.length) {
      myProductImages.removeAt(imageIndex);
      emit(UpdateImageSelectionState());
    } else {
      productImages.removeAt(imageIndex - myProductImages.length);
      productImageFiles.removeAt(imageIndex - myProductImages.length);
      emit(UpdateImageSelectionState());
    }
  }

  // Future uploadImages({
  //   required AddProductRequestBody addProductRequestBody,
  // }) async {}

  // ===================== ADD PRODUCT ====================== //
  Future addProduct({required AddProductRequestBody addProductRequestBody}) async {
    emit(AddProductLoadingState());

    FormData formData = FormData.fromMap({'images': productImageFiles});

    final Either<ServerError, List<String>> response = await baseMerchantProductsRepository
        .uploadImages(data: formData);
    response.fold(
      (l) {
        emit(AddProductFailState(message: l.errorMessageModel.message));
      },
      (r) async {
        addProductRequestBody.images.addAll(r);
        // myProductImages = r;
        final Either<ServerError, String> response = await baseMerchantProductsRepository
            .addProduct(addProductRequestBody: addProductRequestBody);

        response.fold((l) => emit(AddProductFailState(message: l.errorMessageModel.message)), (r) {
          emit(AddProductSuccessState());
        });
      },
    );
  }

  Future deleteProduct({required String id}) async {
    emit(DeleteProductLoadingState());
    final Either<ServerError, void> response = await baseMerchantProductsRepository.deleteProduct(
      id: id,
    );

    response.fold((l) => emit(DeleteProductFailState(message: l.errorMessageModel.message)), (r) {
      emit(DeleteProductSuccessState());
    });
  }

  // =================== EDIT PRODUCT ===================== //
  Future editProduct({required AddProductRequestBody addProductRequestBody}) async {
    emit(AddProductLoadingState());

    if (productImages.isNotEmpty) {
      FormData formData = FormData.fromMap({'images': productImageFiles});

      final Either<ServerError, List<String>> response = await baseMerchantProductsRepository
          .uploadImages(data: formData);
      response.fold(
        (l) {
          emit(AddProductFailState(message: l.errorMessageModel.message));
        },
        (r) async {
          addProductRequestBody.images.addAll(r);
          // myProductImages = r;
          final Either<ServerError, String> response = await baseMerchantProductsRepository
              .editProduct(addProductRequestBody: addProductRequestBody);

          response.fold((l) => emit(AddProductFailState(message: l.errorMessageModel.message)), (
            r,
          ) {
            emit(AddProductSuccessState());
          });
        },
      );
    } else {
      final Either<ServerError, String> response = await baseMerchantProductsRepository.editProduct(
        addProductRequestBody: addProductRequestBody,
      );

      response.fold((l) => emit(AddProductFailState(message: l.errorMessageModel.message)), (r) {
        emit(AddProductSuccessState());
      });
    }
  }

  // ==================== GET CLIENTS ===================== //
  List<Clients>? clients;

  Future getClients({required int page}) async {
    if (page == 0) {
      emit(GetClientsLoadingState());

      final Either<ServerError, List<Clients>> result = await baseMerchantProductsRepository
          .getClients(page: page);

      result.fold((l) => emit(GetClientsFailedState(message: l.errorMessageModel.message)), (r) {
        clients = r;
        emit(GetClientsSuccessState());
      });
    } else {
      final Either<ServerError, List<Clients>> result = await baseMerchantProductsRepository
          .getClients(page: page);

      result.fold((l) => emit(GetClientsFailedState(message: l.errorMessageModel.message)), (r) {
        clients!.addAll(r);
        emit(GetClientsSuccessState());
      });
    }
  }

  List<Product> cubitCartCount = [];

  void addProductInCartCubit(Product product) {
    increaseProductInCart(product: product);
    cubitCartCount.add(product);
    debugPrint('---- ${cubitCartCount.length}');
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

  // ====================================================//

  // Config? config;
  //
  // Future getConfig() async {
  //   emit(ConfigLoadingState());
  //
  //   final Either<ServerError, Config> result = await baseMerchantProductsRepository.getConfig();
  //
  //   result.fold(
  //         (l) => emit(ConfigFailState(message: l.errorMessageModel.message)),
  //         (r) {
  //       config = r;
  //       emit(ConfigSuccessState());
  //     },
  //   );
  // }

  // ============== ADD MERCHANT ORDER ===================== //
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
    num? maxDiscount,
  }) async {
    emit(AddOrderLoadingState());

    final Either<ServerError, String> result = await baseMerchantProductsRepository.addOrder(
      items: items,
      itemsPrice: itemsPrice,
      totalDiscount: totalDiscount,
      totalAppliedDiscount: totalAppliedDiscount,
      discountDiff: discountDiff,
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
      maxDiscount: maxDiscount ?? -1,
    );

    result.fold((l) => emit(AddOrderFailState(message: l.errorMessageModel.message)), (r) {
      emit(AddOrderSuccessState(orderId: r));
    });
  }

  // ========================  GET GOVERNORATE ========================== //

  List<RegionAndCityModel>? governorates;

  Future getGovernorate() async {
    emit(GetGovernorateLoadingState());

    final Either<ServerError, List<RegionAndCityModel>> response =
        await baseMerchantProductsRepository.getGovernorate();

    response.fold((l) => emit(GetGovernorateFailState(message: l.errorMessageModel.message)), (r) {
      governorates = r;
      emit(GetGovernorateSuccessState());
    });
  }

  // ========================  GET CITIES ========================== //

  List<RegionAndCityModel>? cities;

  Future getCities({required String region}) async {
    if (region.isEmpty) {
      cities = null;
      emit(GetCitiesFailState(message: 'Please select a region first'));
      return;
    }
    emit(GetCitiesLoadingState());

    final Either<ServerError, List<RegionAndCityModel>> response =
        await baseMerchantProductsRepository.getCities(region: region);

    response.fold((l) => emit(GetCitiesFailState(message: l.errorMessageModel.message)), (r) {
      cities = r;
      emit(GetCitiesSuccessState());
    });
  }

  //================================================================
  // double? cityPrice;
  //
  // void changeCityPrice({required double price}) {
  //   cityPrice = price;
  //   emit(ChangeCityPriceState());
  // }

  //================================================================
  String requestDriverTotalPrice = "0";

  void changeRequestDriverTotalPrice() {
    String client = RequestDriverPriceField.requestDriverPriceController.text;
    double? shipping = CityField.cityPrice;

    double clientPrice = double.parse(client.isNotEmpty ? client : "0");
    double shippingPrice = shipping ?? 0;

    requestDriverTotalPrice = "${clientPrice + shippingPrice}";

    emit(ChangeRequestDriverTotalPrice());
  }

  //============================================================================

  double latitude = 0;
  double longitude = 0;

  void changeLocation({required double selectedLatitude, required double selectedLongitude}) {
    latitude = selectedLatitude;
    longitude = selectedLongitude;
    emit(ChangeLocationState());
  }
}
