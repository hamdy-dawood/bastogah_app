import 'package:bastoga/modules/app_versions/client_version/home/data/models/merchant_model.dart';

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.images,
    required super.name,
    required super.desc,
    required super.isNew,
    required super.isPopular,
    required super.isActive,
    required super.price,
    required super.discountAmount,
    required super.finalPrice,
    required super.merchant,
    required super.quantity,
    required super.mySellPrice,
    required super.notes,
    required super.category,
    required super.discount,
    required super.appliedDiscount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    quantity: json['quantity'] ?? 1,
    mySellPrice: json['mySellPrice'] ?? json['finalPrice'],
    notes: json['notes'] ?? '',
    id: json['_id'],
    images: List<String>.from(json['images'].map((e) => e)),
    name: json['name'],
    desc: json['desc'],
    isNew: json['new'],
    isPopular: json['popular'],
    isActive: json['active'] ?? true,
    price: json['price'],
    discountAmount: json['discountAmount'],
    finalPrice: json['finalPrice'],
    merchant:
        json['merchant'] == null
            ? null
            : json['merchant'] is Map
            ? MerchantModel.fromJson(json['merchant'])
            : json['merchant'],
    category: json['category'],
    discount: json['discount'] ?? "",
    appliedDiscount: json['appliedDiscount'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'mySellPrice': mySellPrice,
    '_id': id,
    'images': images,
    'name': name,
    'desc': desc,
    'new': isNew,
    'popular': isPopular,
    'price': price,
    'discountAmount': discountAmount,
    'finalPrice': finalPrice,
    'merchant': merchant,
    'category': category,
    'notes': notes,
    'discount': discount,
    'appliedDiscount': appliedDiscount,
  };
}
