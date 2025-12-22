import 'package:flutter/material.dart';

import 'product.dart';

class ProductDetailsObject {
  final bool isMerchant;
  final Product product;
  final BuildContext? merchantBlocContext;

  ProductDetailsObject({
    required this.product,
    required this.isMerchant,
    required this.merchantBlocContext,
  });
}
