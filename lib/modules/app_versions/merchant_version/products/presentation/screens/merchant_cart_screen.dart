import 'package:bastoga/core/caching/local_cart.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/widgets/max_discount_applier.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/components/components.dart';
import '../../../../../../core/helpers/dialog_helper.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../../client_version/home/domain/entities/product.dart';
import '../../../../client_version/home/presentation/widgets/cart_product_card_view.dart';
import '../../../../merchant_version/home/domain/entities/new_order_object.dart';

class MerchantCartScreen extends StatefulWidget {
  const MerchantCartScreen({super.key});

  @override
  State<MerchantCartScreen> createState() => _MerchantCartScreenState();
}

class _MerchantCartScreenState extends State<MerchantCartScreen> {
  double totalItemsPrice() {
    double total = 0;
    for (var item in cart) {
      final applied = _appliedDiscounts.firstWhere(
        (e) => e.item.id == item.id,
        orElse: () => AppliedDiscountResult(item: item, appliedDiscount: 0, unAppliedDiscount: 0),
      );

      item.mySellPrice = (item.price * item.quantity) - applied.appliedDiscount;
      total += item.mySellPrice;
    }
    return total;
  }

  double totalDiscountPrice() {
    double total = 0;
    for (var item in _appliedDiscounts) {
      total += item.appliedDiscount;
    }
    return total;
  }

  double remainDiscountPrice() {
    double total = 0;
    for (var item in _appliedDiscounts) {
      if (item.appliedDiscount > 0) {
        total += item.unAppliedDiscount;
      }
    }
    return total;
  }

  num merchantShippingPrice() {
    Product? product = cart.firstOrNull;
    if (product != null) {
      return product.merchant.merchantShippingPrice;
    } else {
      return 0;
    }
  }

  List<AppliedDiscountResult> _appliedDiscounts = [];

  @override
  void initState() {
    if (cart.isNotEmpty) {
      _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
        cartItems: cart,
        maxDiscountPerOrder: cart[0].merchant.maxDiscount,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: RichText(
          text: TextSpan(
            text: 'السلة ',
            style: const TextStyle(
              fontFamily: AppConstance.appFomFamily,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' (${cart.length}) منتجات',
                style: const TextStyle(
                  fontFamily: AppConstance.appFomFamily,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              if (context.read<MerchantProductsCubit>().cubitCartCount.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    DialogHelper.showCustomDialog(
                      context: context,
                      alertDialog: WarningAlertPopUp(
                        image: ImageManager.warningIcon,
                        description: 'هل أنت متأكد من حذف جميع المنتجات في السله ؟',
                        btnContent: 'حذف',
                        onPress: () {
                          context.pop();
                          context.read<MerchantProductsCubit>().clearAllCart();
                          Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
                            setState(() {});
                          });
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        ImageManager.deleteIcon,
                        height: 22,
                        colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body:
          cart.isNotEmpty
              ? BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: DefaultListView(
                          refresh: (page) async {},
                          itemBuilder:
                              (_, index) => CartProductCardView(
                                appliedDiscountResult:
                                    _appliedDiscounts.any((e) => e.item.id == cart[index].id)
                                        ? _appliedDiscounts.firstWhere(
                                          (e) => e.item.id == cart[index].id,
                                        )
                                        : null,
                                product: cart[index],
                                blocContext: context,
                                isMerchant: true,
                                increase: () {
                                  context.read<MerchantProductsCubit>().increaseProductInCartCubit(
                                    cart[index],
                                  );
                                  setState(() {
                                    _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                                      cartItems: cart,
                                      maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                                    );
                                  });
                                },
                                decrease: () {
                                  context
                                      .read<MerchantProductsCubit>()
                                      .decreaseProductFromCartCubit(cart[index]);
                                  setState(() {
                                    _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                                      cartItems: cart,
                                      maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                                    );
                                  });
                                },
                                remove: () {
                                  context.pop();
                                  context.read<MerchantProductsCubit>().removeProductFromCartCubit(
                                    cart[index],
                                  );
                                  setState(() {
                                    _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                                      cartItems: cart,
                                      maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                                    );
                                  });
                                },
                              ),
                          length: cart.length,
                          hasMore: false,
                          onRefreshCall: () async {
                            setState(() {
                              _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                                cartItems: cart,
                                maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                              );
                            });
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              child:
                                  cart.isNotEmpty && totalDiscountPrice() > 0
                                      ? Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.redE7,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        margin: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              ImageManager.offersIcon,
                                              height: 20,
                                              colorFilter: const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Flexible(
                                              child: FittedBox(
                                                child: CustomText(
                                                  text:
                                                      "خصم لغاية ${AppConstance.currencyFormat.format(cart[0].merchant.maxDiscount)} د.ع  ",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : null,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (totalDiscountPrice() > 0)
                                    _buildSummaryItem(
                                      context: context,
                                      label: 'توفير',
                                      value: totalDiscountPrice(),
                                    )
                                  else
                                    const SizedBox(),
                                  if (remainDiscountPrice() > 0)
                                    _buildSummaryItem(
                                      context: context,
                                      label: 'فرق الخصم',
                                      value: remainDiscountPrice(),
                                    ),
                                  _buildSummaryItem(
                                    context: context,
                                    label: 'الإجمالي',
                                    value: totalItemsPrice(),
                                    value1: totalItemsPrice() + totalDiscountPrice(),
                                    highlight: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: CustomElevated(
                                text: 'الطلب الآن',
                                press: () {
                                  context.pushNamed(
                                    Routes.merchantNewOrderScreen,
                                    arguments: NewOrderObject(
                                      blocContext: context,
                                      itemsPrice: totalItemsPrice(),
                                      merchantId: cart[0].merchant.id,
                                      maxDiscount: cart[0].merchant.maxDiscount,
                                      totalAppliedDiscount: totalDiscountPrice(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
              : NoData(
                refresh: () async {
                  setState(() {});
                },
              ),
    );
  }

  Widget _buildSummaryItem({
    required BuildContext context,
    required String label,
    required double value,
    double? value1,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, color: AppColors.black, fontSize: 12, fontWeight: FontWeight.w600),
        const SizedBox(height: 2),
        if (value1 != null && value1 > 0 && value1 != value)
          CustomText(
            text: "${AppConstance.currencyFormat.format(value1)} د.ع",
            color: AppColors.redE7,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textDecoration: TextDecoration.lineThrough,
          ),
        CustomText(
          text: "${AppConstance.currencyFormat.format(value)} د.ع",
          color: highlight ? AppColors.defaultColor : AppColors.black,
          fontSize: highlight ? 15 : 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
