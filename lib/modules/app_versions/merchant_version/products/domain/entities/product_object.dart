import 'package:flutter/material.dart';

import '../../../../client_version/home/domain/entities/product.dart';

class ProductObject {
  final bool isEdit;
  final BuildContext blocContext;
  final Product? product;

  ProductObject({required this.isEdit, required this.blocContext, this.product});
}
