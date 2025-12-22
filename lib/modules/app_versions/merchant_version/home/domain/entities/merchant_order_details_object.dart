import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:flutter/material.dart';

class MerchantOrderDetailsObject {
  final Orders order;
  final BuildContext blocContext;
  final int tabIndex;

  MerchantOrderDetailsObject({
    required this.order,
    required this.blocContext,
    required this.tabIndex,
  });
}
