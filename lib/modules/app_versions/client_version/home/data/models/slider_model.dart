import 'package:bastoga/modules/app_versions/client_version/home/data/models/merchant_model.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/models/product_model.dart';

import '../../domain/entities/slider.dart';
import 'categories_model.dart';

class SliderModel extends Sliders {
  SliderModel({
    required super.id,
    required super.image,
    required super.videoLink,
    required super.name,
    required super.product,
    required super.merchant,
    required super.merchantCategory,
    required super.isDiscount,
    required super.deleted,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    id: json['_id'],
    image: json['image'],
    videoLink: json['videoLink'] ?? "",
    name: json['name'],
    product: json['product'] != null ? ProductModel.fromJson(json['product']) : null,
    merchant: json['merchant'] != null ? MerchantModel.fromJson(json['merchant']) : null,
    merchantCategory:
        json['merchantCategory'] != null
            ? CategoriesModel.fromJson(json['merchantCategory'])
            : null,
    deleted: json['deleted'],
    isDiscount: json['isDiscount'] ?? false,
  );
}
