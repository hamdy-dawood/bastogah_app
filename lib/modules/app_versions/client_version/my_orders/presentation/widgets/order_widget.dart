import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/driver_order_details_object.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../merchant_version/home/presentation/widgets/text_container.dart';

class OrderWidget extends StatelessWidget {
  final Orders order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.clientOrderDetailsScreen,
          arguments: ClientOrderDetailsObject(order: order, isDriver: false),
        );
      },
      child: Container(
        // padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey9A.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${order.billNo}', style: Theme.of(context).textTheme.titleMedium),
                  TextContainer(
                    text:
                        order.status == 0
                            ? 'قيد الانتظار'
                            : order.status == 1
                            ? 'بدون سائق'
                            : order.status == 2
                            ? 'قيد التنفيذ'
                            : order.status == 3
                            ? 'مكتمل'
                            : 'ملغي',
                    buttonColor:
                        order.status == 0 || order.status == 1
                            ? AppColors.yellowColor
                            : order.status == 2
                            ? AppColors.blue005
                            : order.status == 3
                            ? AppColors.green2Color
                            : AppColors.redE7,
                    fontColor: Colors.white,
                  ),
                  Text(
                    '${AppConstance.dateFormat.format(DateTime.parse(order.createdAt).toLocal())} في ${AppConstance.timeFormat.format(DateTime.parse(order.createdAt).toLocal())}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            AppConstance.horizontalDivider,
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('قيمة الطلب :', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 5),
                        Text(
                          '${AppConstance.currencyFormat.format((order.itemsPrice + order.shippingPrice))} د',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المطعم :', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 5),
                        Text(
                          order.merchantName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
