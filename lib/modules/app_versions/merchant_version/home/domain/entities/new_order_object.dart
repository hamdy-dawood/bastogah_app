import 'package:flutter/material.dart';

class NewOrderObject {
  final BuildContext blocContext;
  final double itemsPrice;
  final String merchantId;
  final num maxDiscount;
  final num totalAppliedDiscount;

  NewOrderObject({
    required this.blocContext,
    required this.itemsPrice,
    required this.merchantId,
    required this.maxDiscount,
    required this.totalAppliedDiscount,
  });
}
