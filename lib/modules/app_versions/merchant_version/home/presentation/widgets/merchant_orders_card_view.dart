import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/entities/merchant_order_details_object.dart';
import 'package:flutter/material.dart';

class MerchantOrdersCardView extends StatelessWidget {
  final Orders order;
  final int tabIndex;

  const MerchantOrdersCardView({super.key, required this.order, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.merchantOrderDetailsScreen,
          arguments: MerchantOrderDetailsObject(
            order: order,
            blocContext: context,
            tabIndex: tabIndex,
          ),
        );
      },
      child: Container(
        // padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 5)],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('#${order.billNo}', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  // if (order.driverName.isEmpty)
                  //   const TextContainer(
                  //     text: 'بدون سائق',
                  //     buttonColor: AppColors.redColor,
                  //     fontColor: Colors.white,
                  //   ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '${AppConstance.dateFormat.format(DateTime.parse(order.createdAt).add(const Duration(hours: 3)))} في ${AppConstance.timeFormat.format(DateTime.parse(order.createdAt).add(const Duration(hours: 3)))}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                    ),
                  ),
                  // const Icon(
                  //   Icons.more_vert,
                  //   color: AppColors.defaultColor,
                  //   size: 25,
                  // ),
                ],
              ),
            ),
            AppConstance.horizontalDivider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'هاتف العميل',
                  //         style: Theme.of(context).textTheme.bodySmall,
                  //       ),
                  //       const SizedBox(height: 8),
                  //       Text(
                  //         order.phone,
                  //         style: Theme.of(context).textTheme.bodyLarge,
                  //         textDirection: TextDirection.ltr,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الموقع :', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Text(
                          "${order.region?.name ?? order.client?.region?.name ?? ""} , ${order.city?.name ?? order.client?.city?.name ?? ""}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('نقطة دالة', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Text(
                          order.items.isEmpty ? "--" : order.address,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('السائق', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 5),
                        Text(
                          order.driverName.isNotEmpty ? order.driverName : "--",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (order.status == 2)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //     child: SvgPicture.asset(ImageManager.mapIcon),
                  //   ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('صافى المبلغ', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 5),
                        Text(
                          '${AppConstance.currencyFormat.format(order.itemsPrice)} د',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('مبلغ التوصيل', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 5),
                        Text(
                          '${AppConstance.currencyFormat.format(order.shippingPrice)} د',
                          style: Theme.of(context).textTheme.bodyMedium,
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
