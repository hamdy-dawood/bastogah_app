import 'package:flutter/material.dart';

import 'orders.dart';

class ClientDriverOrderDetailsObject {
  final Orders order;
  final BuildContext blocContext;
  final bool isDriver;

  ClientDriverOrderDetailsObject({
    required this.order,
    required this.blocContext,
    required this.isDriver,
  });
}
