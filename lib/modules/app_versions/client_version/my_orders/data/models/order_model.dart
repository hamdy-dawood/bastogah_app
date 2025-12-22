import '../../../../../auth/data/models/region_city_model.dart';
import '../../domain/entities/orders.dart';

class OrderModel extends Orders {
  OrderModel({
    required super.id,
    // required super.merchantId,
    required super.merchantName,
    required super.merchantPhone,
    required super.billNo,
    required super.items,
    required super.itemsPrice,
    required super.shippingPrice,
    required super.clientPrice,
    required super.driverPrice,
    required super.driverPaid,
    required super.appPrice,
    required super.merchantPrice,
    required super.merchantPaid,
    required super.shippingProfit,
    required super.client,
    required super.clientName,
    required super.address,
    required super.phone,
    required super.locationLat,
    required super.locationLng,
    required super.deleted,
    required super.driverName,
    required super.driverLat,
    required super.driverLng,
    required super.status,
    required super.createdAt,
    required super.canceledReason,
    required super.merchantLocation,
    required super.distance,
    required super.region,
    required super.city,
    required super.totalAppliedDiscount,
    required super.discountDiff,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['_id'],
    // merchantId: json['merchant'] is Map ? MerchantPhoneModel.fromJson(json['merchant']) : json['merchant'],
    merchantName: json['merchantName'],
    merchantPhone:
        json['merchant'] is Map ? MerchantPhoneModel.fromJson(json['merchant']).phone : "",
    billNo: json['billNo'],
    items: List<ProductItemModel>.from(json['items'].map((e) => ProductItemModel.fromJson(e))),
    itemsPrice: json['itemsPrice'],
    shippingPrice: json['shippingPrice'],
    clientPrice: json['clientPrice'],
    driverPrice: json['driverPrice'],
    driverPaid: json['driverPaid'],
    appPrice: json['appPrice'],
    merchantPrice: json['merchantPrice'],
    merchantPaid: json['merchantPaid'],
    shippingProfit: json['shippingProfit'],
    client:
        json['client'] != null && json['client'] is Map
            ? ClientModel.fromJson(json['client'])
            : null,
    clientName: json['clientName'],
    address: json['address'],
    phone: json['phone'],
    locationLat: json['locationLat'],
    locationLng: json['locationLng'],
    deleted: json['deleted'],
    driverName: json['driverName'],
    driverLat: json['driverLat'],
    driverLng: json['driverLng'],
    status: json['status'],
    createdAt: json['createdAt'],
    canceledReason: json['cancelReason'] ?? "",
    merchantLocation: MerchantLocationModel.fromJson(json['merchantLocation']),
    distance: json['distance'],
    region:
        json['region'] != null && json['region'] is Map
            ? RegionAndCityModel.fromJson(json['region'])
            : null,
    city:
        json['city'] != null && json['city'] is Map
            ? RegionAndCityModel.fromJson(json['city'])
            : null,
    totalAppliedDiscount: json['totalAppliedDiscount'] ?? 0,
    discountDiff: json['discountDiff'] ?? 0,
  );
}

class ProductItemModel extends ProductItem {
  ProductItemModel({
    required super.product,
    required super.productName,
    required super.price,
    required super.qty,
    required super.totalPrice,
    required super.notes,
    required super.totalDiscount,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) => ProductItemModel(
    product: json['product'],
    productName: json['productName'],
    price: json['price'],
    qty: json['qty'],
    totalPrice: json['totalPrice'],
    notes: json['notes'],
    totalDiscount: json['totalDiscount'] ?? 0,
  );
}

class MerchantLocationModel extends MerchantLocation {
  MerchantLocationModel({required super.coordinates});

  factory MerchantLocationModel.fromJson(Map<String, dynamic> json) =>
      MerchantLocationModel(coordinates: List<num>.from(json['coordinates'].map((e) => e)));
}

class ClientModel extends Client {
  ClientModel({required super.id, required super.region, required super.city});

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json['_id'],
    region: json['region'] != null ? RegionAndCityModel.fromJson(json['region']) : null,
    city: json['city'] != null ? RegionAndCityModel.fromJson(json['city']) : null,
  );
}

class MerchantPhoneModel extends MerchantPhone {
  MerchantPhoneModel({required super.id, required super.phone});

  factory MerchantPhoneModel.fromJson(Map<String, dynamic> json) =>
      MerchantPhoneModel(id: json['_id'], phone: json['phone']);
}

//{
//         "_id": "667f015b06d612af9d982e79",
//         "merchant": "667e606706d612af9d982ad6",
//         "merchantName": "hamorrrrto",
//         "billNo": "00001",
//         "items": [
//             {
//                 "product": "667c0f358686ddc2441e9480",
//                 "productName": "product",
//                 "price": 100,
//                 "qty": 1,
//                 "totalPrice": 100
//             }
//         ],
//         "itemsPrice": 100,
//         "shippingPrice": 100,
//         "clientPrice": 200,
//         "driverPrice": 0,
//         "driverPaid": false,
//         "appPrice": 24,
//         "merchantPrice": 0,
//         "merchantPaid": false,
//         "shippingProfit": 0,
//         "client": "667c0f358686ddc2441e9480",
//         "clientName": "Morad Abdelgaber",
//         "address": "Mitghamr,Dakaliya, Egypt",
//         "phone": "201010558269",
//         "locationLat": 20,
//         "locationLng": 20,
//         "deleted": false,
//         "status": 0,
//         "driverName": "",
//         "driverLat": 0,
//         "driverLng": 0,
//         "createdAt": "2024-06-28T18:30:51.197Z",
//         "updatedAt": "2024-06-28T18:30:51.197Z",
//         "__v": 0
//     }
