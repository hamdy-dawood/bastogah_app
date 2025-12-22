import 'dart:convert';

import 'package:bastoga/core/caching/shared_prefs.dart';

import '../../modules/app_versions/client_version/home/domain/entities/product.dart';
import '../utils/constance.dart';

List<Product> cart = [];

void increaseProductInCart({required Product product}) {
  for (int i = 0; i < cart.length; i++) {
    if (cart[i].id == product.id) {
      cart[i].quantity++;
      cart[i].mySellPrice = cart[i].finalPrice * cart[i].quantity;
      updateCartStorage();
      return;
    }
  }
  cart.add(product);
  updateCartStorage();
}

void decreaseProductInCart({required Product product}) {
  for (int i = 0; i < cart.length; i++) {
    if (cart[i].id == product.id) {
      cart[i].quantity--;
      cart[i].mySellPrice = cart[i].finalPrice * cart[i].quantity;
      updateCartStorage();
    }
  }
}

void removeProductInCart({required Product product}) {
  product.quantity = 1;
  product.mySellPrice = product.finalPrice;
  cart.removeWhere((element) => element.id == product.id);
  updateCartStorage();
}

void updateCartStorage() {
  List<String> cachedCartString = cart.map((e) => jsonEncode(e)).toList();
  Caching.saveListString(key: AppConstance.cartCachedKey, value: cachedCartString);
  print(Caching.getData(key: AppConstance.cartCachedKey));
}
