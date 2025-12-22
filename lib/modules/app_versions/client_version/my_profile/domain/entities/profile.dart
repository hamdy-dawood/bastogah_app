import '../../../../../auth/domain/entities/region.dart';

class Profile {
  final String id;
  final String displayName;
  final String image;
  final String username;
  final bool active;
  final List<String> roles;
  final String phone;
  final List<String> coverImages;
  final num? commissionPercent;
  final num? commissionAmount;
  final String about;
  final int totalOrders;
  final num balance;
  final num ratingCount;
  final num ratingAvg;
  final num merchantShippingPrice;
  final num driverShippingPrice;
  final RegionAndCity? region;
  final RegionAndCity? city;

  Profile({
    required this.id,
    required this.displayName,
    required this.image,
    required this.username,
    required this.active,
    required this.roles,
    required this.phone,
    required this.coverImages,
    required this.commissionPercent,
    required this.commissionAmount,
    required this.about,
    required this.totalOrders,
    required this.balance,
    required this.ratingCount,
    required this.ratingAvg,
    required this.merchantShippingPrice,
    required this.driverShippingPrice,
    required this.region,
    required this.city,
  });
}
