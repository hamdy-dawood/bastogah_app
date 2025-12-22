import '../../domain/entities/merchant.dart';

class MerchantModel extends Merchant {
  MerchantModel({
    required super.maxDiscount,
    required super.id,
    required super.displayName,
    required super.image,
    required super.coverImages,
    required super.about,
    required super.openTime,
    required super.closeTime,
    required super.discount,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) => MerchantModel(
    maxDiscount: json['maxDiscount'] ?? 0,
    id: json['_id'],
    displayName: json['displayName'],
    image: json['image'] ?? "",
    coverImages:
        json['coverImages'] != null
            ? List<String>.from(json['coverImages'].map((e) => e))
            : const [],
    about: json['about'] ?? "",
    openTime: json['openTime'] ?? "",
    closeTime: json['closeTime'] ?? "",
    discount:
        json['discount'] != null && json['discount'] is Map
            ? DiscountModel.fromJson(json['discount'])
            : null,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'maxDiscount': maxDiscount,
    'displayName': displayName,
    'image': image,
    'coverImages': coverImages,
    'about': about,
    'openTime': openTime,
    'closeTime': closeTime,
  };
}

class MappingModel extends Mapping {
  MappingModel({required super.id, required super.name});

  factory MappingModel.fromJson(Map<String, dynamic> json) =>
      MappingModel(id: json['_id'], name: json['name']);
}

class DiscountModel extends Discount {
  DiscountModel({
    required super.discountPercent,
    required super.startDate,
    required super.endDate,
    required super.active,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
    discountPercent: json["discountPercent"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "discountPercent": discountPercent,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "active": active,
  };
}
