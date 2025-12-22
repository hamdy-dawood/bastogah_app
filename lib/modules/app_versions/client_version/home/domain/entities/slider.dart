import 'categories.dart';
import 'merchant.dart';
import 'product.dart';

class Sliders {
  final String id;
  final String videoLink;
  final String image;
  final String name;
  final Product? product;
  final Merchant? merchant;
  final Categories? merchantCategory;
  final bool isDiscount;
  final bool deleted;

  Sliders({
    required this.id,
    required this.videoLink,
    required this.image,
    required this.name,
    required this.product,
    required this.merchant,
    required this.merchantCategory,
    required this.deleted,
    required this.isDiscount,
  });
}
