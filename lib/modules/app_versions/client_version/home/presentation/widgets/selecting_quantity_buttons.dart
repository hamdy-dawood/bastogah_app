import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';

class SelectingQuantityButtons extends StatelessWidget {
  final int quantity;
  final double totalPrice;
  final num discount;
  final void Function() increaseFunction;
  final void Function() decreaseFunction;
  final Color minusButtonColor;
  final bool viewBefore;

  const SelectingQuantityButtons({
    super.key,
    required this.quantity,
    required this.totalPrice,
    this.discount = 0,
    required this.increaseFunction,
    required this.decreaseFunction,
    required this.minusButtonColor,
    this.viewBefore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// add button
            InkWell(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: increaseFunction,
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.defaultColor,
                child: Icon(Icons.add, size: 15, color: Colors.white),
              ),
            ),

            SizedBox(width: 34, child: Text('$quantity', textAlign: TextAlign.center, maxLines: 1)),

            /// minus button
            InkWell(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: decreaseFunction,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: quantity > 1 ? AppColors.defaultColor : minusButtonColor,
                child: const Padding(
                  padding: EdgeInsets.only(top: 7.0),
                  child: Icon(Icons.maximize, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (viewBefore)
                if (discount > 0)
                  CustomText(
                    text: "${AppConstance.currencyFormat.format(totalPrice + discount)} د.ع",
                    color: AppColors.redE7,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textDecoration: TextDecoration.lineThrough,
                  ),
              CustomText(
                text: "${AppConstance.currencyFormat.format(totalPrice)} د.ع",
                color: AppColors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

///=======================================================================================

class CartSelectingQuantityButtons extends StatelessWidget {
  final int quantity;
  final double totalPrice;
  final num discount;
  final void Function() increaseFunction;
  final void Function() decreaseFunction;
  final Color minusButtonColor;
  final bool viewBefore;

  const CartSelectingQuantityButtons({
    super.key,
    required this.quantity,
    required this.totalPrice,
    this.discount = 0,
    required this.increaseFunction,
    required this.decreaseFunction,
    required this.minusButtonColor,
    this.viewBefore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: decreaseFunction,
          child:
              quantity > 1
                  ? const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.defaultColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: 7.0),
                      child: Icon(Icons.maximize, size: 12, color: Colors.white),
                    ),
                  )
                  : SvgPicture.asset(
                    height: 21,
                    ImageManager.deleteIcon,
                    colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  ),
        ),
        SizedBox(width: 34, child: Text('$quantity', textAlign: TextAlign.center, maxLines: 1)),
        InkWell(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: increaseFunction,
          child: const CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.defaultColor,
            child: Icon(Icons.add, size: 15, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
