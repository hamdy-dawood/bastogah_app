import '../../domain/entities/sub_category.dart';

class SubCategoryModel extends SubCategory {
  SubCategoryModel({
    required super.id,
    required super.category,
    required super.name,
    required super.createdAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    id: json['_id'],
    category: json['category'],
    name: json['name'],
    createdAt: json['createdAt'],
  );
}
