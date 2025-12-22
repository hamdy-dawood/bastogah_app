import '../../domain/entities/region.dart';

class RegionAndCityModel extends RegionAndCity {
  RegionAndCityModel({required super.id, required super.name, super.price});

  factory RegionAndCityModel.fromJson(Map<String, dynamic> json) =>
      RegionAndCityModel(id: json['_id'], name: json['name'], price: json['price'] ?? 0);
}
