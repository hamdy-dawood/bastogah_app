import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/orders.dart';

class OrderItems extends StatelessWidget {
  final ProductItem item;

  const OrderItems({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.greyFC,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyF5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: 65,
          //   width: 65,
          //   clipBehavior: Clip.antiAliasWithSaveLayer,
          //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          //   child: CachedNetworkImage(
          //     imageUrl: '${AppConstance.imagePathApi}${item.image}',
          //     width: context.screenWidth,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.productName,
                  color: AppColors.black1A,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  maxLines: 3,
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  CustomText(
                    text: "- ${item.notes}",
                    color: AppColors.grey9A,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    maxLines: 10,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyE0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text('العدد  :  ${item.qty}'),
                      ),
                    ),
                    CustomText(
                      text: "${AppConstance.currencyFormat.format(item.totalPrice)} د.ع",
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
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
