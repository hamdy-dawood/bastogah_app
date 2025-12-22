import '../../domain/entities/product.dart';

class AppliedDiscountResult {
  final Product item;
  final num appliedDiscount;
  final num unAppliedDiscount;

  // final double finalLineTotal; // lineTotal - appliedDiscount

  AppliedDiscountResult({
    required this.item,
    required this.appliedDiscount,
    required this.unAppliedDiscount,
  });
}

class DiscountApplier {
  static List<AppliedDiscountResult> applyMaxDiscounts({
    required List<Product> cartItems,
    required num maxDiscountPerOrder,
  }) {
    num remaining = maxDiscountPerOrder;
    List<AppliedDiscountResult> results = [];

    for (var item in cartItems) {
      num desired = item.discountAmount * item.quantity;

      num applied = 0.0;
      if (remaining > 0) {
        applied = desired <= remaining ? desired : remaining;
        remaining -= applied;
      } else {
        applied = 0.0;
      }
      num unApplied = (desired - applied).clamp(0, double.infinity);

      item.appliedDiscount = applied;

      results.add(
        AppliedDiscountResult(item: item, appliedDiscount: applied, unAppliedDiscount: unApplied),
      );
    }

    return results;
  }
}
