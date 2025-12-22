import 'package:bastoga/modules/auth/data/models/region_city_model.dart';

import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.displayName,
    required super.image,
    required super.username,
    required super.active,
    required super.roles,
    required super.phone,
    required super.coverImages,
    required super.commissionPercent,
    required super.commissionAmount,
    required super.about,
    required super.totalOrders,
    required super.balance,
    required super.ratingCount,
    required super.ratingAvg,
    required super.merchantShippingPrice,
    required super.driverShippingPrice,
    required super.region,
    required super.city,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['_id'],
    displayName: json['displayName'],
    image: json['image'],
    username: json['username'],
    active: json['active'],
    roles: List<String>.from(json['roles'].map((e) => e)),
    phone: json['phone'],
    coverImages: List<String>.from(json['coverImages'].map((e) => e)),
    commissionPercent: json['commissionPercent'],
    commissionAmount: json['commissionAmount'],
    about: json['about'],
    totalOrders: json['totalOrders'] ?? 0,
    balance: json['balance'] ?? 0,
    ratingCount: json['ratingCount'] ?? 0,
    ratingAvg: json['ratingAvg'] ?? 0,
    merchantShippingPrice: json['merchantShippingPrice'] ?? 0,
    driverShippingPrice: json['driverShippingPrice'] ?? 0,
    region: json['region'] != null ? RegionAndCityModel.fromJson(json['region']) : null,
    city: json['city'] != null ? RegionAndCityModel.fromJson(json['city']) : null,
  );
}

//{
//     "_id": "667f656806d612af9d982eaa",
//     "displayName": "Abdo Alaa",
//     "image": "",
//     "username": "abdullah",
//     "roles": [
//         "client"
//     ],
//     "active": true,
//     "phone": "201012345694",
//     "coverImages": [],
//     "commissionPercent": 0,
//     "commissionAmount": 0,
//     "about": "",
//     "totalOrders": 0,
//     "balance": 0,
//     "ratingCount": 0,
//     "ratingAvg": 0,
//     "merchantShippingPrice": 0,
//     "driverShippingPrice": 0,
//     "region": "667ebd2606d612af9d982dda",
//     "city": "667ebd2606d612af9d982dda",
//     "createdAt": "2024-06-29T01:37:44.873Z",
//     "updatedAt": "2024-06-29T01:37:44.873Z",
//     "__v": 0
// }
