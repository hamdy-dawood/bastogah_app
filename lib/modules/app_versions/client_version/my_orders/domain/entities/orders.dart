import '../../../../../auth/domain/entities/region.dart';

class Orders {
  final String id;

  // final dynamic merchantId;
  final String merchantName;
  final String merchantPhone;
  final String billNo;
  final List<ProductItem> items;
  final num itemsPrice;
  final num shippingPrice;
  final num clientPrice;
  final num driverPrice;
  final bool driverPaid;
  final num appPrice;
  final num merchantPrice;
  final bool merchantPaid;
  final num shippingProfit;
  final Client? client;
  final String clientName;
  final String address;
  final String phone;
  final num locationLat;
  final num locationLng;
  final bool deleted;
  String driverName;
  final num driverLat;
  final num driverLng;
  final num status;
  final String createdAt;
  final String canceledReason;
  final MerchantLocation merchantLocation;
  final num? distance;
  final RegionAndCity? region;
  final RegionAndCity? city;
  final num totalAppliedDiscount;
  final num discountDiff;

  Orders({
    required this.id,
    // required this.merchantId,
    required this.merchantName,
    required this.merchantPhone,
    required this.billNo,
    required this.items,
    required this.itemsPrice,
    required this.shippingPrice,
    required this.clientPrice,
    required this.driverPrice,
    required this.driverPaid,
    required this.appPrice,
    required this.merchantPrice,
    required this.merchantPaid,
    required this.shippingProfit,
    required this.client,
    required this.clientName,
    required this.address,
    required this.phone,
    required this.locationLat,
    required this.locationLng,
    required this.deleted,
    required this.driverName,
    required this.driverLat,
    required this.driverLng,
    required this.status,
    required this.createdAt,
    required this.canceledReason,
    required this.merchantLocation,
    required this.distance,
    required this.region,
    required this.city,
    required this.totalAppliedDiscount,
    required this.discountDiff,
  });
}

class ProductItem {
  final String product;
  final String productName;
  final num price;
  final num qty;
  final num totalDiscount;
  final num totalPrice;
  final String notes;

  ProductItem({
    required this.product,
    required this.productName,
    required this.price,
    required this.qty,
    required this.totalDiscount,
    required this.totalPrice,
    required this.notes,
  });
}

class MerchantLocation {
  final List<num> coordinates;

  MerchantLocation({required this.coordinates});
}

class Client {
  final String id;
  final RegionAndCity? region;
  final RegionAndCity? city;

  Client({required this.id, required this.region, required this.city});
}

class MerchantPhone {
  final String id;
  final String phone;

  MerchantPhone({required this.id, required this.phone});
}
