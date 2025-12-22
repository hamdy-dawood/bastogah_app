import 'package:flutter/material.dart';

import '../../../../../../core/utils/constance.dart';
import '../../domain/entities/orders.dart';

class OrderItems extends StatelessWidget {
  final ProductItem item;

  const OrderItems({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: 60,
          //   width: 60,
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(5),
          //     boxShadow: const [
          //       BoxShadow(
          //         color: Colors.black12,
          //         spreadRadius: 1,
          //         blurRadius: 1,
          //       ),
          //     ],
          //   ),
          //   child: Image.network(
          //     '${AppConstance.imagePathApi}${item.}',
          //     width: context.screenWidth,
          //     // fit: BoxFit.contain,
          //     filterQuality: FilterQuality.high,
          //     errorBuilder: (context, error, stackTrace) => const SizedBox(),
          //   ),
          // ),
          // const SizedBox(
          //   width: 8,
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('- ${item.notes}', style: Theme.of(context).textTheme.bodySmall),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('العدد : ${item.qty}'),
                      ),
                    ),
                    Text(
                      '${AppConstance.currencyFormat.format(item.totalPrice)} د.ع',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
