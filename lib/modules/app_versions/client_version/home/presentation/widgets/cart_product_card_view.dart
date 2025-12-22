import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_details_object.dart';
import 'max_discount_applier.dart';
import 'selecting_quantity_buttons.dart';

class CartProductCardView extends StatefulWidget {
  final Product product;
  final AppliedDiscountResult? appliedDiscountResult;
  final BuildContext blocContext;
  final bool isMerchant;
  final void Function() increase;
  final void Function() decrease;
  final void Function() remove;

  const CartProductCardView({
    super.key,
    required this.product,
    this.appliedDiscountResult,
    required this.blocContext,
    required this.isMerchant,
    required this.increase,
    required this.decrease,
    required this.remove,
  });

  @override
  State<CartProductCardView> createState() => _CartProductCardViewState();
}

class _CartProductCardViewState extends State<CartProductCardView> {
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    notesController.text = widget.product.notes;
    super.initState();
  }

  num total() {
    if (widget.appliedDiscountResult != null) {
      widget.product.mySellPrice =
          (widget.appliedDiscountResult!.item.price * widget.product.quantity) -
          widget.appliedDiscountResult!.appliedDiscount;
    }
    return widget.product.mySellPrice;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.productDetailsScreen,
          arguments: ProductDetailsObject(
            product: widget.product,
            isMerchant: widget.isMerchant,
            merchantBlocContext: widget.blocContext,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey5Color),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child:
                      widget.product.images.isNotEmpty
                          ? Image.network(
                            '${AppConstance.imagePathApi}${widget.product.images.first}',
                            width: context.screenWidth,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          )
                          : Image.asset(ImageManager.noImage),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        widget.product.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 16, color: AppColors.black),
                      ),
                      const SizedBox(height: 2),
                      if ((widget.appliedDiscountResult?.appliedDiscount ?? 0) > 0)
                        CustomText(
                          text:
                              "${AppConstance.currencyFormat.format(total().toDouble() + (widget.appliedDiscountResult?.appliedDiscount ?? 0))} د.ع",
                          color: AppColors.redE7,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          textDecoration: TextDecoration.lineThrough,
                        ),
                      CustomText(
                        text: "${AppConstance.currencyFormat.format(total().toDouble())} د.ع",
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                CartSelectingQuantityButtons(
                  totalPrice: total().toDouble(),
                  minusButtonColor: AppColors.greyColor.withValues(alpha: 0.5),
                  increaseFunction: widget.increase,
                  decreaseFunction: widget.decrease,
                  quantity: widget.product.quantity,
                  viewBefore: true,
                  discount: widget.appliedDiscountResult?.appliedDiscount ?? 0,
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: notesController,
              keyboardType: TextInputType.text,
              hint: 'أضف ملاحظاتك للمنتج',
              onChanged: (v) {
                widget.product.notes = v;
                updateCartStorage();
              },
              onFieldSubmitted: (v) {
                widget.product.notes = v;
                updateCartStorage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
