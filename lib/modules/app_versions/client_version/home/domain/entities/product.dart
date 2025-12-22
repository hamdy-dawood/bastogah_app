class Product {
  int quantity;
  num mySellPrice;
  String notes;
  num? appliedDiscount;

  final String id;
  final List<String> images;
  final String name;
  final String desc;
  final bool isNew;
  final bool isPopular;
  final bool isActive;
  final num price;
  final num discountAmount;
  final num finalPrice;
  final dynamic merchant;
  final String? category;
  final String? discount;

  Product({
    required this.quantity,
    required this.mySellPrice,
    required this.notes,
    required this.id,
    required this.images,
    required this.name,
    required this.desc,
    required this.isNew,
    required this.isPopular,
    required this.isActive,
    required this.price,
    required this.discountAmount,
    required this.finalPrice,
    required this.merchant,
    required this.category,
    required this.discount,
    required this.appliedDiscount,
  });
}
