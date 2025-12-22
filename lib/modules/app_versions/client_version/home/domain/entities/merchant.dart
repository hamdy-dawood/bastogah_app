class Merchant {
  final num maxDiscount;
  final String id;
  final String displayName;
  final String image;
  final List<String> coverImages;
  final String about;
  final String openTime;
  final String closeTime;
  final Discount? discount;

  Merchant({
    required this.maxDiscount,
    required this.id,
    required this.displayName,
    required this.image,
    required this.coverImages,
    required this.about,
    required this.openTime,
    required this.closeTime,
    required this.discount,
  });
}

class Mapping {
  final String id;
  final String name;

  Mapping({required this.id, required this.name});
}

class Discount {
  final int discountPercent;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;

  Discount({
    required this.discountPercent,
    required this.startDate,
    required this.endDate,
    required this.active,
  });
}
