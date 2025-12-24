import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/merchant.dart';

class StoreNameSection extends StatelessWidget {
  final void Function()? onTap;
  final Merchant merchant;

  const StoreNameSection({super.key, this.onTap, required this.merchant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('${AppConstance.imagePathApi}${merchant.image}'),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(merchant.displayName, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                // RatingBoxWidget(
                //   color: AppColors.defaultColor,
                //   rating: merchant.ratingAvg.toString(),
                // ),
              ],
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
