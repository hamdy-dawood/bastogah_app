import 'dart:convert';

import 'package:bastoga/core/caching/shared_prefs.dart';

import '../../modules/app_versions/client_version/home/domain/entities/product.dart';
import '../utils/constance.dart';

List<Product> favorite = [];

void toggleProductFavorite({required Product product}) {
  for (int i = 0; i < favorite.length; i++) {
    if (favorite[i].id == product.id) {
      favorite.removeAt(i);
      updateFavoriteStorage();
      return;
    }
  }
  favorite.add(product);
  updateFavoriteStorage();
}

void updateFavoriteStorage() {
  List<String> cachedFavoriteString = favorite.map((e) => jsonEncode(e)).toList();
  Caching.saveListString(key: AppConstance.favoriteCachedKey, value: cachedFavoriteString);
  print(Caching.getData(key: AppConstance.favoriteCachedKey));
}
