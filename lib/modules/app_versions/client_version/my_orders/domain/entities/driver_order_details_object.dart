import 'package:bastoga/modules/app_versions/driver_version/home/presentation/cubit/driver_home_cubit.dart';

import 'orders.dart';

class ClientOrderDetailsObject {
  final Orders order;
  final bool isDriver;

  ClientOrderDetailsObject({required this.order, required this.isDriver});
}

class ClientDriverOrderDetailsObject {
  final Orders order;
  final DriverHomeCubit cubit;
  final bool isDriver;

  ClientDriverOrderDetailsObject({
    required this.order,
    required this.cubit,
    required this.isDriver,
  });
}
