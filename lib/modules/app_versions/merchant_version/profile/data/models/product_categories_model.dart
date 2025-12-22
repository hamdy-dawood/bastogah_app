import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/entities/product_categories.dart';

class ProductCategoriesModel extends ProductCategories {
  ProductCategoriesModel({
    required super.id,
    required super.name,
    required super.merchant,
    required super.deleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductCategoriesModel.fromJson(Map<String, dynamic> json) => ProductCategoriesModel(
    id: json['_id'],
    name: json['name'],
    merchant: json['merchant'],
    deleted: json['deleted'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}
