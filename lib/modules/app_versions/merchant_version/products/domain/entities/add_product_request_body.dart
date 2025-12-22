class AddProductRequestBody {
  final String? productId;
  final List<String> images;
  final String name;
  final double price;
  final num? finalPrice;
  final String categoryId;
  final String description;
  final bool isNew;
  final bool isPopular;
  final bool isActive;

  AddProductRequestBody({
    this.productId,
    required this.images,
    required this.name,
    required this.price,
    this.finalPrice,
    required this.categoryId,
    required this.description,
    required this.isNew,
    required this.isPopular,
    required this.isActive,
  });
}
